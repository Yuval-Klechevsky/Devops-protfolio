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
                        $class: 'AmazonWebServicesCredentialsBinding',credentialsId: "d78e1745-3552-4aef-8a3f-cfd6866d2d06",accessKeyVariable: 'AWS_ACCESS_KEY_ID',
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
                curl 3.8.210.200:80
                
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
                        withCredentials([usernamePassword(credentialsId: 'ea6e3ba5-b6c6-4abc-8e76-d14c8cc6ea53', usernameVariable: 'username', passwordVariable: 'password')]) {
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
                                git push "https://$username:$password@github.com/Yuval-Klechevsky/Devops-protfolio.git" ${New_tag}
                                git fetch

                                """
                            }
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