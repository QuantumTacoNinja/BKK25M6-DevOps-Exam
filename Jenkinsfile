pipeline {
    agent any

    tools {
       node "24.0.0"
    }

    stages {
        stage('Test') {
            steps {
                sh "node --test index.test.js"
            }
        }
    }
}
