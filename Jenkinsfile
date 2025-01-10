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
                            script {
                                def backend_image_name = "cr.yandex/crpe879bq7ptaqnei98m/todo-registry/todo-backend"
                                sh "docker build -t ${backend_image_name}:${BUILD_NUMBER} ."
                                sh "docker push ${backend_image_name}:${BUILD_NUMBER}"
                            }
                        }
                    }
                }
                stage('Frontend Docker Image') {
                    steps {
                        dir('todo-frontend') {
                            script {
                                def frontend_image_name = "cr.yandex/crpe879bq7ptaqnei98m/todo-registry/todo-frontend"
                                sh "docker build -t ${frontend_image_name}:${BUILD_NUMBER} ."
                                sh "docker push ${frontend_image_name}:${BUILD_NUMBER}"
                            }
                        }
                    }
                }
            }
        }
        stage('Update .env') {
            steps {
                script {
                    sh """

			# Копируем файл для редактирования
			cp /home/ubuntu/.env /tmp/.env_jenkins

			# Обновляем переменную VERSION в копии
			sed -i "s/^VERSION=.*/VERSION=${BUILD_NUMBER}/" /tmp/.env_jenkins
	
			# Копируем обратно, перезаписывая оригинал
			sudo cp /tmp/.env_jenkins /home/ubuntu/.env
			sudo chown ubuntu:ubuntu /home/ubuntu/.env # Восстанавливаем владельца и группу
			sudo chmod 664 /home/ubuntu/.env       # Восстанавливаем права доступа
	
			rm /tmp/.env_jenkins # Удаляем временный файл
                    """
                }
            }
        }
    }
}
