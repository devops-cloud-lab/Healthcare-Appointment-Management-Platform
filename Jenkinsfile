pipeline {
    agent any

    environment {
        // Replace with your Docker Hub username
        DOCKER_HUB_USER = '281644'
        IMAGE_NAME      = 'healthcare-frontend'
        APP_SERVER_IP   = '54.89.87.239' // Replace with your App Server Public IP
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/devops-cloud-lab/Healthcare-Appointment-Management-Platform.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image version ${BUILD_NUMBER}..."
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                    sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo \$PASS | docker login -u \$USER --password-stdin"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to Application Server') {
            steps {
                script {
                    sshagent(['app-server-ssh-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${APP_SERVER_IP} '
                                cd /home/ubuntu/healthcare-app &&
                                docker compose pull &&
                                docker compose up -d --remove-orphans
                            '
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker logout"
        }
        success {
            echo "Healthcare Platform successfully built and deployed!"
        }
        failure {
            echo "Pipeline failed. Check build logs for details."
        }
    }
}
