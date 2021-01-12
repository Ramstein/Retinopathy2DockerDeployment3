"""
This is the file that implements a flask server to do inferences. It's the file that you will modify to
implement the scoring for your own algorithm.
"""

from __future__ import absolute_import
from __future__ import print_function

import os
from os import path, makedirs
from shutil import disk_usage

import flask
import requests
import werkzeug
from flask import render_template
from flask import request

from Retinopathy2.retinopathy.dataset import get_class_names
from S3Handler import upload_to_s3, download_from_s3
from inference import model_fn, predict_fn

'''Not Changing variables'''
region = 'us-east-1'
model_name = 'seresnext50d_gwap'
model_bucket = 'dataset-retinopathy'
checkpoint_fname = 'model.pth'
model_dir = '/home/model'

data_bucket = "diabetic-retinopathy-data-from-radiology"
data_dir = '/home/endpoint/data'

need_features = False
tta = None
apply_softmax = True


class ClassificationService(object):
    model = None  # Where we keep the model when it's loaded

    @classmethod
    def IsVerifiedUser(cls, request):
        """Get the json data from flask.request."""
        if request.content_type == 'application/json':
            return True
        else:
            return False

    @classmethod
    def cleanDirectory(cls):
        space_left = disk_usage('/').free / 1e9
        if space_left < 1:
            print(f", {space_left} GB of space left, so cleaning {data_dir} dir")
            for root, dirs, files in os.walk(data_dir):
                for f in files:
                    os.unlink(os.path.join(root, f))

    @classmethod
    def get_model(cls):
        """Get the model object for this instance, loading it if it's not already loaded."""
        if cls.model is None:
            cls.model = model_fn(model_dir=model_dir, model_name=model_name, checkpoint_fname=checkpoint_fname,
                                 apply_softmax=apply_softmax, tta=tta)
        return cls.model

    @classmethod
    def InputPredictOutput(cls, img_loc, model):
        """For the input, do the predictions and return them.
        Args:"""
        return predict_fn(model=model, need_features=need_features, img_loc=img_loc, data_dir=data_dir)


# The flask app for serving predictions
app = flask.Flask(__name__)


@app.errorhandler(werkzeug.exceptions.BadRequest)
def handle_bad_request(e):
    return 'bad request!', 400


@app.route('/ping', methods=['GET'])
def ping():
    """Determine if the container is working and healthy. In this sample container, we declare
    it healthy if we can load the model successfully."""
    print(f'Found a {request.method} request for prediction. form ping()')

    health = ClassificationService.get_model() is not None  # You can insert a health check here
    # status = 200 if health else 404
    return render_template("index.html", image_loc=None,
                           image_id="static/img/10011_right_820x615.png".split('/')[-1],
                           logits=[[0.84909, 'No DR'], [0.09395, 'Mild'], [0.04669, 'Moderate'],
                                   [0.00633, 'Severe'], [0.00392, 'Proliferative DR']],
                           diagnosis='0- No DR',
                           regression=0.40505,
                           ordinal=2.024725)


@app.route('/')
def home():
    return render_template("index.html", image_loc=None,
                           image_id="static/img/10011_right_820x615.png".split('/')[-1],
                           logits=[[0.84909, 'No DR'], [0.09395, 'Mild'], [0.04669, 'Moderate'],
                                   [0.00633, 'Severe'], [0.00392, 'Proliferative DR']],
                           diagnosis='0- No DR',
                           regression=0.40505,
                           ordinal=2.024725)


@app.route('/', methods=['POST'])
def transformation():
    """Do an inference on a single batch of data. In this sample server, we take data as CSV, convert
    it to a pandas data frame for internal use and then convert the predictions back to CSV (which really
    just means one prediction per line, since there's a single column.
    """
    print('Checking that directory needs to be cleaned or not...')
    ClassificationService.cleanDirectory()

    print(f'Found a {request.method} request for prediction...')
    if request.method == "POST":
        image_file = request.files["image"]
        if image_file:
            img_loc = os.path.join(data_dir, image_file.filename)
            print('Saving image file')
            image_file.save(img_loc)
            model = ClassificationService.get_model()
            print("Making predictions on image file.", img_loc)
            predictions = ClassificationService.InputPredictOutput(img_loc, model=model)
            # predictions = {'image_id': "/home/endpoint/data/test.png",  # # predictions is a dict
            #                'logits': 65651,
            #                'regression': 4545,
            #                'ordinal': 98,
            #                'diagnosis': 0,
            #                }
            print("rendering index.html with predictions and image file, predictions=", predictions)

            logits = []
            CLASS_NAMES = get_class_names(coarse_grading=False)
            for pred, cls in zip(predictions['logits'][0], CLASS_NAMES):
                logits.append([round(pred, 5), cls])

            render_template("index.html", image_loc=image_file.filename,
                            image_id=predictions['image_id'][0],
                            logits=logits,
                            diagnosis=str(predictions['diagnosis']) + "- " + CLASS_NAMES[predictions['diagnosis']],
                            regression=predictions['regression'],
                            ordinal=predictions['ordinal'])
            upload_to_s3(channel="image", filepath=img_loc, bucket=data_bucket, region=region)
    return render_template("index.html", image_loc=None,
                           image_id="static/img/10011_right_820x615.png".split('/')[-1],
                           logits=[[0.84909, 'No DR'], [0.09395, 'Mild'], [0.04669, 'Moderate'],
                                   [0.00633, 'Severe'], [0.00392, 'Proliferative DR']],
                           diagnosis='0- No DR',
                           regression=0.40505,
                           ordinal=2.024725)


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
    print("loading the model", path.join(model_dir, checkpoint_fname))
    health = ClassificationService.get_model() is not None  # You can insert a health check here
    status = 200 if health else 404
    print("status:", status)
    print(f'Initialising app on {requests.get("http://ip.42.pl/raw").text}:{8888}')
    app.run(host="0.0.0.0", port=8888, debug=True)  # for running on instances
    # app.run(debug=True)
