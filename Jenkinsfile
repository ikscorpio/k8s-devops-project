pipeline {
  agent {
    kubernetes {
      inheritFrom 'jenkins-agent'
    }
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/ikscorpio/k8s-devops-project.git'
      }
    }

    stage('Build') {
      steps {
        container('maven') {
          sh 'cd app && mvn clean package'
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        container('maven') {
          sh 'kubectl apply -f k8s/'
        }
      }
    }
  }
}
