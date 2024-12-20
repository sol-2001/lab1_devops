pipeline {
    agent any

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


        stage('Build and Push Docker Image') {
            steps {
                dir('todo-backend') {
                    sh "docker build -t cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-backend:${BUILD_NUMBER} ."
                    sh "docker push cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-backend:${BUILD_NUMBER}"
                }
            }
        }
    }
}

