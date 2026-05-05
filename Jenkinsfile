pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins/pod.yaml'
    }
  }

  environment {
    SONAR_HOST_URL = "http://sonarqube-service:9000"
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

    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh '''
          mkdir -p /kaniko/.docker

          cat <<EOF > /kaniko/.docker/config.json
          {
            "auths": {
              "3.70.131.193:30082": {
                "username": "devops",
                "password": "devops123"
              }
            }
          }
          EOF

          /kaniko/executor \
            --dockerfile=Dockerfile \
            --context=$(pwd) \
            --destination=3.70.131.193:30082/docker-hosted/k8s-app:latest \
            --insecure \
            --skip-tls-verify
          '''
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        container('kubectl') {
         sh '''
	sed -i "s|IMAGE_TAG|3.70.131.193:30082/docker-hosted/k8s-app:latest|g" k8s/deployment.yaml	 
	kubectl apply -f k8s/
	'''
        }
      }
    }

  }
}
