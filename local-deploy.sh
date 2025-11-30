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

cat > clusters/staging/task-manager-release.yaml <<YAML
---
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: task-manager
  namespace: flux-system
spec:
  chart:
    spec:
      chart: ./_infra/task-manager
      reconcileStrategy: ChartVersion
      sourceRef:
        kind: GitRepository
        name: flux-system
  install:
    createNamespace: true
  interval: 1m0s
  targetNamespace: task-manager
  values:
    image:
      tag: "$TAG"
    test:
      image:
        tag: "$TAG"
YAML

# 5. Commit and Push to Git
echo "Cc Committing and Pushing changes..."
git add clusters/staging/task-manager-release.yaml
git commit -m "chore(release): update task-manager to version $TAG"
git push origin main