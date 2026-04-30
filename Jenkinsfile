pipeline {
  agent {
    kubernetes {
      inheritFrom 'jenkins-agent'
    }
  }

  environment {
    DOCKERHUB_CREDS = credentials('dockerhub-creds')
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

    stage('Docker Build') {
      steps {
        container('docker') {
          sh 'cd app && docker build -t ikscorpio/k8s-app:latest .'
        }
      }
    }

    stage('Docker Push') {
      steps {
        container('docker') {
          sh '''
          echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin
          docker push ikscorpio/k8s-app:latest
          '''
        }
      }
    }

    stage('Deploy') {
      steps {
        container('maven') {
          sh 'kubectl apply -f k8s/'
        }
      }
    }
  }
}
