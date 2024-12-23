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

        stage('Build Frontend') {
            steps {
                dir('todo-frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Build and Push Docker Images') {
            parallel {
                stage('Backend Docker Image') {
                    steps {
                        dir('todo-backend') {
                            sh """
                            docker build -t cr.yandex/b1g3b76i0s0742l6fm44/todo-registry/todo-backend:${BUILD_NUMBER} .
                            docker push cr.yandex/b1g3b76i0s0742l6fm44/todo-registry/todo-backend:${BUILD_NUMBER}
                            """
                        }
                    }
                }
                stage('Frontend Docker Image') {
                    steps {
                        dir('todo-frontend') {
                            sh """
                            docker build -t cr.yandex/b1g3b76i0s0742l6fm44/todo-registry/todo-frontend:${BUILD_NUMBER} .
                            docker push cr.yandex/b1g3b76i0s0742l6fm44/todo-registry/todo-frontend:${BUILD_NUMBER}
                            """
                        }
                    }
                }
            }
        }
    }
}

