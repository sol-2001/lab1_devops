pipeline {
    agent any

    environment {
        REGISTRY = 'cr.yandex/crprmuig7ls6e7kr82qn/todo-registry'
    }

    stages {
        stage('Test Backend') {
            steps {
                dir('todo-backend') {
                    sh './gradlew test'
                }
            }
        }

        stage('Test Frontend') {
            steps {
                dir('todo-frontend') {
                    sh 'npm install'
                    sh 'npm test -- --watchAll=false'
                }
            }
        }

        stage('Build Backend') {
            steps {
                dir('todo-backend') {
                    sh './gradlew build'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('todo-frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Build and Push Backend Docker Image') {
            steps {
                dir('todo-backend') {
                    sh "docker build -t ${REGISTRY}/todo-backend:${BUILD_NUMBER} ."
                    sh "docker push ${REGISTRY}/todo-backend:${BUILD_NUMBER}"
                }
            }
        }

        stage('Build and Push Frontend Docker Image') {
            steps {
                dir('todo-frontend') {
                    sh "docker build -t ${REGISTRY}/todo-frontend:${BUILD_NUMBER} ."
                    sh "docker push ${REGISTRY}/todo-frontend:${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for errors.'
        }
    }
}

