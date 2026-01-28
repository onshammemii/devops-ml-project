#!/bin/bash

# Quick Start Script - Run everything with one command

echo "🚀 DevOps ML Project - Quick Start"
echo "===================================="
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose not found. Please install Docker Compose first."
    exit 1
fi

echo "✓ Prerequisites checked"
echo ""

# Start everything
echo "Starting all services..."
docker-compose up -d --build

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 15

# Check if services are running
echo ""
echo "Checking service health..."

# Check API
if curl -s http://localhost:5000/health > /dev/null; then
    echo "✅ ML API is running"
else
    echo "❌ ML API failed to start"
fi

# Check Prometheus
if curl -s http://localhost:9090/-/healthy > /dev/null; then
    echo "✅ Prometheus is running"
else
    echo "❌ Prometheus failed to start"
fi

# Check Grafana
if curl -s http://localhost:3000/api/health > /dev/null; then
    echo "✅ Grafana is running"
else
    echo "❌ Grafana failed to start"
fi

echo ""
echo "================================================"
echo "🎉 DevOps ML Platform is LIVE!"
echo "================================================"
echo ""
echo "Access your services:"
echo "  📊 ML API:        http://localhost:5000"
echo "  📈 Prometheus:    http://localhost:9090"
echo "  📉 Grafana:       http://localhost:3000 (admin/admin)"
echo "  🔧 Load Balancer: http://localhost"
echo ""
echo "Test the API:"
echo '  curl -X POST http://localhost:5000/predict \'
echo '    -H "Content-Type: application/json" \'
echo '    -d '"'"'{"text": "This is amazing!"}'"'"
echo ""
echo "View logs:"
echo "  docker-compose logs -f ml-api"
echo ""
echo "Stop everything:"
echo "  docker-compose down"
echo ""
