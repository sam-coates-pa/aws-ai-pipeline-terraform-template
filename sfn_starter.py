# sfn_starter.py

import json
import boto3 # type: ignore
import os

def lambda_handler(event, context):
    # Initialise the Step Functions client
    step = boto3.client('stepfunctions')

    # Start execution of the Step Function
    response = step.start_execution(
        stateMachineArn=os.environ['STEP_FUNCTION_ARN'],
        input=json.dumps(event)
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Step Function triggered successfully!')
    }