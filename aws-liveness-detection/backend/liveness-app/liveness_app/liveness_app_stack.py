from aws_cdk import (
    Stack,
    aws_lambda as _lambda,
    aws_apigateway as _apigateway,
    aws_s3 as _s3,
    aws_dynamodb as _dynamodb,
    aws_secretsmanager as _secretsmanager,
    aws_iam as _iam,
)

from constructs import Construct

class LivenessAppStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Image store (S3)
        framesBucket = _s3.Bucket(self, "FramesBucket", versioned=True, encryption=_s3.BucketEncryption.S3_MANAGED)

        # Frontend website UI (S3)
        staticWebsiteBucket = _s3.Bucket(self, "StaticWebsiteBucket", versioned=True, encryption=_s3.BucketEncryption.S3_MANAGED)

        # Data store (DynamoDB)
        table = _dynamodb.Table(self, "ChallengesTable", partition_key=_dynamodb.Attribute(name="id", type=_dynamodb.AttributeType.STRING))

        # Secrets store (Secrets Manager)
        secretsmanager = _secretsmanager.Secret(self, "TokenSecret")

        # IAM
        challengeFunctionRole = _iam.Role(self, "ChallengeFunctionRole", assumed_by=_iam.ServicePrincipal("lambda.amazonaws.com"))

        challengeFunctionRole.add_managed_policy(_iam.ManagedPolicy.from_aws_managed_policy_name("CloudWatchLogsFullAccess"))
        challengeFunctionRole.add_managed_policy(_iam.ManagedPolicy.from_aws_managed_policy_name("AmazonDynamoDBFullAccess"))
        challengeFunctionRole.add_managed_policy(_iam.ManagedPolicy.from_aws_managed_policy_name("AmazonRekognitionFullAccess"))
        challengeFunctionRole.add_managed_policy(_iam.ManagedPolicy.from_aws_managed_policy_name("AmazonS3FullAccess"))
        challengeFunctionRole.add_managed_policy(_iam.ManagedPolicy.from_aws_managed_policy_name("SecretsManagerReadWrite"))

        challengeFunctionRole.add_to_policy(_iam.PolicyStatement(effect=_iam.Effect.ALLOW, resources=["*"], actions=["sts:AssumeRole"]))

        # Lambda function
        challengeFunction = _lambda.Function(self, 'ChallengeFunction',
                                    runtime=_lambda.Runtime.PYTHON_3_9,
                                    code=_lambda.Code.from_asset('lambda'),
                                    handler='challenge_service.handler',
                                    role=challengeFunctionRole,
                                    environment={
                                        "REGION_NAME": self.region,
                                        "BUCKET_NAME": framesBucket.bucket_name,
                                        "DDB_TABLE": table.table_name,
                                        "TOKEN_SECRET_ARN": secretsmanager.secret_arn
                                    })

        # API gateway
        api = _apigateway.LambdaRestApi(self, 'ChallengeApi', handler=challengeFunction)