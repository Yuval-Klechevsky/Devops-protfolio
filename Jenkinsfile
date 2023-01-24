pipeline {
    agent any
     options {
        timestamps()
    }
    environment{
        AWS_ACCOUNT_ID="644435390668"
        AWS_DEFAULT_REGION="eu-west-2"
        IMAGE_REPO_NAME="yuval-klechevsky-repo"
        IMAGE_TAG="latest"
        REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages{
        stage("checkout") {
            steps {
                deleteDir()
                checkout scm
            }
        }
        stage("AWS login"){
              steps{
                script{
                    sh  """
                    aws configure set aws_access_key_id AKIAZMC2XWDGDRI2BSV6
                    aws configure set aws_secret_access 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
                    aws configure set default.region eu-west-2
                    aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com                   
                         """
                }
            }
        }
    }
}