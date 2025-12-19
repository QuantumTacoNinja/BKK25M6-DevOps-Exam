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
                sh 'node --test index.test.js'
            }
        }
        stage('Simple deployment') {
            steps {
                withCredentials(
                    [sshUserPrivateKey(
                        credentialsId: 'simple', 
                        keyFileVariable: 'FILENAME', 
                        usernameVariable: 'USERNAME'
                    )]
                ) {
                    sh 'simple-deployment.sh'
                }
            }
        }
    }
}
