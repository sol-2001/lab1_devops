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
                            sh "docker build -t cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-backend:\${BUILD_NUMBER} ."
                            withCredentials([string(credentialsId: 'yandex-cloud-registry-auth', variable: 'DOCKER_AUTH_TOKEN')]) {
                                sh "docker login -u token -p \$DOCKER_AUTH_TOKEN cr.yandex"
                                sh "docker push cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-backend:\${BUILD_NUMBER}"
                            }
                        }
                    }
                }
                stage('Frontend Docker Image') {
                    steps {
                        dir('todo-frontend') {
                            sh "docker build -t cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-frontend:\${BUILD_NUMBER} ."
                            withCredentials([string(credentialsId: 'yandex-cloud-registry-auth', variable: 'DOCKER_AUTH_TOKEN')]) {
                                sh "docker login -u token -p \$DOCKER_AUTH_TOKEN cr.yandex"
                                sh "docker push cr.yandex/crprmuig7ls6e7kr82qn/todo-registry/todo-frontend:\${BUILD_NUMBER}"
                            }
                        }
                    }
                }
            }
        }
    }
}
