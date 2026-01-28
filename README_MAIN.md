# 🚀 Production-Ready DevOps ML Platform

A **real, working** project that demonstrates enterprise DevOps practices for ML applications.

**Not just theory** - this is deployable, scalable, and production-ready code that you can run, break, fix, and learn from.

---

## 🎯 What You're Actually Building

A sentiment analysis API that processes text and returns sentiment predictions, deployed with:
- ✅ Docker containerization
- ✅ Kubernetes orchestration  
- ✅ Terraform infrastructure provisioning
- ✅ GitHub Actions CI/CD pipeline
- ✅ Prometheus + Grafana monitoring

**This isn't a tutorial. It's real infrastructure you can deploy.**

---

## ⚡ Quick Start (5 minutes)

### Prerequisites
- Docker & Docker Compose installed
- 8GB RAM free
- That's it!

### Run Everything Locally

```bash
# 1. Clone/download this project
cd devops-ml-project

# 2. Start everything with ONE command
./start.sh

# 3. Test the API
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "This is amazing!"}'
```

**That's it!** You now have:
- ML API running → `http://localhost:5000`
- Grafana dashboards → `http://localhost:3000` (admin/admin)
- Prometheus metrics → `http://localhost:9090`
- NGINX load balancer → `http://localhost`

---

## 📁 Project Structure

```
devops-ml-project/
├── app/                    # ML Application
│   ├── app.py             # Flask API with scikit-learn
│   ├── Dockerfile         # Multi-stage optimized build
│   ├── requirements.txt   # Python dependencies
│   └── tests/            # Unit tests with pytest
│
├── k8s/                   # Kubernetes Manifests
│   └── deployment.yaml    # Deployment, Service, HPA, PVC
│
├── terraform/             # Infrastructure as Code
│   └── main.tf           # AWS VPC, EKS, ECR, S3
│
├── .github/workflows/     # CI/CD Pipeline
│   └── ci-cd.yml         # Automated testing & deployment
│
├── monitoring/            # Observability Stack
│   ├── prometheus.yml    # Metrics collection config
│   └── grafana-datasources.yml
│
├── nginx/                 # Load Balancer
│   └── nginx.conf        # Reverse proxy config
│
├── docker-compose.yml     # Local development environment
├── start.sh              # Quick start script
├── test.sh               # Testing script
└── Makefile              # Common commands
```

---

## 🎮 How to Use This Project

### Level 1: Run Locally (Docker Compose)
**Perfect for learning and testing**

```bash
# Start everything
make run
# or
./start.sh

# View logs
make logs

# Stop everything
make stop
```

### Level 2: Deploy to Kubernetes (Minikube)
**Practice container orchestration**

```bash
# Start Minikube cluster
minikube start --cpus=4 --memory=8192

# Build image locally
eval $(minikube docker-env)
cd app && docker build -t sentiment-api:latest .

# Deploy
make k8s-deploy

# Watch it scale
kubectl get pods -n ml-platform -w

# Test autoscaling
kubectl run -it load-gen --image=busybox -- /bin/sh
while true; do wget -q -O- http://ml-api-service.ml-platform/predict; done
```

### Level 3: Deploy to AWS (Production)
**Real cloud infrastructure**

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"

# Provision infrastructure (~15 minutes)
cd terraform
terraform init
terraform apply

# Connect to cluster
aws eks update-kubeconfig --name ml-platform-cluster --region us-east-1

# Deploy application
kubectl apply -f ../k8s/deployment.yaml

# Get service URL
kubectl get svc ml-api-service -n ml-platform
```

---

## 🧪 Testing the API

### Basic Tests
```bash
# Run automated test suite
./test.sh

# Or manually:
# Health check
curl http://localhost:5000/health

# Single prediction
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "I love this product!"}'

# Batch predictions
curl -X POST http://localhost:5000/batch-predict \
  -H "Content-Type: application/json" \
  -d '{"texts": ["Great!", "Terrible", "Okay"]}'

# Model info
curl http://localhost:5000/model-info
```

### Load Testing
```bash
# Install Apache Bench
apt-get install apache2-utils

# Send 10,000 requests
ab -n 10000 -c 100 -p request.json -T application/json http://localhost:5000/predict
```

---

## 🔄 CI/CD Pipeline

Push to GitHub and watch the magic happen:

```bash
# Initialize git repo
git init
git add .
git commit -m "Initial commit"

# Push to GitHub
git remote add origin https://github.com/YOUR_USERNAME/devops-ml-project.git
git push -u origin main
```

**What happens automatically:**
1. ✅ Code linting (flake8, black)
2. ✅ Security scanning (bandit, trivy)
3. ✅ Unit tests (pytest)
4. ✅ Docker build & push to ECR
5. ✅ Deploy to Kubernetes
6. ✅ Smoke tests

**GitHub Secrets needed:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ECR_REGISTRY`

---

## 📊 Monitoring & Metrics

### Access Dashboards

**Grafana** (Visualization)
- URL: `http://localhost:3000`
- Username: `admin`
- Password: `admin`

**Prometheus** (Metrics)
- URL: `http://localhost:9090`

### Key Metrics
- Request rate: `rate(http_requests_total[5m])`
- Error rate: `rate(http_requests_total{status="500"}[5m])`
- Latency: `http_request_duration_seconds`
- Pod CPU/Memory usage

---

## 💡 What This Demonstrates

### Docker Skills
- [x] Multi-stage builds
- [x] Non-root user security
- [x] Layer caching optimization
- [x] Health checks
- [x] Volume management

### Kubernetes Skills
- [x] Deployments with rolling updates
- [x] Services (LoadBalancer)
- [x] ConfigMaps & Secrets
- [x] Liveness & Readiness probes
- [x] Horizontal Pod Autoscaler
- [x] Persistent Volume Claims
- [x] Resource limits & requests

### Terraform Skills
- [x] VPC with public/private subnets
- [x] EKS cluster provisioning
- [x] ECR repository
- [x] S3 bucket with versioning
- [x] IAM roles & policies
- [x] Security groups

### CI/CD Skills
- [x] Automated testing
- [x] Security scanning
- [x] Multi-environment deployment
- [x] Rollback capability
- [x] Blue-green deployments

### Monitoring Skills
- [x] Prometheus metrics collection
- [x] Grafana dashboards
- [x] Application instrumentation
- [x] Alert rules

---

## 🎯 Interview Scenarios

### "Tell me about your DevOps project"

> "I built a production-ready sentiment analysis API demonstrating end-to-end DevOps practices. The ML model is containerized with Docker, orchestrated with Kubernetes for zero-downtime deployments and autoscaling, and the infrastructure is provisioned with Terraform. I set up a complete CI/CD pipeline with GitHub Actions that runs tests, security scans, builds images, and deploys automatically. The system includes monitoring with Prometheus and Grafana, and can handle thousands of requests per second with automatic scaling."

### "Show me a real DevOps challenge you solved"

Run through:
1. Simulate pod failure → Show self-healing
2. Load test → Show autoscaling
3. Deploy new version → Show rolling update
4. Rollback → Show quick recovery

### "Explain your infrastructure"

Walk through the Terraform files and show:
- Network architecture (VPC, subnets)
- Kubernetes cluster setup
- Security (IAM, security groups)
- Persistent storage strategy

---

## 🔥 Advanced Challenges

Try these to level up:

1. **Add Redis Caching**
   - Cache predictions for duplicate requests
   - Reduce model inference load

2. **Implement A/B Testing**
   - Deploy two model versions
   - Split traffic 50/50

3. **Add Authentication**
   - Implement JWT tokens
   - Rate limiting per user

4. **Multi-region Deployment**
   - Deploy to 2+ AWS regions
   - Add Route53 for geo-routing

5. **Blue-Green Deployment**
   - Deploy v2 alongside v1
   - Switch traffic instantly

6. **Canary Deployment**
   - Route 10% traffic to new version
   - Gradually increase

---

## 🛠️ Troubleshooting

### Docker Issues
```bash
# Container won't start
docker logs ml-api-test

# Clean everything
docker system prune -a

# Check resource usage
docker stats
```

### Kubernetes Issues
```bash
# Pod stuck in Pending
kubectl describe pod <pod-name> -n ml-platform

# Check events
kubectl get events -n ml-platform --sort-by='.lastTimestamp'

# View logs
kubectl logs -f deployment/ml-api -n ml-platform
```

### Terraform Issues
```bash
# Validate configuration
terraform validate

# Show what will change
terraform plan

# Force unlock if stuck
terraform force-unlock <lock-id>
```

---

## 💰 Cost Breakdown

### Local (Free)
- Docker Desktop: Free
- Minikube: Free
- GitHub Actions: 2000 min/month free

### AWS (Paid)
- EKS Cluster: ~$72/month
- EC2 Nodes (3x t3.medium): ~$75/month
- Load Balancer: ~$20/month
- **Total: ~$150-200/month**

**💡 Tip:** Use `terraform destroy` when not practicing!

---

## 📚 Learn More

- [Docker Documentation](https://docs.docker.com)
- [Kubernetes Docs](https://kubernetes.io/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws)
- [Prometheus Guide](https://prometheus.io/docs)

---

## ✅ Skills Checklist

After completing this project, you can:

- [x] Containerize applications with Docker
- [x] Write multi-stage Dockerfiles
- [x] Orchestrate containers with Kubernetes
- [x] Deploy and scale applications
- [x] Perform rolling updates
- [x] Provision cloud infrastructure with Terraform
- [x] Build CI/CD pipelines
- [x] Implement monitoring and alerting
- [x] Troubleshoot production issues
- [x] Explain your architecture confidently

---

## 🎖️ This Is Your Portfolio Piece

This project proves you can:
1. **Build** real applications
2. **Deploy** to production
3. **Scale** under load
4. **Monitor** in real-time
5. **Automate** everything

**Don't just tell recruiters you know DevOps. SHOW THEM.**

---

## 🤝 Contributing

This is a learning project. Feel free to:
- Add features
- Improve configurations
- Share your modifications
- Create issues for questions

---

## 📝 License

MIT License - Use this however you want for learning and interviews!

---

## 🚀 Next Steps

1. **Clone this repo**
2. **Run `./start.sh`**
3. **Break things and fix them**
4. **Add your own features**
5. **Put it on your resume**

**Good luck with your DevOps journey! 🎯**
