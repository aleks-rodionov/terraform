import logging
import boto3
import sys
from botocore.exceptions import ClientError

def upload_file(file_name, bucket, object_name=None):
    """Upload a file to an S3 bucket
    :param file_name: File to upload
    :param bucket: Bucket to upload to
    :param object_name: S3 object name. If not specified then file_name is used
    :return: True if file was uploaded, else False
    """
    # If S3 object_name was not specified, use file_name
    if object_name is None:
        object_name = file_name
    # Upload the file
    s3_client = boto3.client('s3')
    try:
        response = s3_client.upload_file(file_name, bucket, object_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True

def main():

    file_path_name = sys.argv[1]
    bucket         = sys.argv[2]
    object_name    = file_path_name.split('/')[-1]

    if file_path_name != "" and bucket != "":
       upload_file(file_path_name, bucket, object_name)

main()
