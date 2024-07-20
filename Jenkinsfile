pipeline {
    agent any
    tools {
        gradle 'gradle'
    }
    environment {
        AWS_ACCOUNT_ID="058087963754"
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="devopstest"
        IMAGE_TAG="latest"
        REPOSITORY_URI = "058087963754.dkr.ecr.us-east-1.amazonaws.com/devopstest"
        GIT_CREDENTIAL = "test_git_credential"
        GIT_URL = 'https://github.com/ChoiSeungBeom/springproject.git'
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }
                 
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], 
                          doGenerateSubmoduleConfigurations: false, 
                          extensions: [], 
                          submoduleCfg: [], 
                          userRemoteConfigs: [[credentialsId: GIT_CREDENTIAL, 
                                               url: GIT_URL]]])
            }
            post {
                failure {
                    echo 'clone failed'
                }
                success {
                    echo 'clone success'
                }
            }
        }

        stage('Building code'){
            steps {
                sh "./gradlew clean build"
            }
        }
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh """docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"""
                sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"""
         }
        }
      }
    }
}
