#!/bin/bash

# DevOps ML Project - Quick Test Script
# This script tests the entire application locally

set -e

echo "================================================"
echo "DevOps ML Project - Testing Suite"
echo "================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo "🔍 Checking prerequisites..."
command -v docker >/dev/null 2>&1 || { echo -e "${RED}❌ Docker is not installed${NC}"; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo -e "${RED}❌ Docker Compose is not installed${NC}"; exit 1; }
echo -e "${GREEN}✓ Docker and Docker Compose are available${NC}"
echo ""

# Build the application
echo "🏗️  Building Docker image..."
cd app
docker build -t sentiment-api:test . --quiet
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image built successfully${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi
echo ""

# Run container
echo "🚀 Starting container..."
docker run -d --name ml-api-test -p 5555:5000 sentiment-api:test
sleep 5
echo -e "${GREEN}✓ Container started${NC}"
echo ""

# Test endpoints
echo "🧪 Testing API endpoints..."

# Health check
echo -n "Testing /health endpoint... "
HEALTH=$(curl -s http://localhost:5555/health)
if echo "$HEALTH" | grep -q "healthy"; then
    echo -e "${GREEN}✓ PASSED${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

# Readiness check
echo -n "Testing /ready endpoint... "
READY=$(curl -s http://localhost:5555/ready)
if echo "$READY" | grep -q "ready"; then
    echo -e "${GREEN}✓ PASSED${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

# Prediction test
echo -n "Testing /predict endpoint... "
PREDICT=$(curl -s -X POST http://localhost:5555/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "This product is amazing!"}')
if echo "$PREDICT" | grep -q "sentiment"; then
    echo -e "${GREEN}✓ PASSED${NC}"
    echo "  Response: $PREDICT"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

# Batch prediction test
echo -n "Testing /batch-predict endpoint... "
BATCH=$(curl -s -X POST http://localhost:5555/batch-predict \
  -H "Content-Type: application/json" \
  -d '{"texts": ["Great!", "Terrible", "Okay"]}')
if echo "$BATCH" | grep -q "predictions"; then
    echo -e "${GREEN}✓ PASSED${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

# Model info test
echo -n "Testing /model-info endpoint... "
INFO=$(curl -s http://localhost:5555/model-info)
if echo "$INFO" | grep -q "model_type"; then
    echo -e "${GREEN}✓ PASSED${NC}"
else
    echo -e "${RED}❌ FAILED${NC}"
fi

echo ""

# Performance test
echo "⚡ Running basic performance test..."
echo "Sending 100 requests..."
START=$(date +%s)
for i in {1..100}; do
    curl -s -X POST http://localhost:5555/predict \
      -H "Content-Type: application/json" \
      -d '{"text": "Test message"}' > /dev/null
done
END=$(date +%s)
DURATION=$((END - START))
RPS=$((100 / DURATION))
echo -e "${GREEN}✓ Completed 100 requests in ${DURATION}s (~${RPS} req/s)${NC}"
echo ""

# Cleanup
echo "🧹 Cleaning up..."
docker stop ml-api-test > /dev/null 2>&1
docker rm ml-api-test > /dev/null 2>&1
echo -e "${GREEN}✓ Cleanup complete${NC}"
echo ""

echo "================================================"
echo -e "${GREEN}✅ All tests completed successfully!${NC}"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Run: docker-compose up --build"
echo "2. Open: http://localhost:5000"
echo "3. Monitor: http://localhost:3000 (Grafana)"
echo ""
