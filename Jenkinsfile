pipeline {
    agent any

    stages {

        stage('Test Backend') {
            steps {
                dir('todo-backend') {
                    sh './gradlew clean test jacocoTestReport'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('todo-backend') {
                    withSonarQubeEnv('MySonarQube') {
                        sh './gradlew sonarqube'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    def qg = waitForQualityGate() 
                    println "Quality Gate status: ${qg.status}"
                    if (qg.status != 'OK') {
                        error "SonarQube Quality Gate failed: ${qg.status}"
                    }
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
                            script {
                                def backend_image_name = "cr.yandex/crpp8odc6temeugiivj2/todo-registry/todo-backend"
                                sh "docker build -t ${backend_image_name}:latest ."
                                sh "docker push ${backend_image_name}:latest"
                            }
                        }
                    }
                }
                stage('Frontend Docker Image') {
                    steps {
                        dir('todo-frontend') {
                            script {
                                def frontend_image_name = "cr.yandex/crpp8odc6temeugiivj2/todo-registry/todo-frontend"
                                sh "docker build -t ${frontend_image_name}:latest ."
                                sh "docker push ${frontend_image_name}:latest"
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                expression {
                    return true
                }
            }
            steps {
                script {
                    // Если нужно, подтягиваем kubeconfig через yc CLI (пример):
                    sh """
                      yc container cluster get-credentials todo-k8s-cluster --external --folder-id b1gtj94ev5rb7r3b7fvm
                      # Или используем уже настроенный KUBECONFIG
                      kubectl config set-context --current --namespace=default
                    """

                    sh """
                      kubectl apply -f k8s-manifests/
                    """

                    // (Опционально) дожидаемся rollout, если нужно убедиться, что деплой запустился:
                    sh """
                      kubectl rollout status deployment/todo-backend
                      kubectl rollout status deployment/todo-frontend
                    """
                }
            }
        }

    }

    post {
        always {
            cleanWs()
        }
    }
}

