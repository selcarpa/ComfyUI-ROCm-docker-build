# ComfyUI ROCm Docker Image

[中文](README.md)

🔥 **ComfyUI with AMD ROCm support** — Run ComfyUI on AMD GPUs with optimized ROCm-compatible dependencies.

[![Docker Pulls](https://img.shields.io/docker/pulls/selcarpa/comfyui-rocm)](https://hub.docker.com/r/selcarpa/comfyui-rocm) [![ROCm](https://img.shields.io/badge/ROCm-7.2.4+-green)](https://rocm.docs.amd.com/) [![AMD GPU](https://img.shields.io/badge/AMD-RX%207000%2B-red)](https://www.amd.com/en/products/graphics/desktops/radeon.html)

![ComfyUI Interface](Screenshot.png)
*ComfyUI running on AMD ROCm with sample workflow and generated landscape image*

## 📋 Version Information

- **Base Image**: `rocm/pytorch:rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.10.0`
- **Python**: 3.12
- **PyTorch**: 2.10.0
- **ROCm**: 7.2.4
- **ComfyUI**: v0.22.0 (checked out by tag at build time)

## ✨ Key Features

- 🎨 **Node-based AI workflow** — Visual interface for creating complex AI pipelines
- 🔥 **AMD ROCm optimized** — Native AMD GPU acceleration with ROCm 7.2.4+
- 📦 **Flexible model management** — Place models manually, persistent volumes avoid re-downloading
- 🧪 **Tested compatibility** — All dependencies verified on real AMD hardware
- 🎯 **Ready to use** — Pre-configured with sample workflows
- 💾 **Persistent storage** — Models and outputs preserved across restarts

## 🚀 Quick Start

```bash
docker compose up -d
```

Access ComfyUI at: **http://localhost:8188**

## 📋 Requirements

| Component  | Requirement                                |
| ---------- | ------------------------------------------ |
| **GPU**    | AMD RX 7000/9000+ series with ROCm support |
| **VRAM**   | 8GB minimum (16GB+ recommended)            |
| **OS**     | Linux (Ubuntu 24.04+ recommended)          |
| **Docker** | Latest version with GPU support            |
| **ROCm**   | Drivers 7.2.4+ installed on host           |

## 🔧 Setup Instructions

### 1. Install ROCm Drivers
- **Ubuntu**: See [ROCm Linux Installation Guide](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/)
- **Arch Linux**: See [Arch Wiki - ROCm](https://wiki.archlinux.org/title/ROCm) / [AMDGPU](https://wiki.archlinux.org/title/AMDGPU)

### 2. Add User to GPU Access Groups

```bash
sudo usermod -a -G render,video $USER   # Add current user to render and video groups
```
- **render** — Access GPU render nodes `/dev/dri/render*`
- **video** — Access ROCm core device `/dev/kfd`

> A **logout/login** is required for the change to take effect (or run `newgrp render` for a temporary session).

### 3. Verify ROCm Installation

```bash
rocminfo | grep gfx          # Confirm GPU architecture (e.g. gfx1101)
cat /opt/rocm/.info/version  # Show ROCm version
lsmod | grep amdgpu          # Confirm kernel module loaded
```

### 3. Run ComfyUI
```bash
docker compose up -d
```

## 🎛️ Model Setup

Models must be placed manually into the mounted volume. See [Model Setup Guide](MODEL_SETUP_EN.md).

## 🏗️ Build Image

See [Build Guide](BUILD_EN.md).

## 🐳 Docker Compose

Volumes are pre-configured. Place models into `./data/models/` subdirectories.

```yaml
services:
  comfyui-rocm:
    image: selcarpa/comfyui-rocm:latest
    container_name: comfyui-rocm
    devices:
      - /dev/kfd:/dev/kfd
      - /dev/dri:/dev/dri
    group_add:
      - video
    ports:
      - "8188:8188"
    volumes:
      # Model files
      - ./data/models:/workspace/ComfyUI/models
      # Generated outputs
      - ./data/output:/workspace/ComfyUI/output
      # Input images
      - ./data/input:/workspace/ComfyUI/input
      # Custom nodes
      - ./data/custom_nodes:/workspace/ComfyUI/custom_nodes
      # User settings
      - ./data/user:/workspace/ComfyUI/user
    environment:
      - HIP_VISIBLE_DEVICES=0
      - CUDA_VISIBLE_DEVICES=""
    restart: unless-stopped
```

Run with: `docker compose up -d`

## ⚡ Performance & Hardware

### Tested Hardware
- **AMD Radeon RX 7800 XT** (16GB VRAM) ✅

### Performance Metrics
- **Generation Time**: ~30-60s for 512x512 images
- **VRAM Usage**: 4-8GB for basic operations
- **Model Loading**: ~30-60s first time, cached afterward
- **Batch Processing**: Multiple images supported

### Tips
- Mount persistent volumes to avoid re-downloading models
- Start with `default` models, upgrade to larger sets as needed
- Use fast SSD storage for optimal performance

## 🔍 Troubleshooting

For issues, please file a [GitHub Issue](https://github.com/selcarpa/ComfyUI-ROCm/issues).

## 🔄 Changes in This Update vs Previous Version

### 🗑️ Removed
- **`docker/download_models.py`** + **`docker/models.yaml`** — Auto model downloader removed. Models must be placed manually; see [MODEL_SETUP_EN.md](MODEL_SETUP_EN.md)

### 🆕 Added
- **`BUILD.md` / `BUILD_EN.md`** — Standalone build guides (Chinese/English)
- **`MODEL_SETUP.md` / `MODEL_SETUP_EN.md`** — Standalone model setup guides (Chinese/English)
- **`README_EN.md`** — English README (separated from Chinese version for easier maintenance)

### 🔧 Modified

| File | Changes |
|------|---------|
| `docker/Dockerfile` | Base image configurable via `ARG`; ROCm 6.4.1 → **7.2.4**, PyTorch 2.6.0 → **2.10.0**; removed `download_models.py`/`models.yaml` copy and `MODEL_DOWNLOAD` env var; **ComfyUI now checked out by tag via `ARG COMIFYUI_TAG`** (instead of pulling latest) |
| `docker-compose.yaml` | Image changed to `selcarpa/comfyui-rocm`; removed `pull_policy: always` and `MODEL_DOWNLOAD`; added `hostname` and `./data/temp` volume; added comments |
| `build.sh` | Base image configurable via `--build-arg`; version tag auto-generated from date+time; removed `--progress=plain`; **added `COMIFYUI_TAG` variable** to pin ComfyUI version, included in detailed tag |
| `docker/requirements_rocm.txt` | Full version bump (frontend 1.23.4→1.44.19, workflow-templates 0.1.30→0.9.91, etc.); added `comfy-kitchen`, `comfy-aimdo`, `comfyui-manager`, `filelock`/`requests`/`simpleeval`/`blake3`; organized by functional sections |
| `docker/startup.sh` | Removed model download step before startup; starts ComfyUI directly |
| `README.md` | Rewritten from English to Chinese; content restructured; version info updated |

## 📄 License & Credits

This project is licensed under GPL-3.0. See the [LICENSE](LICENSE) file for details.

### Third-Party Components
- **ComfyUI**: GPL-3.0 — [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **PyTorch**: BSD 3-Clause — [PyTorch](https://pytorch.org/)
- **ROCm**: Various OSS licenses — [AMD ROCm](https://rocm.docs.amd.com/)

**Acknowledgments:**
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) — Node-based AI workflow interface
- [AMD ROCm](https://rocm.docs.amd.com/) — Open source GPU computing platform
- ROCm community for AMD GPU AI support

---

🔗 **Links:** [Docker Hub](https://hub.docker.com/r/selcarpa/comfyui-rocm) | [GitHub](https://github.com/selcarpa/comfyui-rocm) | [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
