from io import StringIO
import boto3
import time
import os
import json
import math
import traceback
from botocore.exceptions import ClientError

def get_parameters_from_ssm(ssm_client, params_names, x, tries=1):
    try:
        return ssm_client.get_parameters(Names=params_names[((x-1)*10):(x*10)], WithDecryption=True)
    except ClientError as exception_obj:
        if exception_obj.response['Error']['Code'] == 'ThrottlingException':
            if tries <= 3:
                print("Throttling Exception Occured.")
                print("Retrying.....")
                print("Attempt No.: " + str(tries))
                time.sleep(3)
                return get_parameters_from_ssm(ssm_client, params_names, x, tries + 1)
            else:
                print("Attempted 3 Times But No Success.")
                print("Raising Exception.....")
                raise
        else:
            raise

def ssm_backup():
    # fetch environment variables
    s3_bucket = os.getenv('S3_BUCKET')
    kms_key_arn = os.getenv('KMS_KEY_ARN')
    time_string = time.strftime("%Y-%m-%d-%H-%M")

    # create param variables
    params = []
    params_names = []
    params_values = {}
    str_params = ''

    # create S3 and SSM clients
    s3_client = boto3.client('s3')
    ssm_client = boto3.client('ssm')

    # describe parameters (without values)
    ssm_paginator = ssm_client.get_paginator('describe_parameters')

    # create page iterator
    page_iterator = ssm_paginator.paginate()

    # get param names
    for page in page_iterator:
        for item in page['Parameters']:
            params.append(item)
            params_names.append(item['Name'])

    # get param values
    params_names_loop = math.ceil(len(params_names) / 10) + 1

    for x in range(1, params_names_loop):
        response = get_parameters_from_ssm(ssm_client, params_names, x, 1)

        for item in response['Parameters']:
            params_values[item['Name']] = item['Value']

    # add values to parameters list
    for param in params:
        param['Value'] = params_values[param['Name']]
        str_params += json.dumps(param, default=str) + ",\n"

    # fix json string
    str_params = "[\n" + str_params + "]"
    str_params = str_params.replace(",\n]", "\n]")

    # write to s3 bucket
    fake_handle = StringIO(str_params)
    s3_client.put_object(Bucket=s3_bucket, Key="backups/parameters-" + time_string + ".json", Body=fake_handle.read(), ServerSideEncryption='aws:kms', SSEKMSKeyId=kms_key_arn)

    print("Successfully taken the backup of all the parameters residing on AWS SSM Parameter Store.")

def lambda_handler(event, context):
    try:
        ssm_backup()

        # return success
        return "Lambda function executed successfully."
    except Exception as e:
        # return exception
        tb = traceback.format_exc()
        print(tb)
        return tb

# locally test the code
if __name__ == "__main__":
    event = []
    context = []
    print(lambda_handler(event, context))
