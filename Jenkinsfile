pipeline {
    agent any

    environment {
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
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
                    sh "docker build -t cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-backend:${BUILD_NUMBER} ."
                    sh "docker push cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-backend:${BUILD_NUMBER}"
                }
            }
        }

        stage('Build and Push Frontend Docker Image') {
            steps {
                dir('todo-frontend') {
                    sh "docker build -t cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-frontend:${BUILD_NUMBER} ."
                    sh "docker push cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-frontend:${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh """
                BUILD_NUMBER=${BUILD_NUMBER} docker-compose up -d
                """
            }
        }
    }
}

