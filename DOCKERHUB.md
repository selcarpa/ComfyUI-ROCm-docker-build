# ComfyUI ROCm

![License](https://img.shields.io/badge/license-GPL--3.0-blue) ![ROCm](https://img.shields.io/badge/ROCm-7.2.4-green) ![PyTorch](https://img.shields.io/badge/PyTorch-2.10.0-red) ![ComfyUI](https://img.shields.io/badge/ComfyUI-v0.22.0-orange)

**Run ComfyUI on AMD GPUs using ROCm** — Pre-built Docker image for AMD Radeon RX 6000/7000/9000 series.

---

## Quick Start

### Prerequisites

- AMD GPU: RX 6000/7000/9000 series (RDNA 2/3/4)
- ROCm 7.2.4+ driver installed on host
- Docker and Docker Compose installed

### 1. Create docker-compose.yaml

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
      - ./data/models:/workspace/ComfyUI/models
      - ./data/output:/workspace/ComfyUI/output
      - ./data/input:/workspace/ComfyUI/input
      - ./data/custom_nodes:/workspace/ComfyUI/custom_nodes
      - ./data/user:/workspace/ComfyUI/user
      - ./data/temp:/workspace/ComfyUI/temp
    environment:
      - HIP_VISIBLE_DEVICES=0
      - CUDA_VISIBLE_DEVICES=""
    restart: unless-stopped
```

### 2. Add User to GPU Groups

```bash
sudo usermod -a -G render,video $USER
# Log out and log back in for changes to take effect
```

### 3. Start Container

```bash
docker compose up -d
```

Access ComfyUI at: **http://localhost:8188**

---

## Model Setup

Place model files in `./data/models/`:
```
data/models/
├── checkpoints/    # Stable Diffusion models
├── vae/           # VAE models
├── loras/         # LoRA files
└── ...
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `HIP_VISIBLE_DEVICES` | `0` | GPU device index |
| `CUDA_VISIBLE_DEVICES` | `""` | Must be empty |
| `COMFYUI_MANAGER_DISABLED` | `false` | Disable auto-restore of ComfyUI-Manager |

---

## GPU Compatibility

| GPU Series | Architecture | Examples |
|------------|--------------|----------|
| RX 9000 | RDNA 4 | RX 9070 XT, RX 9070 |
| RX 7000 | RDNA 3 | RX 7900 XTX, RX 7800 XT |
| RX 6000 | RDNA 2 | RX 6950 XT, RX 6800 |

> Tested on: AMD Radeon RX 7800 XT (16GB VRAM, RDNA 3)

---

## Links

For detailed documentation, troubleshooting, and build instructions, visit:

**[GitHub Repository](https://github.com/selcarpa/ComfyUI-ROCm)**

⭐ **If this image is useful, please star the repo!**

---

## License

GPL-3.0 | ComfyUI: GPL-3.0 | PyTorch: BSD 3-Clause | AMD ROCm: Open Source

---

# 中文说明

本镜像用于在 AMD GPU 上运行 ComfyUI，支持 RX 6000/7000/9000 系列显卡。

## 快速启动

### 前置要求

- AMD GPU: RX 6000/7000/9000 系列
- 主机已安装 ROCm 7.2.4+ 驱动
- 已安装 Docker 和 Docker Compose

### 1. 创建 docker-compose.yaml

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
      - ./data/models:/workspace/ComfyUI/models
      - ./data/output:/workspace/ComfyUI/output
      - ./data/input:/workspace/ComfyUI/input
      - ./data/custom_nodes:/workspace/ComfyUI/custom_nodes
      - ./data/user:/workspace/ComfyUI/user
      - ./data/temp:/workspace/ComfyUI/temp
    environment:
      - HIP_VISIBLE_DEVICES=0
      - CUDA_VISIBLE_DEVICES=""
    restart: unless-stopped
```

### 2. 添加 GPU 权限

```bash
sudo usermod -a -G render,video $USER
# 注销并重新登录
```

### 3. 启动容器

```bash
docker compose up -d
```

访问 ComfyUI：**http://localhost:8188**

## 模型设置

将模型文件放入 `./data/models/` 目录。

## 相关链接

详细文档、故障排除和构建说明请访问：

**[GitHub 仓库](https://github.com/selcarpa/ComfyUI-ROCm)**

⭐ **如果觉得有用，请给仓库点个 Star！**

---

GPL-3.0 许可
