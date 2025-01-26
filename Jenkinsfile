pipeline {
    agent any

    stages {
        stage('Test Backend') {
            steps {
                dir('todo-backend') {
                    // Сразу запускаем тесты + сбор покрытия (jacocoTestReport)
                    sh './gradlew clean test jacocoTestReport'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('todo-backend') {
                    // Подключаемся к SonarQube из Jenkins (считает env.SONAR_HOST_URL, env.SONAR_AUTH_TOKEN)
                    withSonarQubeEnv('MySonarQube') {
                        // Запускаем задачу 'sonarqube', которая опубликует анализ в SonarQube
                        sh './gradlew sonarqube'
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    // Ждём, пока SonarQube обработает отчёт
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
                    // Запуск тестов фронта (Jest, например)
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
    }
}

