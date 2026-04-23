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
        stage('Docker Build & Push') {
            steps {
                sh './gradlew push'
            }
        }
        stage('Deploy') {
            steps {
                sh './gradlew deploy'
            }
        }
    }
}
