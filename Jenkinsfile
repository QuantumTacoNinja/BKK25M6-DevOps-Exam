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
                script {
                    sh 'docker build -t myapp:latest .'
                }
            }
        }
        stage('Docker deployment') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'docker',
                        keyFileVariable: 'FILENAME',
                        usernameVariable: 'USERNAME'
                    )
                ]) {
                    sh 'docker save myapp:latest | ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker "docker load"'

                    sh '''
                    ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker "
                        docker stop myapp-container || true
                        docker rm myapp-container || true
                        docker run -d --name myapp-container --publish 4444:4444 myapp:latest
                    "
                    '''
                }
            }
        }
    }
}
