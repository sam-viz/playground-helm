#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# 1. Generate a unique tag based on the git commit
TAG=$(git rev-parse --short HEAD)
echo "🚀 Starting Local Deployment for version: $TAG"

# 2. Build the App Image
echo "📦 Building App Image (task-manager:$TAG)..."
docker build -t task-manager:$TAG -f _infra/dockerfile .

# 3. Build the Test Runner Image
echo "📦 Building Test Runner Image (task-manager-api-test:$TAG)..."
docker build -t task-manager-api-test:$TAG -f _infra/api-test.dockerfile .

# 4. Upgrade Helm Release
# We use --set to dynamically override the values.yaml without modifying the file on disk.
# This keeps your git working tree clean while achieving the same result.
echo "☸️  Upgrading Helm Release..."
helm upgrade --install manager-deploy ./_infra/task-manager \
  --namespace task-manager \
  --set image.tag=$TAG \
  --set test.image.tag=$TAG

echo "✅ Deployment Complete! Verifying pods..."
kubectl get pods -n task-manager
