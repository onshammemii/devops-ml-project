.PHONY: help build test run stop clean deploy

help:
	@echo "DevOps ML Project - Available Commands"
	@echo "======================================"
	@echo "make build       - Build Docker image"
	@echo "make test        - Run tests"
	@echo "make run         - Start all services"
	@echo "make stop        - Stop all services"
	@echo "make clean       - Remove all containers and images"
	@echo "make logs        - View API logs"
	@echo "make k8s-deploy  - Deploy to Kubernetes"
	@echo "make k8s-delete  - Delete from Kubernetes"
	@echo "make terraform   - Apply Terraform configuration"

build:
	@echo "Building Docker image..."
	cd app && docker build -t sentiment-api:latest .

test:
	@echo "Running tests..."
	./test.sh

run:
	@echo "Starting all services..."
	./start.sh

stop:
	@echo "Stopping all services..."
	docker-compose down

clean:
	@echo "Cleaning up..."
	docker-compose down -v
	docker rmi sentiment-api:latest || true

logs:
	docker-compose logs -f ml-api

k8s-deploy:
	@echo "Deploying to Kubernetes..."
	kubectl apply -f k8s/deployment.yaml

k8s-delete:
	@echo "Deleting from Kubernetes..."
	kubectl delete -f k8s/deployment.yaml

k8s-status:
	@echo "Checking deployment status..."
	kubectl get all -n ml-platform

terraform:
	@echo "Applying Terraform configuration..."
	cd terraform && terraform init && terraform apply

scale-up:
	kubectl scale deployment ml-api -n ml-platform --replicas=5

scale-down:
	kubectl scale deployment ml-api -n ml-platform --replicas=2
