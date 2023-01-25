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
                    branch 'main'
                    branch 'feature/*'
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
                    branch 'main'
                    branch 'feature/*'
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
                    branch 'main'
                    branch 'feature/*'
                }
            }
            steps{
                sh  "docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME} ."
                sh  "docker-compose -f docker-compose.yaml build --no-cache"
                sh  "docker-compose -f docker-compose.yaml up -d"
            }          
        }
        stage("Unit-test"){
            when {
                anyOf {
                    branch 'main'
                    branch 'feature/*'
                }
            }
            steps{
            sh  """
                sleep 5
                curl 13.40.43.228:80
                
                """
            }
        }
        stage("E2E test app"){
            when {
                anyOf {
                    branch 'main'
                    branch 'feature/*'
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
                branch 'main'
            }
            steps{ 
                script{
                          env.GIT_COMMIT_MSG = sh(script: "git log -1 --pretty=%B ${env.GIT_COMMIT}", returnStdout: true).trim()
                        if(GIT_COMMIT_MSG.contains("version")){
                            sh  """
                                git switch main
                                git fetch origin --tags
                                git tag --list

                                """
                            Ver_Calc=sh(script: "bash tags-init.sh ${GIT_COMMIT_MSG}",returnStdout: true).trim()
                            New_tag=Ver_Calc.split("\n").last()
                            echo "${New_tag}"
                            sh  """
                                git tag ${New_tag}
                                git push origin ${New_tag}
                                git fetch

                                """
                    }
                }
            }
        }
        stage("Push to ECR"){
            when {
                branch 'main'
            }
            steps{
                script{
                    sh "docker tag  ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}  ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${New_tag} "
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${New_tag}"
                }
            }
        }
        stage("Deploy to Prodaction"){
            steps{
                script{
                    sh "scp ./requirements.txt  ubuntu@3.8.133.86:/home/ubuntu"
                    sh "scp ./mongo.dockerfile  ubuntu@3.8.133.86:/home/ubuntu"
                    sh "scp ./nginx.dockerfile  ubuntu@3.8.133.86:/home/ubuntu"
                    sh "scp ./docker-compose-prod.yaml  ubuntu@3.8.133.86:/home/ubuntu"
                    sh "scp ./init-db.js ubuntu@3.8.133.86:/home/ubuntu"
                    sh "scp ./app.py ubuntu@3.8.133.86:/home/ubuntu"
                    sh "scp ./tests/unit-test.sh ubuntu@3.8.133.86:/home/ubuntu/tests/"
                    sh "scp ./nginx/nginx.conf ubuntu@3.8.133.86:/home/ubuntu/nginx/"
                    sh "scp ./templates/index.html ubuntu@3.8.133.86:/home/ubuntu/templates/"
                    sh "scp ./deploy.sh ubuntu@3.8.133.86:/home/ubuntu"
                    sh "ssh ubuntu@3.8.133.86 bash deploy.sh"
                }
            }
        }
    }
}
