pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-sa

  containers:
  - name: maven
    image: maven:3.9.9-eclipse-temurin-17
    command: ['cat']
    tty: true

  - name: kubectl
    image: bitnami/kubectl:latest
    command: ['cat']
    tty: true

  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    command: ['cat']
    tty: true
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker

  volumes:
  - name: kaniko-secret
    secret:
      secretName: dockerhub-secret
"""
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
            -Dsonar.projectName="K8s DevOps App"
            '''
          }
        }
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        container('kaniko') {
          sh '''
          /kaniko/executor \
            --dockerfile=Dockerfile \
            --context=$(pwd) \
            --destination=ikscorpio/k8s-app:latest \
            --skip-tls-verify
          '''
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
