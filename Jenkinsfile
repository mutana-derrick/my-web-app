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

        // NEW STAGE: Kubernetes Deployment (Replaces old Docker Deploy)
        stage('Kubernetes Deployment') {
            steps {
                echo "Deploying to Minikube using kubectl..."
                // Apply the deployment and service manifests committed to the repo
                bat 'kubectl apply -f deployment.yaml'
                bat 'kubectl apply -f service.yaml'
            }
        }

        // NEW STAGE: Expose Service and Verify
        stage('Expose Service') {
            steps {
                echo "Waiting for pods to be ready..."
                // Wait for the two replicas defined in deployment.yaml to be ready
                bat 'kubectl rollout status deployment/nodejs-app-deployment' 

                echo "Getting Minikube service URL..."
                // This command tells you the external URL to access the deployed application
                // We wrap it in powershell for environment variable assignment on Windows
                powershell 'minikube service nodejs-app-service --url | Out-File -FilePath minikube_url.txt'
                
                // Print the URL to the console output
                powershell 'Get-Content minikube_url.txt'
            }
        }
    }
}