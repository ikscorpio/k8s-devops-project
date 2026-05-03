pipeline {
  agent {
    kubernetes {
      label 'jenkins-agent'
      yamlFile 'jenkins/pod.yaml'
    }
  }

  environment {
    SONAR_HOST_URL = "http://sonarqube:9000"
    SONAR_TOKEN = credentials('sonar-token')
    IMAGE = "ikscorpio/k8s-app"
  }

  stages {

    stage('Checkout') {
      steps {
        git 'https://github.com/YOUR_USERNAME/k8s-devops-project.git'
      }
    }

    stage('Build') {
      steps {
        container('maven') {
          sh 'cd app && mvn clean package'
        }
      }
    }

    stage('SonarQube Scan') {
      steps {
        container('maven') {
          sh '''
          cd app
          mvn sonar:sonar \
          -Dsonar.host.url=$SONAR_HOST_URL \
          -Dsonar.login=$SONAR_TOKEN
          '''
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        container('docker') {
          sh '''
          docker build -t $IMAGE:${BUILD_NUMBER} .
          docker login -u YOUR_DOCKER_USER -p YOUR_PASSWORD
          docker push $IMAGE:${BUILD_NUMBER}
          '''
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        container('kubectl') {
          sh """
          sed -i 's|IMAGE_TAG|$IMAGE:${BUILD_NUMBER}|g' k8s/deployment.yaml
          kubectl apply -f k8s/
          """
        }
      }
    }
  }
}
