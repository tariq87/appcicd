pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'tariq87/demo-microservice:latest'
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    installDocker()
                }
            }
        }

        stage('Build & Push') {
            steps {
                script {
                    sh "docker build -t $DOCKER_HUB_REPO ."
                    withCredentials([usernamePassword(credentialsId: 'dockerHubCreds', passwordVariable: 'DOCKER_HUB_PASS', usernameVariable: 'DOCKER_HUB_USER')]) {
                        sh "docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASS"
                        sh "docker push $DOCKER_HUB_REPO"
                    }
                }
            }
        }

        stage('Update Kubeconfig & Deploy') {
            steps {
                script {
                    // Switching Kubernetes context
                    sh "aws eks update-kubeconfig --name my-demo-cluster --region us-east-1"
                    
                    sh "kubectl apply -f kubernetes/deployment.yaml"
		    sh "kubectl apply -f kubernetes/service.yaml"
                }
            }
        }
    }
}

// Function to install Docker
def installDocker() {
    sh '''
        sudo yum update -y
        sudo amazon-linux-extras install docker -y
        sudo service docker start
        sudo usermod -a -G docker ec2-user
        sudo chkconfig docker on
    '''
}
