#!/bin/bash
# build.sh - Build ComfyUI ROCm Docker image
# Usage: ./build.sh [version] [--push]
#   version   - Image tag (default: latest)
#   --push    - Push images after building (requires docker login)
#
# Environment variables (override defaults):
#   COMFYUI_TAG - ComfyUI Git tag (default: v0.22.0)
#   COMFYUI_MANAGER_TAG - ComfyUI-Manager Git tag (default: 4.2.1)
#   BASE_IMAGE_TAG - ROCm PyTorch base image tag
#   IMAGE_NAME     - Docker image name (default: selcarpa/comfyui-rocm)
#   TAG_PREFIX     - Docker tag prefix (default: empty)

set -e

# Configuration (can be overridden by environment variables)
IMAGE_NAME="${IMAGE_NAME:-selcarpa/comfyui-rocm}"
COMFYUI_TAG="${COMFYUI_TAG:-v0.22.0}"
COMFYUI_MANAGER_TAG="${COMFYUI_MANAGER_TAG:-4.2.1}"
BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.10.0}"
TAG_PREFIX="${TAG_PREFIX:-}"
PUSH="${PUSH:-false}"

# First positional arg is version tag
VERSION="latest"
for arg in "$@"; do
  if [ "$arg" = "--push" ]; then
    PUSH=true
  elif [ "${arg:0:1}" != "-" ]; then
    VERSION="$arg"
  fi
done

DETAILED_TAG="${TAG_PREFIX}$(TZ=Asia/Shanghai date +%Y%m%d_%H%M)_comfyui_${COMFYUI_TAG}__${BASE_IMAGE_TAG}"

echo "🐳 Building ComfyUI ROCm Docker image..."
echo "📦 Tags: ${IMAGE_NAME}:${VERSION}, ${IMAGE_NAME}:${DETAILED_TAG}"
echo "📦 ComfyUI tag: ${COMFYUI_TAG}"
echo "📦 Manager tag: ${COMFYUI_MANAGER_TAG}"
echo "📦 Base image: rocm/pytorch:${BASE_IMAGE_TAG}"
echo ""

# Build the image with both tags
echo "🔨 Building Docker image..."
docker build \
  -f docker/Dockerfile \
  --build-arg COMFYUI_TAG="${COMFYUI_TAG}" \
  --build-arg COMFYUI_MANAGER_TAG="${COMFYUI_MANAGER_TAG}" \
  --build-arg BASE_IMAGE_TAG="${BASE_IMAGE_TAG}" \
  -t "${IMAGE_NAME}:${VERSION}" \
  -t "${IMAGE_NAME}:${DETAILED_TAG}" \
  .

if [ "$PUSH" = "true" ]; then
  echo "📤 Pushing Docker images..."
  docker push "${IMAGE_NAME}:${VERSION}"
  docker push "${IMAGE_NAME}:${DETAILED_TAG}"
  echo "✅ Push complete!"
fi
