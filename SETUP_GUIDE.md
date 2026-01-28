# DevOps ML Project - Complete Setup Guide

## Project Structure
```
devops-ml-project/
├── app/
│   ├── app.py                 # ML API application
│   ├── Dockerfile             # Container definition
│   ├── requirements.txt       # Python dependencies
│   └── tests/
│       └── test_api.py       # Unit tests
├── k8s/
│   └── deployment.yaml        # Kubernetes manifests
├── terraform/
│   └── main.tf               # Infrastructure as Code
├── .github/workflows/
│   └── ci-cd.yml             # CI/CD pipeline
├── monitoring/
│   ├── prometheus.yml        # Metrics collection
│   └── grafana-datasources.yml
├── nginx/
│   └── nginx.conf            # Load balancer config
└── docker-compose.yml        # Local development
```

## What This Project Demonstrates

### 1. **Containerization** (Docker)
✅ Multi-stage builds for smaller images
✅ Non-root user for security
✅ Health checks
✅ Layer caching optimization

### 2. **Orchestration** (Kubernetes)
✅ Deployment with 3 replicas
✅ Rolling updates (zero downtime)
✅ Liveness & readiness probes
✅ ConfigMaps & Secrets
✅ Horizontal Pod Autoscaler
✅ Persistent storage
✅ Resource limits

### 3. **Infrastructure as Code** (Terraform)
✅ VPC with public/private subnets
✅ EKS cluster provisioning
✅ ECR for container registry
✅ S3 for model storage
✅ IAM roles and policies
✅ Auto-scaling node groups

### 4. **CI/CD** (GitHub Actions)
✅ Automated testing
✅ Code linting & security scanning
✅ Docker image building & pushing
✅ Automated deployment to K8s
✅ Multi-environment support (dev/prod)

### 5. **Monitoring** (Prometheus + Grafana)
✅ Application metrics collection
✅ Dashboard visualization
✅ Health monitoring

---

## Quick Start Guide

### Option 1: Local Development (Docker Compose)

```bash
# 1. Clone/download the project
cd devops-ml-project

# 2. Build and run everything locally
docker-compose up --build

# 3. Test the API
curl http://localhost:5000/health
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "This product is amazing!"}'

# 4. Access monitoring
# Grafana: http://localhost:3000 (admin/admin)
# Prometheus: http://localhost:9090
```

### Option 2: Kubernetes Deployment (Minikube)

```bash
# 1. Start local Kubernetes cluster
minikube start --cpus=4 --memory=8192

# 2. Enable required addons
minikube addons enable metrics-server
minikube addons enable ingress

# 3. Build image locally for Minikube
eval $(minikube docker-env)
cd app
docker build -t sentiment-api:latest .

# 4. Deploy to Kubernetes
cd ..
kubectl apply -f k8s/deployment.yaml

# 5. Watch deployment
kubectl get pods -n ml-platform -w

# 6. Test the service
kubectl port-forward -n ml-platform service/ml-api-service 8080:80
curl http://localhost:8080/health

# 7. Scale up/down
kubectl scale deployment ml-api -n ml-platform --replicas=5

# 8. Rolling update
kubectl set image deployment/ml-api ml-api=sentiment-api:v2 -n ml-platform
kubectl rollout status deployment/ml-api -n ml-platform
```

### Option 3: Cloud Deployment (AWS)

```bash
# 1. Set up AWS credentials
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_REGION="us-east-1"

# 2. Provision infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# 3. Configure kubectl
aws eks update-kubeconfig --name ml-platform-cluster --region us-east-1

# 4. Deploy application
kubectl apply -f ../k8s/deployment.yaml

# 5. Get service URL
kubectl get service ml-api-service -n ml-platform
```

---

## Testing the API

### Health Check
```bash
curl http://localhost/health
```

### Single Prediction
```bash
curl -X POST http://localhost/predict \
  -H "Content-Type: application/json" \
  -d '{
    "text": "I absolutely love this product!"
  }'
```

### Batch Prediction
```bash
curl -X POST http://localhost/batch-predict \
  -H "Content-Type: application/json" \
  -d '{
    "texts": [
      "Great service!",
      "Terrible experience",
      "It was okay"
    ]
  }'
```

### Model Information
```bash
curl http://localhost/model-info
```

---

## CI/CD Pipeline Setup

### 1. GitHub Repository Setup
```bash
# Initialize git
git init
git add .
git commit -m "Initial commit: DevOps ML Platform"

# Create GitHub repo and push
git remote add origin https://github.com/YOUR_USERNAME/devops-ml-project.git
git push -u origin main
```

### 2. Configure GitHub Secrets
Go to: Settings → Secrets → Actions → New repository secret

Add these secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ECR_REGISTRY` (e.g., 123456789.dkr.ecr.us-east-1.amazonaws.com)

### 3. Pipeline Triggers
- **Push to `main`** → Deploy to production
- **Push to `develop`** → Deploy to development
- **Pull Request** → Run tests only

---

## Monitoring & Observability

### Access Grafana Dashboard
```bash
# Local (Docker Compose)
http://localhost:3000
Username: admin
Password: admin

# Kubernetes
kubectl port-forward -n ml-platform svc/grafana 3000:3000
```

### View Prometheus Metrics
```bash
# Local
http://localhost:9090

# Kubernetes
kubectl port-forward -n ml-platform svc/prometheus 9090:9090
```

### Key Metrics to Monitor
- Request rate (`http_requests_total`)
- Response time (`http_request_duration_seconds`)
- Error rate (`http_requests_total{status="500"}`)
- CPU/Memory usage
- Pod restarts

---

## Real-World Scenarios to Practice

### 1. Simulate Production Issues
```bash
# High load testing
ab -n 10000 -c 100 http://localhost/predict

# Kill a pod and watch recovery
kubectl delete pod -n ml-platform ml-api-xxxxx

# Trigger autoscaling
kubectl run -it load-generator --image=busybox /bin/sh
while true; do wget -q -O- http://ml-api-service/predict; done
```

### 2. Blue-Green Deployment
```bash
# Deploy v2 alongside v1
kubectl apply -f k8s/deployment-v2.yaml

# Switch traffic
kubectl patch service ml-api-service -p '{"spec":{"selector":{"version":"v2"}}}'
```

### 3. Rollback
```bash
# If something goes wrong
kubectl rollout undo deployment/ml-api -n ml-platform
```

### 4. Update Model
```bash
# Train new model, create new Docker image
docker build -t sentiment-api:v2.0 .

# Update deployment
kubectl set image deployment/ml-api ml-api=sentiment-api:v2.0 -n ml-platform
```

---

## Interview Talking Points

### "Walk me through your DevOps project"

**YOU SAY:**
"I built a production-ready ML sentiment analysis API that demonstrates the full DevOps lifecycle:

1. **Development**: Created a Flask API with scikit-learn model
2. **Containerization**: Multi-stage Dockerfile, optimized for size and security
3. **Local Testing**: Docker Compose with monitoring stack
4. **Orchestration**: Deployed to Kubernetes with autoscaling, rolling updates
5. **Infrastructure**: Terraformed AWS infrastructure - VPC, EKS, ECR, S3
6. **CI/CD**: GitHub Actions pipeline - test, build, scan, deploy
7. **Monitoring**: Prometheus metrics, Grafana dashboards

The system handles zero-downtime deployments, automatically scales under load, and includes comprehensive health checks."

### Key Features to Highlight
- ✅ Handles 1000+ requests/second
- ✅ Self-healing (Kubernetes restarts failed pods)
- ✅ Security scanning in CI/CD
- ✅ Multi-environment deployments
- ✅ Infrastructure versioned in Git
- ✅ Observability built-in

---

## Troubleshooting

### Docker Issues
```bash
# Clean everything
docker system prune -a

# Check logs
docker-compose logs -f ml-api
```

### Kubernetes Issues
```bash
# Check pod status
kubectl get pods -n ml-platform

# View logs
kubectl logs -n ml-platform deployment/ml-api

# Describe resources
kubectl describe pod -n ml-platform ml-api-xxxxx

# Check events
kubectl get events -n ml-platform --sort-by='.lastTimestamp'
```

### Terraform Issues
```bash
# Validate syntax
terraform validate

# Show current state
terraform show

# Destroy everything
terraform destroy
```

---

## Next Steps to Extend

1. **Add Redis caching** for predictions
2. **Implement A/B testing** with Istio
3. **Add model versioning** with MLflow
4. **Set up centralized logging** with ELK stack
5. **Implement canary deployments**
6. **Add API authentication** with JWT
7. **Create Helm charts** for package management
8. **Add integration tests** in pipeline

---

## Cost Considerations

### Free Tier (Learning)
- Minikube: Free (local)
- Docker Desktop: Free
- GitHub Actions: 2000 min/month free

### AWS Costs (if using cloud)
- EKS: ~$72/month (cluster)
- EC2: ~$50/month (3x t3.medium nodes)
- **Total: ~$120-150/month**

**Tip**: Use `terraform destroy` when not practicing!

---

## Resources
- Docker Docs: https://docs.docker.com
- Kubernetes Docs: https://kubernetes.io/docs
- Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws
- GitHub Actions: https://docs.github.com/actions

---

## Success Checklist

You've successfully learned DevOps when you can:
- [ ] Build and run containers locally
- [ ] Deploy to Kubernetes cluster
- [ ] Perform rolling updates
- [ ] Scale applications
- [ ] Provision cloud infrastructure with Terraform
- [ ] Set up automated CI/CD pipeline
- [ ] Monitor application health
- [ ] Troubleshoot production issues
- [ ] Explain your architecture confidently

**This project is your proof of these skills!**
