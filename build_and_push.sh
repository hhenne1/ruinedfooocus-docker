#!/bin/bash
#
# This script builds and pushes the RuinedFooocus Docker image to GitHub Container Registry (GHCR).
#
# Prerequisites:
#   - Docker is installed.
#   - You are logged in to GHCR (docker login ghcr.io).
#   - The following environment variables are set:
#     - GHCR_USERNAME (Your GitHub username)
#     - IMAGE_NAME (The name of the image, e.g., ruinedfooocus)
#
# Usage:
#   ./build_and_push.sh
#
# Set errexit so that the script will exit immediately if a command exits with a non-zero status.
set -e

# Set variables.  Customize these as needed.
GHCR_USERNAME="hhenne1" # Replace with your GitHub username.
IMAGE_NAME="ruinedfooocus" #  The name of the image
TAG="latest" # default tag

# Build the Docker image.
docker build -t ${IMAGE_NAME}:${TAG} .

# Tag the image for GHCR.
docker tag ${IMAGE_NAME}:${TAG} ghcr.io/${GHCR_USERNAME}/${IMAGE_NAME}:${TAG}

# Push the image to GHCR.
docker push ghcr.io/${GHCR_USERNAME}/${IMAGE_NAME}:${TAG}

echo "Successfully built and pushed image to ghcr.io/${GHCR_USERNAME}/${IMAGE_NAME}:${TAG}"
