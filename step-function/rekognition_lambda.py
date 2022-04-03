import json
import boto3

def lambda_handler(event, context):
    bucket = "star-trek-andreworg"
    key = "1.jpg"
    rekognition = boto3.client("rekognition", 'us-east-1')
    response = rekognition.detect_faces(Image={
        "S3Object": {
            "Bucket": bucket,
            "Name": key
        }
    }
    )
    return response['FaceDetails']