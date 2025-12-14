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

        // NEW STAGE: Kubernetes Deployment
        stage('Kubernetes Deployment') {
            environment {
                // Set the KUBECONFIG variable to point to the shared config file location
                KUBECONFIG = "C:\\ProgramData\\Jenkins\\.kube_config_jenkins"
            }
            steps {
                echo "Deploying to Minikube using kubectl..."
                // Apply the deployment and service manifests
                // --context minikube is still necessary
                bat 'kubectl apply -f deployment.yaml --context minikube'
                bat 'kubectl apply -f service.yaml --context minikube'
            }
        }

        // ... (The Expose Service stage should also have the KUBECONFIG variable set)
        // NEW STAGE: Expose Service
        stage('Expose Service') {
            environment {
                // Set the KUBECONFIG variable
                KUBECONFIG = "C:\\ProgramData\\Jenkins\\.kube_config_jenkins"
            }
            steps {
                echo "Waiting for pods to be ready..."
                // Wait for the two replicas defined in deployment.yaml to be ready
                bat 'kubectl rollout status deployment/nodejs-app-deployment --context minikube' 

                echo "Getting Minikube service URL..."
                
                // Use BAT to execute the command and redirect output to a file
                // We must still quote the path due to spaces, but the BAT shell handles it better
                bat '"C:\\Program Files\\Kubernetes\\Minikube\\minikube.exe" service nodejs-app-service --url > minikube_url.txt'
                
                // Print the URL to the console output using powershell to read the file
                powershell 'Get-Content minikube_url.txt'
            }
        }
    }
}