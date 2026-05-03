pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod.yaml'
    }
  }

  environment {
    SONAR_HOST_URL = "http://sonarqube:9000"
    SONAR_TOKEN = credentials('sonar-token')
    NEXUS_URL = "http://nexus:8081"
  }

  stages {

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
          sh 'docker build -t nexus:8082/k8s-app:latest .'
        }
      }
    }

    stage('Push to Nexus') {
      steps {
        container('docker') {
          sh 'docker push nexus:8082/k8s-app:latest'
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        container('kubectl') {
          sh 'kubectl apply -f k8s/'
        }
      }
    }

  }
}
