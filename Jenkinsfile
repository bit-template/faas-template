pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build') {
            steps {
                sh './gradlew build'   
            }
        }
        stage('Docker Push') {
            when {
                branch 'main'   // only run this stage on main branch
            }            
            steps {
                sh './gradlew push'
            }
        }
    }
}
