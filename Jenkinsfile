pipeline {
    agent { label 'tomcat' }
    
    parameters {
        choice(name: 'NAMESPACE', choices: ['dev', 'test', 'prod'], description: 'Select the Kubernetes namespace to deploy to')      //using choice parameters to deploy the application in different ns
    }

    environment {
        REPO_URL = 'https://github.com/sruthichandalada/docker-sample-java-webapp.git'
        IMAGE_NAME = 'jan2025'
        IMAGE_TAG = "v${BUILD_NUMBER}"
        AWS_REGION = 'ap-south-1'
        ACCOUNT_ID = '881490114731'
        ECR_REGISTRY = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        FULL_IMAGE_NAME = "${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
        KUBE_CONFIG = 'kube-config-id' // Jenkins credentials ID

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
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}
                        docker push ${FULL_IMAGE_NAME}
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kube-config-id', variable: 'KUBECONFIG')]) {
                    sh '''
                       export KUBECONFIG=$KUBECONFIG
                       echo "Deploying to namespace: ${NAMESPACE}"

                       # Replace image placeholder
                       sed -i "s|IMAGE_PLACEHOLDER|${ECR_REGISTRY}:${IMAGE_TAG}|g" k8s/deployment.yaml        

                       # Apply both deployment and service manifests
                       kubectl apply -n ${NAMESPACE} -f k8s/
                       '''
                        }
                    }
                }
            }
        }
    }
}


