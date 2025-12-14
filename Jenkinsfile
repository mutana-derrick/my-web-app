pipeline {
    agent any 

    tools {
        nodejs 'NodeJS_20' // MUST match the name in Jenkins Global Tool Config
    }

    environment {
        // Docker Hub Username
        DOCKER_IMAGE = 'mutanaderrick/my-web-app' 
        // MUST match the ID set in Jenkins Credentials
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' 
        // Define the port mapping for deployment
        APP_PORT = 3000
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code from Git...'
                // The 'checkout scm' step automatically clones the repo configured in the job settings.
                checkout scm
            }
        }

        stage('Build & Install Dependencies') {
            steps {
                echo 'Installing Node.js dependencies...'
                // Uses the batch command (bat) for Windows environment
                bat 'npm install'
                bat 'npm list' // Show the installed dependencies
                
                // Correction: The original assignment used 'sh 'ls -la'' or 'bat 'dir'' for a generic build step.
                // We are replacing that with the necessary 'npm install' for a Node.js app.
            }
        }

        stage('Test') {
            steps {
                echo 'Running Unit and Integration Tests...'
                // Assumes your package.json test script is fixed to exit 0
                bat 'npm test'
            }
        }

        // NEW STAGE: Build Docker Image
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${env.DOCKER_IMAGE}:latest"
                script {
                    // This command executes the Dockerfile in the workspace
                    docker.build("${env.DOCKER_IMAGE}:latest")
                }
            }
        }

        // NEW STAGE: Push to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                echo "Pushing image to Docker Hub..."
                script {
                    // Use the configured Jenkins credential ID to log in and push
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKER_CREDENTIALS_ID) {
                        docker.image("${env.DOCKER_IMAGE}:latest").push()
                    }
                }
            }
        }

        // NEW STAGE: Deploy to Local Docker Host
        stage('Deploy to Local Docker Host') {
            steps {
                echo "Deploying container to local Docker host..."
                // Use 'bat' for Windows shell commands
                bat """
                    docker rm -f my-web-app || true
                    // Changing host port from 8080 (used by Jenkins) to 8081
                    docker run -d --name my-web-app -p 8081:${env.APP_PORT} ${env.DOCKER_IMAGE}:latest
                """
                echo "Deployment complete! Application should be available on http://localhost:8081"
            }
        }
    }
}