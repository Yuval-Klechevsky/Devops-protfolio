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
            when {
                anyOf {
                    branch 'main';
                    branch 'feature'
                }
            }
            steps {
                deleteDir()
                checkout scm
            }
        }
        stage("AWS login"){
            when {
                anyOf {
                    branch 'main';
                    branch 'feature'
                }
            }
              steps{
                script{
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',credentialsId: "138f10b8-eef0-4d2b-aae1-9ad183d6b9f7",accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh  """
                        aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com 

                        """
                    }
                }
            }
        }
        stage("Build Containers"){
            when {
                anyOf {
                    branch 'main';
                    branch 'feature'
                }
            }
            steps{
                sh  "docker-compose build --no-cache"
                sh  "docker-compose up -d"
            }          
        }
        stage("Unit-test"){
            when {
                anyOf {
                    branch 'main';
                    branch 'feature'
                }
            }
            steps{
            sh  """
                sleep 5
                curl 3.9.146.148:80
                
                """
            }
        }
        stage("E2E test app"){
            when {
                anyOf {
                    branch 'main';
                    branch 'feature'
                }
            }
            steps{
                sh  """ 
                    cd tests
                    ./unit-test.sh 
                    cat response.txt

                    if [ \$? -eq 0 ]; then
                        echo E2E Success
                        docker-compose down -v
                    else
                        echo E2E fail
                        docker-compose down -v
                    fi
                    
                    """
            }   
        }
        stage("Tagging commit and tags"){
          when {
	        expression {
		        return BRANCH == 'main';
                }
            }
            steps{

            }
        }
        stage("Push to ECR"){
            when {
                expression {
                return BRANCH == 'main';
                }
            }
            steps{
                script{
                   sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${Ver_Calc}"
                }
            }
        }
    }
}