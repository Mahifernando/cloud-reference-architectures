# Lambda handler debug script

import json

def handler(event, context):
    print('{}'.format(json.dumps(event)))
    response = { 'event_path' : event['path'], 'message': 'execute lambda function via api gateway' }
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,POST',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
            'Content-Type': 'application/json'
        },
        'body': json.dumps(response)
    }
