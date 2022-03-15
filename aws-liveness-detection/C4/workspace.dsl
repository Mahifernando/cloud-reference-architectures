workspace "AWS Liveness Detection" "Liveness Detection reference architecture." {

    model {
        user = person "User" "Participate in the liveness detection process"

        enterprise "Fraud Analysis" {
            livenessDetectionSystem = softwaresystem "Liveness Detection" "Liveness Detection to improve fraud prevention" "AWS Serverless" {
                uiApp = container "UI" "captures user image using the device camera and invokes challenge service for liveness verification" "Javascript" "Frontend"
                livenessChallengeService = container "Liveness Challenge" "Implement challenge verification methods" "Python" "Backend"
                challengeDb = container "Data store" "Stores challenge data" "Amazon DynamoDB" "Store"
                imageStore = container "Image store" "Stores user images" "Amazon S3" "Store"
                recognitionService = container "Image Recognition" "Deep learning-powered image recognition service that analyses user images" "Amazon Rekognition"
                secretStore = container "Secrets Store" "Service that stores the secret used to sign tokens" "AWS Secrets Manager" "Store"
            }
        }

        user -> uiApp "provides image and detect liveness" "HTTP"
        uiApp -> livenessChallengeService "verify" "REST API"
        livenessChallengeService -> challengeDb "Read and write challenge data"
        livenessChallengeService -> imageStore "Write user image"
        livenessChallengeService -> recognitionService "Parse image for recognition"
        livenessChallengeService -> secretStore "sign token"

        cloud = deploymentEnvironment "Cloud" {
            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud"

                frontend = deploymentNode "AWS CloudFront" {
                    tags = "Amazon Web Services - CloudFront"
                    uiAppInstance = containerInstance uiApp
                }

                apiGateway = infrastructureNode "Amazon API Gateway" {
                    tags = "Amazon Web Services - API Gateway"
                }

                lambda = deploymentNode "AWS Lambda" {
                        tags = "Amazon Web Services - Lambda"
                        livenessChallengeServiceInstance = containerInstance livenessChallengeService
                    }
                
                s3 = deploymentNode "Amazon S3" {
                    tags = "Amazon Web Services - Simple Storage Service S3 Bucket"
                    imageStoreInstance = containerInstance imageStore

                }

                dynamoDb = deploymentNode "Amazon DynamoDB" {
                    tags = "Amazon Web Services - DynamoDB"
                    challengeDbInstance = containerInstance challengeDb
                }

                rekognition = deploymentNode "Amazon Rekognition" {
                    tags = "Amazon Web Services - Rekognition"
                    recognitionServiceInstance = containerInstance recognitionService
                }
                
                secretManager = deploymentNode "AWS Secrets Manager" {
                    tags = "Amazon Web Services - Secrets Manager"
                    secretStoreInstance = containerInstance secretStore
                }
            }

            uiAppInstance -> apiGateway
            apiGateway -> lambda "forwards the request"
        }

        
    }

    views {
        systemContext livenessDetectionSystem {
            include *
            autolayout lr
        }

        container livenessDetectionSystem {
            include *
            autolayout lr
        }

        deployment livenessDetectionSystem "Cloud" "AmazonWebServicesDeployment2" {
            include *
            autolayout
        }

        styles {
            element "Frontend" {
                shape "WebBrowser"
            }
            element "Backend" {
                shape "Hexagon"
            }
            element "Element" {
                shape "RoundedBox"
            }
            element "Person" {
                shape "Person"
            }
            element "Store" {
                shape "Cylinder"
            }
            element "Infrastructure Node" {
                shape "RoundedBox"
            }
        }
        theme default
        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }

}