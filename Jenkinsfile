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
    NEXUS_URL = "http://nexus:8081"
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

	environment {
		DOCKERHUB_CREDS = credentials('dockerhub-creds')
	}

	stage('Docker Build') {
		steps {
			sh 'docker build -t ikscorpio/k8s-app:latest .'
		}
	}

	stage('Docker Push') {
		steps {
			sh '''echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin
    			docker push ikscorpio/k8s-app:latest
	    		'''
 	 	}
	}
    stage('Deploy to K8s') {
      steps {
        sh 'kubectl apply -f k8s/'
      }
    }
  }
}
