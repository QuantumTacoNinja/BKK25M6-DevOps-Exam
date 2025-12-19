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
        stage('Docker deployment') {
            steps {
                withCredentials(
                    [sshUserPrivateKey(
                        credentialsId: 'docker', 
                        keyFileVariable: 'FILENAME', 
                        usernameVariable: 'USERNAME'
                    )]
                ) {
                    sh 'docker save myapp:latest | ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker "docker load"'
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker "
                        docker run --publish 4444:4444 myapp:latest
                    "
                    '''
                }
            }
        }
    }
}
