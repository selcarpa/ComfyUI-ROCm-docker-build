# ComfyUI ROCm Docker Image

[中文](README.md)

🔥 **ComfyUI with AMD ROCm support** — Run ComfyUI on AMD GPUs with optimized ROCm-compatible dependencies.

[![Docker Pulls](https://img.shields.io/docker/pulls/selcarpa/comfyui-rocm)](https://hub.docker.com/r/selcarpa/comfyui-rocm) [![ROCm](https://img.shields.io/badge/ROCm-7.2.4+-green)](https://rocm.docs.amd.com/) [![AMD GPU](https://img.shields.io/badge/AMD-RX%206000%2F7000%2F9000-red)](https://www.amd.com/en/products/graphics/desktops/radeon.html) [![License](https://img.shields.io/github/license/selcarpa/comfyui-rocm)](https://github.com/selcarpa/comfyui-rocm/blob/main/LICENSE) [![Last Commit](https://img.shields.io/github/last-commit/selcarpa/comfyui-rocm)](https://github.com/selcarpa/comfyui-rocm/commits/main)

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
- 📦 **ComfyUI-Manager built-in** — Node manager pre-installed, no manual setup needed
- 💾 **Persistent storage** — Models and outputs preserved across restarts

## 🚀 Quick Start

```bash
docker compose up -d
```

Access ComfyUI at: **http://localhost:8188**

## 📋 Requirements

| Component  | Requirement                                |
| ---------- | ------------------------------------------ |
| **GPU**    | AMD RX 6000/7000/9000 series (RDNA 2/3/4, based on ROCm 7.2.4 compatibility) [^1] |
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

> **ComfyUI-Manager auto-restore**: The image ships with ComfyUI-Manager pre-installed. On startup, if missing from the `custom_nodes` volume, it is automatically restored from the image backup and the `--enable-manager` flag is appended to enable the manager UI. Set `COMFYUI_MANAGER_DISABLED=true` to disable this behavior.

## ⚡ Performance & Hardware

### Tested Hardware
- **AMD Radeon RX 7800 XT** (16GB VRAM, RDNA 3, gfx1101) ✅

> This project has only been tested on RX 7800 XT. According to the [AMD ROCm Official Compatibility Matrix](https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html), other AMD GPUs compatible with ROCm 7.2.4 should theoretically work. If you encounter issues, please file a [GitHub Issue](https://github.com/selcarpa/ComfyUI-ROCm/issues).

### Performance Metrics
- **Generation Time**: ~30-60s for 512x512 images
- **VRAM Usage**: 4-8GB for basic operations
- **Model Loading**: ~30-60s first time, cached afterward
- **Batch Processing**: Multiple images supported

### Tips
- Mount persistent volumes to avoid re-downloading models
- Start with `default` models, upgrade to larger sets as needed
- Use fast SSD storage for optimal performance

### GPU Compatibility

According to the [AMD ROCm Official Compatibility Matrix](https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html), ROCm 7.2.4 theoretically supports the following AMD GPU families:

| Series | Architecture | gfx target | Representative Models |
|--------|--------------|------------|----------------------|
| RX 9000 | RDNA 4 | gfx1200/gfx1201 | RX 9070 XT, RX 9070, RX 9060 |
| RX 7000 | RDNA 3 | gfx1100/gfx1101/gfx1102 | RX 7900 XTX/XT, RX 7800 XT, RX 7700, RX 7600 |
| RX 6000 | RDNA 2 | gfx1030/gfx1031/gfx1032 | RX 6950 XT, RX 6800 XT, RX 6700 XT, RX 6600 XT |

> **Source**: [AMD GPU Architecture Specifications](https://rocm.docs.amd.com/en/latest/reference/gpu-arch-specs.html)

## 🔍 Troubleshooting

For issues, please file a [GitHub Issue](https://github.com/selcarpa/ComfyUI-ROCm/issues).

## 🔄 Changes Since Initial Release

### 🗑️ Removed
- **Auto model downloader** — Removed `download_models.py` + `models.yaml`; models must now be placed manually (see [MODEL_SETUP_EN.md](MODEL_SETUP_EN.md))
- **Build-time model copy** — Removed model-related COPY and env vars from Dockerfile

### 🆕 Added
- **ComfyUI-Manager** — Pre-installed node manager, auto-restored on startup, ready to use out of the box
- **Build system** — `build.sh` + build guides with configurable versions and automatic image tagging
- **Model setup guides** — Documenting manual model placement
- **CI/CD automation** — GitHub Actions for automated Docker build & push
- **Health check** — Container auto-detects whether ComfyUI is running properly

### 🔧 Changes

| Aspect | Description |
|--------|-------------|
| **ROCm upgrade** | Base image upgraded from ROCm 6.4.1 → **7.2.4**, PyTorch 2.6.0 → **2.10.0**; theoretically supports RX 6000/7000/9000 series (based on ROCm 7.2.4 compatibility), only tested on RX 7800 XT |
| **ComfyUI version pinning** | Switched from pulling latest to checking out a specific tag (`v0.22.0`) for reproducible builds |
| **Dependency optimization** | Full Python dependency review; removed ROCm-incompatible packages; added `comfyui-manager` and other ecosystem packages; unified version pinning |
| **Node management** | ComfyUI-Manager pre-installed — cloned at build time, backed up, auto-restored to volume on startup |
| **Container config** | Refactored docker-compose with persistent volumes (models, output, input, custom nodes, config), health check, and environment variables |
| **Build system** | build.sh supports configurable versions via env vars (ComfyUI/Manager/Base image), auto-generates timestamped detailed tags |

## 📄 License & Credits

This project is licensed under GPL-3.0. See the [LICENSE](LICENSE) file for details.

### Third-Party Components
- **ComfyUI**: GPL-3.0 — [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **PyTorch**: BSD 3-Clause — [PyTorch](https://pytorch.org/)
- **ROCm**: Various OSS licenses — [AMD ROCm](https://rocm.docs.amd.com/)

**Acknowledgments:**
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) — Node-based AI workflow interface
- [ComfyUI-Manager](https://github.com/Comfy-Org/ComfyUI-Manager) — Custom node manager
- [ComfyUI-ROCm](https://github.com/corundex/ComfyUI-ROCm) — Upstream AMD ROCm reference repository
- [AMD ROCm](https://rocm.docs.amd.com/) — Open source GPU computing platform
- ROCm community for AMD GPU AI support

[^1]: AMD's official compatibility matrix shows ROCm 7.2.4 supports gfx1030 (RX 6000), gfx1100/gfx1101 (RX 7000), gfx1200/gfx1201 (RX 9000) and more GPU families. See [ROCm Compatibility Matrix](https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html) and [AMD GPU Architecture Specifications](https://rocm.docs.amd.com/en/latest/reference/gpu-arch-specs.html).

---

🔗 **Links:** [Docker Hub](https://hub.docker.com/r/selcarpa/comfyui-rocm) | [GitHub](https://github.com/selcarpa/comfyui-rocm) | [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
