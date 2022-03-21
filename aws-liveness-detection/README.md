# AWS Liveness Detection

This example repository is based on below blog posts and [AWS Liveness Detection Framework](https://aws.amazon.com/solutions/implementations/liveness-detection-framework)

[Improving fraud prevention in financial institutions by building a liveness detection architecture](https://aws.amazon.com/pt/blogs/industries/improving-fraud-prevention-in-financial-institutions-by-building-a-liveness-detection-solution/)

[Liveness Detection to Improve Fraud Prevention in Financial Institutions with Amazon Rekognition](https://aws.amazon.com/blogs/industries/liveness-detection-to-improve-fraud-prevention-in-financial-institutions-with-amazon-rekognition/)


## Architecture

### C4 Model

Modelling and diagramming is using C4 models. The workspace file is located in the "C4" directory. You can export C4 diagrams using [structurizr](https://structurizr.com/dsl) website for free or docker image.

To run C4 structurizr container locally, replace below command (C4_WORKSPACE_PATH) with your workspace directory path.

```
docker pull structurizr/lite
docker run -it --rm -p 8080:8080 -v C4_WORKSPACE_PATH:/usr/local/structurizr structurizr/lite
```


![System Context diagram](/aws-liveness-detection/C4/structurizr-1-LivenessDetection-SystemContext.png "System Context diagram")

![Container diagram](/aws-liveness-detection/C4/structurizr-1-LivenessDetection-Container.png "Container diagram")

![AWS Cloud deployment diagram](/aws-liveness-detection/C4/structurizr-1-AmazonWebServicesDeployment.png "AWS Cloud deployment diagram")