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
    DOCKER_REGISTRY = "<WORKER_NODE_IP>:<NODEPORT>"   // example: 3.67.x.x:32000
    IMAGE_NAME = "k8s-app"
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

    stage('Docker Build') {
      steps {
        container('docker') {
          sh "docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:${BUILD_NUMBER} ."
        }
      }
    }

    stage('Push to Nexus') {
      steps {
        container('docker') {
          sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME:${BUILD_NUMBER}"
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        container('maven') {
          sh """
          sed -i 's|IMAGE_TAG|$DOCKER_REGISTRY/$IMAGE_NAME:${BUILD_NUMBER}|g' k8s/deployment.yaml
          kubectl apply -f k8s/
          """
        }
      }
    }
  }
}
