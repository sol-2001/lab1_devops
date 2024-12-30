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
                                def backend_image_name = "cr.yandex/crp66ar698vs0sm2fcr5/todo-registry/todo-backend"
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
                                def frontend_image_name = "cr.yandex/crp66ar698vs0sm2fcr5/todo-registry/todo-frontend"
                                sh "docker build -t ${frontend_image_name}:${BUILD_NUMBER} ."
                                sh "docker push ${frontend_image_name}:${BUILD_NUMBER}"
                            }
                        }
                    }
                }
                stage('Update .env File') {
            	    steps {
                       script {
                    		sh '''
                      		echo "Updating BUILDERNUMBER in /home/ubuntu/.env"
                      		awk -v build_number="${BUILD_NUMBER}" '
                        	BEGIN { found=0 }
                        	/^BUILDERNUMBER=/ { print "BUILDERNUMBER=" build_number; found=1; next }
                        	{ print }
                        	END { if (!found) print "BUILDERNUMBER=" build_number }
                      		' /home/ubuntu/.env > /home/ubuntu/.env.tmp && mv /home/ubuntu/.env.tmp /home/ubuntu/.env
                    		'''
                }
            }
        }
                
            }
        }
    }
}
