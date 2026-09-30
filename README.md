# README.md

## EKS CI/CD Project – Flask Application Deployment
This project demonstrates a complete CI/CD pipeline for deploying a containerized Flask application to Amazon EKS. It includes infrastructure provisioning with Terraform, containerization with Docker, image storage in Amazon ECR, automated builds and deployments using Jenkins, and Kubernetes resources for running and scaling the application.
The goal is to show an end‑to‑end workflow that reflects real DevOps and cloud engineering practices.

## Project Overview
A simple Flask application is built into a Docker image and pushed to Amazon ECR. Jenkins automates the build and deployment process. Terraform provisions the AWS infrastructure, including the VPC, subnets, EKS cluster, and node group. Kubernetes manifests deploy the application, expose it through a LoadBalancer service, and configure autoscaling using both the Horizontal Pod Autoscaler (HPA) and the Cluster Autoscaler.

## Architecture Summary
•  Flask application containerized with Docker
•  Docker image stored in Amazon ECR
•  Jenkins pipeline automates build, push, and deployment
•  Terraform provisions:
•	VPC
•	Subnets
•	Internet Gateway
•	Route Tables
•	EKS Cluster
•	Node Group
•  Kubernetes deploys and scales the application
•  Application exposed via AWS Load Balancer

## Technologies Used
Infrastructure
•	Terraform
•	Amazon VPC
•	Amazon EKS
•	IAM Roles
•	Security Groups
CI/CD
•	Jenkins
•	GitHub Webhooks
Containers
•	Docker
•	Amazon ECR
Kubernetes
•	Deployments
•	Services (LoadBalancer)
•	Horizontal Pod Autoscaler
•	Cluster Autoscaler
Application
•	Python
•	Flask

## Repository Structure

eks-cicd-project/
│
├── app/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── terraform/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── autoscaler-rbac.yaml
│       ├── autoscaler-serviceaccount.yaml
│       ├── cluster-autoscaler.yaml
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── hpa.yaml
│       └── terraform.tfstate (generated after apply)
│
└── Jenkinsfile

## Pipeline Workflow

•  Code is pushed to GitHub.
•  Jenkins webhook triggers the pipeline.
•  Jenkins pulls the latest code.
•  Docker image is built and tagged.
•  Image is pushed to Amazon ECR.
•  Jenkins updates the Kubernetes deployment with the new image.
•  Kubernetes applies the deployment, service, HPA, and cluster autoscaler.
•  EKS schedules pods and exposes the application through a LoadBalancer.

## Jenkins Pipeline Overview
The Jenkins pipeline automates the entire CI/CD process for this project. It performs the following steps:
•	Pulls the latest code from GitHub
•	Builds the Docker image
•	Tags the image with the commit SHA
•	Pushes the image to Amazon ECR
•	Updates the Kubernetes deployment in Amazon EKS
•	Triggers a rolling update of the application pods
The pipeline logic is defined in the Jenkinsfile located at the root of the repository.

## Running the Application Locally
Install dependencies
pip install -r requirements.txt
Run Flask app
python app.py
## Build and Run Docker Image Locally
docker build -t flask-app .
docker run -p 5000:5000 flask-app

## Provision Infrastructure with Terraform
Navigate to the Terraform directory:
cd app/terraform
terraform init
terraform apply -auto-approve
This command provisions the VPC, subnets, EKS cluster, node group, and all supporting AWS resources required for the deployment.

## Deploy Application to Kubernetes
After the cluster is created and kubectl is configured:
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
kubectl apply -f cluster-autoscaler.yaml

## Access the Application
Retrieve the LoadBalancer URL:
kubectl get svc flask-app-service
Open the external URL in your browser to access the Flask application.

## Autoscaling
Horizontal Pod Autoscaler
kubectl get hpa
Cluster Autoscaler
The cluster autoscaler automatically adjusts the number of nodes based on scheduling needs.

## Destroy Infrastructure
To remove all Terraform‑managed resources:
terraform destroy -auto-approve
This command deletes the VPC, subnets, EKS cluster, node group, and all other resources created during deployment.





