pipeline {
    agent any

    tools {
       nodejs "24.0.0"
    }

    stages {
        stage('Test') {
            steps {
                sh "node --test index.test.js"
            }
        }
    }
}
