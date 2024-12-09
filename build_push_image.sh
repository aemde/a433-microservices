#!/bin/bash

# Nama image dan tag
IMAGE_NAME="aemde/item-app"
IMAGE_TAG="v1"

# Membuat Docker image dengan nama dan tag
echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Melihat daftar Docker image lokal
echo "Listing Docker images..."
docker images

# Login ke Docker Hub
echo "Logging in to Docker Hub..."
docker login

# Push Docker image ke Docker Hub
echo "Pushing Docker image to Docker Hub..."
docker push ${IMAGE_NAME}:${IMAGE_TAG}

# Informasi sukses
echo "Docker image ${IMAGE_NAME}:${IMAGE_TAG} has been pushed successfully!"
