pipeline {
  agent {
    kubernetes {
      label 'jenkins-agent'
      yamlFile 'jenkins/pod.yaml'
    }
  }

  environment {
    DOCKERHUB_CREDS = credentials('dockerhub-creds')
  }

  stages {

    stage('Checkout') {
      steps {
        git 'https://github.com/ikscorpio/k8s-devops-project.git'
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
          sh 'docker build -t YOUR_DOCKERHUB_USERNAME/k8s-app:latest .'
        }
      }
    }

    stage('Docker Push') {
      steps {
        container('docker') {
          sh '''
          echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin
          docker push YOUR_DOCKERHUB_USERNAME/k8s-app:latest
          '''
        }
      }
    }

    stage('Deploy') {
      steps {
        sh 'kubectl apply -f k8s/'
      }
    }
  }
}
