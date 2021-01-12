import argparse
import multiprocessing
import os
import time

import boto3
import pandas as pd
import torch
from botocore.exceptions import ClientError
from pytorch_toolbelt.utils import fs

from Retinopathy2.retinopathy.inference import run_model_inference


def download_from_s3(s3_filename, local_path="test"):
    bucket = "diabetic-retinopathy-data-from-radiology"
    region_name = "us-east-1"

    s3_client = boto3.client('s3', region_name=region_name)
    # print("Downloading file {} to {}".format(s3_filename, local_path))
    try:
        s3_client.download_file(bucket, Key=s3_filename, Filename=local_path)
    except ClientError as e:
        if e.response['Error']['Code'] == "404":
            print("The object does not exist.")
        else:
            raise


def image_with_name_in_dir(dirname, image_id):
    for ext in ['png', 'jpg', 'jpeg', 'tif']:
        image_path = os.path.join(dirname, f'{image_id}.{ext}')
        if os.path.isfile(image_path):
            return image_path
    raise FileNotFoundError(image_path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input', nargs='+')
    parser.add_argument('--need-features', action='store_true')
    parser.add_argument('-b', '--batch-size', type=int, default=multiprocessing.cpu_count(),
                        help='Batch Size during training, e.g. -b 64')
    parser.add_argument('-w', '--workers', type=int, default=4, help='')

    args = parser.parse_args()
    need_features = args.need_features
    batch_size = args.batch_size
    num_workers = args.workers
    checkpoint_fname = args.input  # pass just single checkpoint filename as arg

    '''Not Changing variables'''
    data_dir = '/opt/ml/code/'
    checkpoint_path = os.path.join(data_dir, 'model', checkpoint_fname)
    current_milli_time = lambda: str(round(time.time() * 1000))

    if torch.cuda.is_available():
        checkpoint = torch.load(checkpoint_path)
    else:
        checkpoint = torch.load(checkpoint_path, map_location=lambda storage, loc: storage)
    params = checkpoint['checkpoint_data']['cmd_args']

    # Make OOF predictions
    images_dir = os.path.join(data_dir, "ratinopathy", current_milli_time())

    retino = pd.read_csv(os.path.join(data_dir, 'aptos-2019', 'test.csv'))
    '''Downloading fundus photography files'''
    for id_code in retino['id_code']:
        download_from_s3(s3_filename="aptos-2019/train.csv", local_path=os.path.join(images_dir, id_code))

    image_paths = retino['id_code'].apply(lambda x: image_with_name_in_dir(images_dir, x))

    # Now run inference on Aptos2019 public test, will return a pd.DataFrame having image_id, logits, regrssions, ordinal, features
    ratinopathy = run_model_inference(checkpoint=checkpoint,
                                      params=params,
                                      apply_softmax=True,
                                      need_features=need_features,
                                      retino=retino,
                                      image_paths=image_paths,
                                      batch_size=batch_size,
                                      tta='fliplr',
                                      workers=num_workers,
                                      crop_black=True)
    ratinopathy.to_pickle(fs.change_extension(checkpoint_fname, '_ratinopathy_predictions.pkl'))

    # for i, checkpoint_fname in enumerate(checkpoints):
    #     # print(i, checkpoint_fname)
    #     if False:
    #         # Now run inference on Aptos2019 public test, will return a pd.DataFrame having image_id, logits, regrssions, ordinal, features
    #         aptos2019_test = run_model_inference(model_checkpoint=checkpoint_fname,
    #                                              apply_softmax=True,
    #                                              need_features=need_features,
    #                                              test_csv=pd.read_csv(os.path.join(data_dir, 'aptos-2019', 'test.csv')),
    #                                              data_dir=os.path.join(data_dir, 'aptos-2019'),
    #                                              images_dir='test_images_768',
    #                                              batch_size=batch_size,
    #                                              tta='fliplr',
    #                                              workers=num_workers,
    #                                              crop_black=True)
    #         aptos2019_test.to_pickle(fs.change_extension(checkpoint_fname, '_aptos2019_test_predictions.pkl'))
    #
    #     # Now run inference on Aptos2015 private test
    #     if False:
    #         aptos2015_df = pd.read_csv(os.path.join(data_dir, 'aptos-2015', 'test_labels.csv'))
    #         aptos2015_df = aptos2015_df[aptos2015_df['Usage'] == 'Private']
    #         aptos2015_test = run_model_inference(model_checkpoint=checkpoint_fname,
    #                                              apply_softmax=True,
    #                                              need_features=need_features,
    #                                              test_csv=aptos2015_df,
    #                                              data_dir=os.path.join(data_dir, 'aptos-2015'),
    #                                              images_dir='test_images_768',
    #                                              batch_size=batch_size,
    #                                              tta='fliplr',
    #                                              workers=num_workers,
    #                                              crop_black=True)
    #         aptos2015_test.to_pickle(fs.change_extension(checkpoint_fname, '_aptos2015_test_private_predictions.pkl'))
    #
    #     if False:
    #         aptos2015_df = pd.read_csv(os.path.join(data_dir, 'aptos-2015', 'test_labels.csv'))
    #         aptos2015_df = aptos2015_df[aptos2015_df['Usage'] == 'Public']
    #         aptos2015_test = run_model_inference(model_checkpoint=checkpoint_fname,
    #                                              apply_softmax=True,
    #                                              need_features=need_features,
    #                                              test_csv=aptos2015_df,
    #                                              data_dir=os.path.join(data_dir, 'aptos-2015'),
    #                                              images_dir='test_images_768',
    #                                              batch_size=batch_size,
    #                                              tta='fliplr',
    #                                              workers=num_workers,
    #                                              crop_black=True)
    #         aptos2015_test.to_pickle(fs.change_extension(checkpoint_fname, '_aptos2015_test_public_predictions.pkl'))
    #
    #     if False:
    #         aptos2015_df = pd.read_csv(os.path.join(data_dir, 'aptos-2015', 'train_labels.csv'))
    #         aptos2015_test = run_model_inference(model_checkpoint=checkpoint_fname,
    #                                              apply_softmax=True,
    #                                              need_features=need_features,
    #                                              test_csv=aptos2015_df,
    #                                              data_dir=os.path.join(data_dir, 'aptos-2015'),
    #                                              images_dir='train_images_768',
    #                                              batch_size=batch_size,
    #                                              tta='fliplr',
    #                                              workers=num_workers,
    #                                              crop_black=True)
    #         aptos2015_test.to_pickle(fs.change_extension(checkpoint_fname, '_aptos2015_train_predictions.pkl'))
    #     if False:
    #         train_ds, valid_ds, train_sizes = get_datasets(data_dir=params['data_dir'],
    #                                                        use_aptos2019=params['use_aptos2019'],
    #                                                        use_aptos2015=params['use_aptos2015'],
    #                                                        use_idrid=params['use_idrid'],
    #                                                        use_messidor=params['use_messidor'],
    #                                                        use_unsupervised=False,
    #                                                        image_size=(image_size, image_size),
    #                                                        augmentation=params['augmentations'],
    #                                                        preprocessing=params['preprocessing'],
    #                                                        target_dtype=int,
    #                                                        coarse_grading=params.get('coarse', False),
    #                                                        fold=i,
    #                                                        folds=4)
    #         print(len(valid_ds))
    #         oof_predictions = run_model_inference_via_dataset(checkpoint_fname,
    #                                                           valid_ds,
    #                                                           apply_softmax=True,
    #                                                           need_features=need_features,
    #                                                           batch_size=batch_size,
    #                                                           workers=num_workers)
    #
    #         dst_fname = fs.change_extension(checkpoint_fname, '_oof_predictions.pkl')
    #         oof_predictions.to_pickle(dst_fname)
    #
    #     # Now run inference on holdout IDRID Test dataset
    #     if False:
    #         idrid_test = run_model_inference(model_checkpoint=checkpoint_fname,
    #                                          apply_softmax=True,
    #                                          need_features=need_features,
    #                                          test_csv=pd.read_csv(os.path.join(data_dir, 'idrid', 'test_labels.csv')),
    #                                          data_dir=os.path.join(data_dir, 'idrid'),
    #                                          images_dir='test_images_768',
    #                                          batch_size=batch_size,
    #                                          tta='fliplr',
    #                                          workers=num_workers,
    #                                          crop_black=True)
    #         idrid_test.to_pickle(fs.change_extension(checkpoint_fname, '_idrid_test_predictions.pkl'))
    #
    #     if False:
    #         # Now run inference on Messidor 2 Test dataset
    #         messidor2_train = run_model_inference(model_checkpoint=checkpoint_fname,
    #                                               apply_softmax=True,
    #                                               need_features=need_features,
    #                                               test_csv=pd.read_csv(
    #                                                   os.path.join(data_dir, 'messidor_2', 'train_labels.csv')),
    #                                               data_dir=os.path.join(data_dir, 'messidor_2'),
    #                                               images_dir='train_images_768',
    #                                               batch_size=batch_size,
    #                                               tta='fliplr',
    #                                               workers=num_workers,
    #                                               crop_black=True)
    #         messidor2_train.to_pickle(fs.change_extension(checkpoint_fname, '_messidor2_train_predictions.pkl'))


if __name__ == '__main__':
    main()
