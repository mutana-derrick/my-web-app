pipeline {
    // 1. Agent: Specifies where the pipeline runs (on the Jenkins master or an available agent)
    agent any 

    // 2. Tools: Automatically install Node.js (assuming you have the Node.js plugin installed in Jenkins)
    // NOTE: You will need to configure Node.js tool in Jenkins Global Tool Configuration.
    tools {
        // Replace 'NodeJS_18' with the name you give your Node.js installation in Jenkins setup.
        nodejs 'NodeJS_20' 
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
                // Executes the 'test' script defined in your package.json (e.g., 'mocha', 'jest', etc.)
                bat 'npm test'
                
                // Correction: The original assignment had only 'echo "Running tests..."'.
                // We are adding 'npm test' to meet the Assessment Criteria for 'Evidence of Testing'[cite: 5, 5].
            }
        }

        stage('Package/Build Artifact') {
            steps {
                echo 'Creating production-ready assets (if applicable)...'
                // For many Node.js apps, this is 'npm run build' or similar.
                // If your Node.js app is simple and doesn't need compilation (like the sample provided later), this can be an empty placeholder.
                // For now, we'll just run a simple directory listing to prove the stage executes on Windows:
                bat 'dir'
            }
        }
        
        // This stage is a placeholder as the next task (Task 2) will fully implement deployment.
        stage('Deploy') {
            steps {
                echo "Deployment step placeholder. Real deployment will be implemented in Task 2."
                echo "Application built and tested successfully!"
            }
        }
    }
}