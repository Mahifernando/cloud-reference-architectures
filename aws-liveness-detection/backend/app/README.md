# Build Lambda image

Build lambda function image

```
docker build -t liveness-challenge .
```

Authenticate docker with AWS ECR login. Replace 'REGION-NAME-REPLACE' and 'ACCOUNT-ID-REPLACE' placeholders with you AWS account detail. 

```
aws ecr get-login-password --region <REGION-NAME-REPLACE> | docker login --username AWS --password-stdin <ACCOUNT-ID-REPLACE>.dkr.ecr.<REGION-NAME-REPLACE>.amazonaws.com    
```

Create repository in AWS ECR

```
aws ecr create-repository --repository-name liveness-challenge --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE
```

Tag and push image to AWS ECR.

```
docker tag liveness-challenge:latest <ACCOUNT-ID-REPLACE>.dkr.ecr.<REGION-NAME-REPLACE>.amazonaws.com/liveness-challenge:latest
docker push <ACCOUNT-ID-REPLACE>.dkr.ecr.<REGION-NAME-REPLACE>.amazonaws.com/liveness-challenge:latest 
```

Testing your container locally with test events. Also provide ENV variables to the container (i.e. REGION_NAME, BUCKET_NAME etc.).

```
docker run -p 8080:8080 liveness-challenge
curl -XPOST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{event-payload-replace}'
```

For further reading please check on [AWS documentation](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html)