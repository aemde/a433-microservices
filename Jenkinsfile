pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/aemde/a433-microservices.git'
        BRANCH = 'proyek-pertama'
        IMAGE_NAME = 'aemde/item-app'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // ID credentials untuk Docker Hub
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Initialize Environment') {
            steps {
                script {
                    // Dynamically set the image tag based on build number
                    env.IMAGE_TAG = "v${env.BUILD_NUMBER}"
                    echo "Image tag to be used: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Clean Workspace') {
            steps {
                cleanWs()
                echo 'Workspace cleaned successfully.'
            }
        }

        stage('Clone Repository') {
            steps {
                echo "Cloning repository ${REPO_URL} (branch: ${BRANCH})..."
                git branch: "${BRANCH}",
                    url: "${REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo 'Deploying application using Docker Compose...'
                sh '''
                    sed -i "s|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|" ${DOCKER_COMPOSE_FILE}
                    docker-compose down || true
                    docker-compose up -d
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Build, push, and deployment completed successfully!'
        }
        failure {
            echo 'Build, push, or deployment failed. Please check logs.'
        }
    }
}
