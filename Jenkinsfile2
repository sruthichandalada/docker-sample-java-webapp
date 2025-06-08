pipeline {
    agent { label 'tomcat' }

    environment {
        REPO_URL = 'https://github.com/sruthichandalada/docker-sample-java-webapp.git'
        IMAGE_NAME = 'jan2025'
        AWS_REGION = 'ap-south-1'
        ACCOUNT_ID = '881490114731'
        ECR_REGISTRY = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        FULL_IMAGE_NAME = "${ECR_REGISTRY}/${IMAGE_NAME}:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: "${REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    docker tag ${IMAGE_NAME}:latest ${FULL_IMAGE_NAME}
                    docker push ${FULL_IMAGE_NAME}
                    """
                }
            }
        }

        stage('Deploy to Docker Host') {
            steps {
                script {
                    sh """
                    docker stop jan2025 || true
                    docker rm jan2025 || true
                    docker pull ${FULL_IMAGE_NAME}
                    docker run -d -p 8090:8080 --name jan2025 ${FULL_IMAGE_NAME}
                    """
                }
            }
        }
    }
}




