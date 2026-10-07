# ROCm ComfyUI Dockerfile
# Based on AMD's official ROCm PyTorch container

ARG BASE_IMAGE_TAG=rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.10.0
FROM rocm/pytorch:${BASE_IMAGE_TAG}

WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
  git \
  wget \
  curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install python-is-python3 if python command is not found
RUN if ! command -v python &> /dev/null; then \
      apt-get update && apt-get install -y python-is-python3 && \
      apt-get clean && rm -rf /var/lib/apt/lists/*; \
    fi

# Clone ComfyUI at specified tag
ARG COMFYUI_TAG
RUN git clone --branch "${COMFYUI_TAG}" --depth 1 https://github.com/comfyanonymous/ComfyUI.git

# Set ComfyUI as working directory
WORKDIR /workspace/ComfyUI

# Create necessary directories with separate commands
RUN mkdir -p /workspace/ComfyUI/models/checkpoints && \
  mkdir -p /workspace/ComfyUI/models/vae && \
  mkdir -p /workspace/ComfyUI/models/loras && \
  mkdir -p /workspace/ComfyUI/models/embeddings && \
  mkdir -p /workspace/ComfyUI/models/upscale_models && \
  mkdir -p /workspace/ComfyUI/models/controlnet && \
  mkdir -p /workspace/ComfyUI/output && \
  mkdir -p /workspace/ComfyUI/input && \
  mkdir -p /workspace/ComfyUI/custom_nodes

# Clone ComfyUI-Manager into custom_nodes and backup for volume mount fallback
ARG COMFYUI_MANAGER_TAG=4.2.1
RUN git clone --branch "${COMFYUI_MANAGER_TAG}" --depth 1 \
  https://github.com/ltdrdata/ComfyUI-Manager.git \
  /workspace/ComfyUI/custom_nodes/comfyui-manager && \
  cp -r /workspace/ComfyUI/custom_nodes /workspace/.default_nodes

# Copy requirements file (pre-generated at build time with synced comfyui versions)
COPY requirements_rocm.txt /workspace/

# Install Python dependencies using the generated requirements
RUN pip install --no-cache-dir -r /workspace/requirements_rocm.txt

# Copy startup script and sample workflow
COPY docker/startup.sh /workspace/startup.sh
COPY docker/sample_workflow.json /workspace/ComfyUI/

# Make startup script executable
RUN chmod +x /workspace/startup.sh

# Expose ComfyUI port
EXPOSE 8188

# Health check to ensure ComfyUI is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8188/ || exit 1

CMD ["/workspace/startup.sh"]
