# Real-World DevOps ML Project: Sentiment Analysis API

## What You're Building
A production-ready sentiment analysis microservice with:
- **Machine Learning API** (Flask + scikit-learn)
- **Containerization** (Docker + Docker Compose)
- **Orchestration** (Kubernetes on local cluster)
- **IaC** (Terraform for cloud resources)
- **CI/CD** (GitHub Actions pipeline)
- **Monitoring** (Prometheus + Grafana)

## Architecture
```
User Request → Load Balancer → API Gateway → ML Service → Model
                                    ↓
                              Metrics/Logs → Monitoring
```

## Quick Start
1. `docker-compose up` - Run locally
2. `kubectl apply -k k8s/` - Deploy to Kubernetes
3. `terraform apply` - Provision cloud infrastructure
4. Push to GitHub - Triggers CI/CD pipeline

## What Makes This Real
- Actual ML model training and versioning
- Health checks and readiness probes
- Rolling updates with zero downtime
- Resource limits and autoscaling
- Secrets management
- Multi-environment configs (dev/staging/prod)
