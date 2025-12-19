pipeline {
    agent any

    tools {
       nodejs "24.0.0"
    }

    stages {
        stage('Install dependencies') {
            steps {
                sh 'npm i -save express'
            }
        }
        stage('Test') {
            steps {
            sh "node --test index.test.js"
            }
        }
        stage('Build Docker image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }
        stage('Build Push Image') {
            steps {
                def imageName = "ttl.sh/myapp-${env.BUILD_ID}:${2h}"
                sh "docker tag myapp:latest ${imageName}"
                sh "docker push ${imageName}"
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                withKubeConfig([credentialsId: 'k8s', serverUrl: 'https://kubernetes:6443']) {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                    sh 'kubectl apply -f definition.yaml'
                }
            }
        }
    }
}
