from __future__ import absolute_import
from __future__ import print_function

import json
import os
import sqlite3
from datetime import datetime
from datetime import timezone
from os import path, makedirs
from shutil import disk_usage

import boto3
import requests
import werkzeug
from flask import Flask, redirect, request, url_for
from flask import render_template
from flask_login import (
    LoginManager,
    current_user,
    login_required,
    login_user,
    logout_user,
)
from oauthlib.oauth2 import WebApplicationClient

from Retinopathy2.retinopathy.dataset import get_class_names
from S3Handler import download_from_s3
from db import init_db_command
from inference import model_fn, predict_fn
from user import User

# GOOGLE_CLIENT_ID = os.environ.get("GOOGLE_CLIENT_ID", None)
# GOOGLE_CLIENT_SECRET = os.environ.get("GOOGLE_CLIENT_SECRET", None)

GOOGLE_CLIENT_ID = ""
GOOGLE_CLIENT_SECRET = ""

GOOGLE_DISCOVERY_URL = (
    "https://accounts.google.com/.well-known/openid-configuration"
)

'''Not Changing variables'''
region = 'us-east-1'
dynamodb_region = 'ap-south-1'
dynamodb_retinopathy_tablename = 'retinopathy2'
model_name = 'seresnext50d_gwap'
model_bucket = 'dataset-retinopathy'
checkpoint_fname = 'model.pth'
model_dir = '/home/model'

data_bucket = "diabetic-retinopathy-data-from-radiology"
data_dir = '/home/endpoint/data'

need_features = False
tta = None

apply_softmax = True
port = 80
debug = True

app = Flask(__name__)
app.secret_key = os.environ.get("SECRET_KEY") or os.urandom(24)

login_manager = LoginManager()
login_manager.init_app(app)

# Naive database setup
try:
    init_db_command()
except sqlite3.OperationalError:
    pass

client = WebApplicationClient(GOOGLE_CLIENT_ID)


@app.errorhandler(werkzeug.exceptions.BadRequest)
def handle_bad_request(e):
    return 'bad request!', 400


@login_manager.unauthorized_handler
def unauthorized():
    return "You must be logged in to access this content.", 403


@login_manager.user_loader
def load_user(user_id):
    return User.get(user_id)


def get_google_provider_cfg():
    return requests.get(GOOGLE_DISCOVERY_URL).json()


@app.route('/')
def index():
    preds_html = []
    preds_html.append([None, "static/img/10011_right_820x615.png".split('/')[-1],
                       [[0.84909, 'No DR'], [0.09395, 'Mild'], [0.04669, 'Moderate'],
                        [0.00633, 'Severe'], [0.00392, 'Proliferative DR']],
                       '0- No DR', 0.40505, 2.024725])
    if current_user.is_authenticated:
        return render_template("index.html", user_authenticated=True,
                               preds_html=preds_html, current_user=current_user)
    else:
        return render_template("index.html", user_authenticated=False,
                               preds_html=preds_html, current_user=current_user)


@app.route('/ping', methods=['GET'])
def ping():
    print(f'Found a {request.method} request for prediction. form ping()')
    return redirect(url_for("index"))


@app.route("/login")
def login():
    google_provider_cfg = get_google_provider_cfg()
    authorization_endpoint = google_provider_cfg["authorization_endpoint"]
    request_uri = client.prepare_request_uri(
        authorization_endpoint,
        redirect_uri=request.base_url + "/callback",
        scope=["openid", "email", "profile"],
    )
    return redirect(request_uri)


@app.route("/login/callback")
def callback():
    # Get authorization code Google sent back to you
    code = request.args.get("code")

    # Find out what URL to hit to get tokens that allow you to ask for
    # things on behalf of a user
    google_provider_cfg = get_google_provider_cfg()
    token_endpoint = google_provider_cfg["token_endpoint"]

    # Prepare and send request to get tokens! Yay tokens!
    token_url, headers, body = client.prepare_token_request(
        token_endpoint,
        authorization_response=request.url,
        redirect_url=request.base_url,
        code=code,
    )
    token_response = requests.post(
        token_url,
        headers=headers,
        data=body,
        auth=(GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET),
    )

    # Parse the tokens!
    client.parse_request_body_response(json.dumps(token_response.json()))

    # Now that we have tokens (yay) let's find and hit URL
    # from Google that gives you user's profile information,
    # including their Google Profile Image and Email
    userinfo_endpoint = google_provider_cfg["userinfo_endpoint"]
    uri, headers, body = client.add_token(userinfo_endpoint)
    userinfo_response = requests.get(uri, headers=headers, data=body)

    # We want to make sure their email is verified.
    # The user authenticated with Google, authorized our
    # app, and now we've verified their email through Google!
    if userinfo_response.json().get("email_verified"):
        unique_id = userinfo_response.json()["sub"]
        users_email = userinfo_response.json()["email"]
        picture = userinfo_response.json()["picture"]
        users_name = userinfo_response.json()["given_name"]
    else:
        return "User email not available or not verified by Google.", 400

    # Create a user in our db with the information provided
    # by Google
    user = User(
        id_=unique_id, name=users_name, email=users_email, profile_pic=picture
    )

    # Doesn't exist? Add to database
    if not User.get(unique_id):
        User.create(unique_id, users_name, users_email, picture)

    # Begin user session by logging the user in
    login_user(user)

    # Send user back to homepage
    return redirect(url_for("index"))


@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("index"))


class ClassificationService(object):
    model = None  # Where we keep the model when it's loaded
    dynamodb_cli = None
    s3_res_bucket = None

    @classmethod
    def IsVerifiedUser(cls, request):
        if request.content_type == 'application/json':
            return True
        else:
            return False

    @classmethod
    def cleanDirectory(cls):
        space_left = disk_usage('/').free / 1e9
        if space_left < 1:
            print(f"{space_left} GB of space left so cleaning {data_dir} dir")
            for root, dirs, files in os.walk(data_dir):
                for f in files:
                    os.unlink(os.path.join(root, f))

    @classmethod
    def get_model(cls):
        if cls.model is None:
            cls.model = model_fn(model_dir=model_dir, model_name=model_name, checkpoint_fname=checkpoint_fname,
                                 apply_softmax=apply_softmax, tta=tta)
        return cls.model

    @classmethod
    def InputPredictOutput(cls, image_locs, model):
        return predict_fn(model=model, need_features=need_features, image_locs=image_locs, data_dir=data_dir)

    @classmethod
    def DynamoDBPutItem(cls, item):
        if cls.dynamodb_cli is None:
            cls.dynamodb_cli = boto3.client('dynamodb', region_name=dynamodb_region)
        else:
            res = cls.dynamodb_cli.put_item(TableName=dynamodb_retinopathy_tablename, Item=item)

    @classmethod
    def upload_to_s3_(cls, bucket, channel, filepath):  # public=true, if not file won't be visible after prediction
        if cls.s3_res_bucket is None:
            cls.s3_res_bucket = boto3.resource('s3', region_name=region).Bucket(bucket)
        else:
            data = open(filepath, "rb")
            key = channel + '/' + str(filepath).split('/')[-1]
            cls.s3_res_bucket.put_object(Key=key, Body=data, ACL='public-read')


@app.route('/', methods=['POST'])
def transformation():
    ClassificationService.cleanDirectory()

    print(f'Found a {request.method} request for prediction...')
    if request.method == "POST":
        image_files = request.files["image"]
        image_locs = []
        if image_files:
            print(f'Saving image file')
            print(image_files)
            image_file = image_files
            # for image_file in image_files:
            img_path = os.path.join(data_dir, image_file.filename)
            image_locs.append(img_path)
            image_file.save(img_path)
            model = ClassificationService.get_model()
            predictions = ClassificationService.InputPredictOutput(model=model, image_locs=image_locs)
            print("rendering index.html with predictions and image file,")
            preds_html = []
            CLASS_NAMES = get_class_names(coarse_grading=False)
            invocation_time = datetime.now(tz=timezone.utc).strftime('%y-%m-%d %H:%M:%S')

            for i in range(len(predictions)):
                logits = []
                for pred, cls in zip(predictions['logits'][i], CLASS_NAMES):
                    logits.append([round(pred, 5), cls])

                img_loc = f"https://diabetic-retinopathy-data-from-radiology.s3.amazonaws.com/image/{image_locs[i].split('/')[-1]}"
                image_id = predictions['image_id'][i]
                diagnosis = int(predictions['diagnosis'][i])
                # diagnosis = f"{diagnosis}- {CLASS_NAMES[diagnosis]}"
                regression = round(predictions['regression'][i], 5)
                ordinal = round(predictions['ordinal'][i], 5)
                preds_html[i].append([img_loc, image_id, logits, diagnosis, regression, ordinal])
                item = {
                    'invocation_time': {'S': str(invocation_time)},
                    'user_id': {'S', str(current_user.id)},
                    'name': {'S', str(current_user.name)},
                    'email': {'S', str(current_user.email)},
                    'image_id': {'S': image_id},
                    'logits': {'S': str(logits)},
                    'diagnosis': {'S': diagnosis},
                    'regression': {'S': str(regression)},
                    'ordinal': {'S': str(ordinal)},
                }
                ClassificationService.DynamoDBPutItem(item=item)
                ClassificationService.upload_to_s3_(bucket=data_bucket, channel="image", filepath=image_locs[i])

            return render_template("index.html", user_authenticated=False,
                                   preds_html=preds_html, current_user=current_user)
    return redirect(url_for("index"))


if __name__ == "__main__":
    print("Initialising app, checking directories and model files...")
    if not path.exists(data_dir):
        makedirs(data_dir, exist_ok=True)

    if not path.exists(model_dir):
        makedirs(model_dir, exist_ok=True)

    if not path.isfile(path.join(model_dir, checkpoint_fname)):
        download_from_s3(region=region, bucket=model_bucket,
                         s3_filename='deployment/' + checkpoint_fname,
                         local_path=path.join(model_dir, checkpoint_fname))
    ClassificationService.get_model()  # You can insert a health check here
    print(f'Initialising app on {requests.get("http://ip.42.pl/raw").text}:{port} with dubug={debug}')
    app.run(host="0.0.0.0", port=port)  # for running on instances
    # app.run(host="0.0.0.0", port=port, debug=debug, ssl_context="adhoc")  # for running on instances
    # app.run(debug=True, ssl_context="adhoc")
