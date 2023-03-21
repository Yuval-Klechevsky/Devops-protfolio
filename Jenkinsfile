pipeline {
    agent any
     options {
        timestamps()
    }
    environment{
        AWS_ACCOUNT_ID="863254239753"
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
                        $class: 'AmazonWebServicesCredentialsBinding',credentialsId: "57795a39-caf6-44a7-96de-ebdd90b1635e  ",accessKeyVariable: 'AWS_ACCESS_KEY_ID',
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
<<<<<<< HEAD
                curl 35.178.172.71:80
=======
                curl 3.10.232.101:80
>>>>>>> 77d5b81b407cd5e59222f0518a21770f330999ea
                
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
<<<<<<< HEAD
                        withCredentials([gitUsernamePassword(credentialsId: 'dcf0d905-221e-4fb1-8e9c-e037187c2bbf',gitToolName: 'Default')]) {
                            env.GIT_COMMIT_MSG = sh(script: "git log -1 --pretty=%B ${env.GIT_COMMIT}", returnStdout: true).trim()
                         if(GIT_COMMIT_MSG.contains("version")){
=======
                          env.GIT_COMMIT_MSG = sh(script: "git log -1 --pretty=%B ${env.GIT_COMMIT}", returnStdout: true).trim()
                        if(GIT_COMMIT_MSG.contains("version")){
>>>>>>> 77d5b81b407cd5e59222f0518a21770f330999ea
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
<<<<<<< HEAD
                            }
                        }      
                    }
                }
=======
                    }
                }
            }
>>>>>>> 77d5b81b407cd5e59222f0518a21770f330999ea
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
            when {
                branch 'main'
            }
            steps{
                script{
                    sh "./copy.sh ${New_tag}"
                }
            }
        }
    }
}
