pipeline {
    agent {
        label 'tomcat'
     }

  environment {
    HELM_RELEASE_NAME = "java-webapp"
    HELM_CHART_DIR = "java-webapp"     // Path to your Helm chart
    KUBE_NAMESPACE = "default"
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/sruthichandalada/docker-sample-java-webapp.git'
      }
    }

    stage('Set kubeconfig') {
      steps {
        withCredentials([file(credentialsId: 'kube-config-id', variable: 'KUBECONFIG_FILE')]) {
          sh '''
            export KUBECONFIG=$KUBECONFIG_FILE
            kubectl get nodes
          '''
        }
      }
    }

    stage('Deploy using Helm') {
      steps {
        withCredentials([file(credentialsId: 'kube-config-id', variable: 'KUBECONFIG_FILE')]) {
          sh '''
            export KUBECONFIG=$KUBECONFIG_FILE
            helm upgrade --install $HELM_RELEASE_NAME $HELM_CHART_DIR --namespace $KUBE_NAMESPACE --create-namespace
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployment successful!"
    }
    failure {
      echo "❌ Deployment failed."
    }
  }
}

