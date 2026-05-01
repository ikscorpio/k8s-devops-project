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
stage('SonarQube Analysis') {
  steps {
    container('maven') {
      withSonarQubeEnv('sonar') {
        sh '''
        cd app
        mvn sonar:sonar \
        -Dsonar.projectKey=k8s-devops-app \
        -Dsonar.projectName="K8s DevOps App" \
        -Dsonar.host.url=http://sonarqube-service:9000
        '''
      }
    }
  }
}
    stage('Deploy to Kubernetes') {
      steps {
          container('kubectl') {
          sh 'kubectl apply -f k8s/'
        }
      }
    }
  }
}
