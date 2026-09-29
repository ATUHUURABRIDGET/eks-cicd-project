pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
        ECR_REGISTRY = "531979738724.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPOSITORY = "flask-app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ATUHUURABRIDGET/eks-cicd-project'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | \
                docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $ECR_REPOSITORY:$IMAGE_TAG .
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh '''
                docker tag $ECR_REPOSITORY:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                '''
            }
        }

        stage('Update kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig --region us-east-1 --name flask-eks-cluster
                '''
            }
        }

        stage('Deploy to EKS') {
    steps {
        sh '''
        kubectl set image deployment/flask-app flask-app=$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
        kubectl rollout restart deployment/flask-app
        '''
    }
}

    }
}
