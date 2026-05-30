# ComfyUI ROCm Docker 镜像

[English](README_EN.md)

🔥 **支持 AMD ROCm 的 ComfyUI** — 在 AMD GPU 上运行 ComfyUI，预装优化过的 ROCm 兼容依赖。

[![Docker Pulls](https://img.shields.io/docker/pulls/selcarpa/comfyui-rocm)](https://hub.docker.com/r/selcarpa/comfyui-rocm) [![ROCm](https://img.shields.io/badge/ROCm-7.2.4+-green)](https://rocm.docs.amd.com/) [![AMD GPU](https://img.shields.io/badge/AMD-RX%207000%2B-red)](https://www.amd.com/en/products/graphics/desktops/radeon.html)

![ComfyUI 界面](Screenshot.png)
*ComfyUI 在 AMD ROCm 上运行示例*

## 📋 版本信息

- **基础镜像**: `rocm/pytorch:rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.10.0`
- **Python**: 3.12
- **PyTorch**: 2.10.0
- **ROCm**: 7.2.4
- **ComfyUI**: v0.22.0（构建时通过标签检出）

## ✨ 主要特性

- 🎨 **节点式 AI 工作流** — 可视化界面构建复杂 AI 流水线
- 🔥 **AMD ROCm 优化** — 原生 AMD GPU 加速，支持 ROCm 7.2.4+
- 📦 **灵活模型管理** — 手动放置模型，持久卷挂载避免重复下载
- 🧪 **经过测试的兼容性** — 所有依赖均在真实 AMD 硬件上验证
- 🎯 **开箱即用** — 预配置示例工作流
- 💾 **持久化存储** — 模型和输出跨重启保留

## 🚀 快速开始

```bash
docker compose up -d
```

访问 ComfyUI: **http://localhost:8188**

## 📋 系统要求

| 组件 | 要求 |
| ---------- | ------------------------------------------ |
| **GPU** | AMD RX 7000/9000+ 系列（支持 ROCm） |
| **VRAM** | 最低 8GB（推荐 16GB+） |
| **OS** | Linux（推荐 Ubuntu 24.04+） |
| **Docker** | 最新版本，支持 GPU |
| **ROCm** | 宿主机安装 7.2.4+ 驱动 |

## 🔧 安装步骤

### 1. 安装 ROCm 驱动
- **Ubuntu**: 参见 [ROCm Linux 安装指南](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/)
- **Arch Linux**: 参见 [Arch Wiki - ROCm](https://wiki.archlinux.org/title/ROCm) / [AMDGPU](https://wiki.archlinux.org/title/AMDGPU)

### 2. 添加用户到 GPU 访问组

```bash
sudo usermod -a -G render,video $USER   # 将当前用户加入 render 和 video 组
```
- **render** — 访问 GPU 渲染节点 `/dev/dri/render*`
- **video** — 访问 ROCm 核心设备 `/dev/kfd`

> 修改后需**重新登录**生效（或执行 `newgrp render` 临时切换）。

### 3. 验证 ROCm 安装

```bash
rocminfo | grep gfx          # 确认 GPU 架构（如 gfx1101）
cat /opt/rocm/.info/version  # 显示 ROCm 版本
lsmod | grep amdgpu          # 确认内核模块已加载
```

### 3. 运行 ComfyUI
```bash
docker compose up -d
```

## 🎛️ 模型设置

模型需要手动放置到挂载卷中。详见 [模型设置指南](MODEL_SETUP.md)。

## 🏗️ 构建镜像

参见 [构建指南](BUILD.md)。

## 🐳 Docker Compose

卷挂载已预配置，模型放入 `./data/models/` 对应子目录即可。

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
      # 模型文件
      - ./data/models:/workspace/ComfyUI/models
      # 生成输出
      - ./data/output:/workspace/ComfyUI/output
      # 输入图片
      - ./data/input:/workspace/ComfyUI/input
      # 自定义节点
      - ./data/custom_nodes:/workspace/ComfyUI/custom_nodes
      # 用户配置
      - ./data/user:/workspace/ComfyUI/user
    environment:
      - HIP_VISIBLE_DEVICES=0
      - CUDA_VISIBLE_DEVICES=""
    restart: unless-stopped
```

运行: `docker compose up -d`

## ⚡ 性能与硬件

### 测试硬件
- **AMD Radeon RX 7800 XT**（16GB VRAM）✅

### 性能指标
- **生成时间**: ~30-60s（512x512 图像）
- **VRAM 占用**: 基本操作 4-8GB
- **模型加载**: 首次 ~30-60s，之后缓存
- **批处理**: 支持多图像同时生成

### 提示
- 挂载持久卷可避免重复下载模型
- 从 `default` 模型开始，按需升级
- 使用快速 SSD 以获得最佳性能

## 🔍 故障排除

遇到问题请提交 [GitHub Issues](https://github.com/selcarpa/ComfyUI-ROCm/issues)。

## 🔄 本次更新与上一版本的差异

### 🗑️ 移除
- **`docker/download_models.py`** + **`docker/models.yaml`** — 移除自动模型下载机制。模型改为完全手动放置，详见 [MODEL_SETUP.md](MODEL_SETUP.md)

### 🆕 新增
- **`BUILD.md` / `BUILD_EN.md`** — 独立构建指南（中/英）
- **`MODEL_SETUP.md` / `MODEL_SETUP_EN.md`** — 独立模型设置指南（中/英）
- **`README_EN.md`** — 英文版 README（与中文版分离，便于维护）

### 🔧 修改

| 文件 | 变更内容 |
|------|---------|
| `docker/Dockerfile` | 基础镜像改为可配置 `ARG`；ROCm 6.4.1 → **7.2.4**，PyTorch 2.6.0 → **2.10.0**；移除 `download_models.py`/`models.yaml` 拷贝及 `MODEL_DOWNLOAD` 环境变量；**ComfyUI 改为通过 `ARG COMIFYUI_TAG` 按标签检出**（而非拉取最新代码） |
| `docker-compose.yaml` | 镜像源改为 `selcarpa/comfyui-rocm`；移除 `pull_policy: always` 和 `MODEL_DOWNLOAD`；新增 `hostname` 和 `./data/temp` 卷；补全注释 |
| `build.sh` | 基础镜像改为可配置 `--build-arg`；版本标签自动按日期+时间生成；移除 `--progress=plain`；**新增 `COMIFYUI_TAG` 变量**指定 ComfyUI 版本，镜像详细标签中携带 ComfyUI 标签 |
| `docker/requirements_rocm.txt` | 全面升级版本（frontend 1.23.4→1.44.19, workflow-templates 0.1.30→0.9.91 等）；新增 `comfy-kitchen`、`comfy-aimdo`、`comfyui-manager` 及 `filelock`/`requests`/`simpleeval`/`blake3` 等依赖；按功能分区组织 |
| `docker/startup.sh` | 移除启动前的模型下载步骤，直接启动 ComfyUI |
| `README.md` | 从英文全面改写为中文，内容重构，版本信息更新 |

## 📄 许可与致谢

本项目采用 GPL-3.0 许可。详见 [LICENSE](LICENSE) 文件。

### 第三方组件
- **ComfyUI**: GPL-3.0 — [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **PyTorch**: BSD 3-Clause — [PyTorch](https://pytorch.org/)
- **ROCm**: 各类开源许可 — [AMD ROCm](https://rocm.docs.amd.com/)

**鸣谢:**
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) — 节点式 AI 工作流界面
- [AMD ROCm](https://rocm.docs.amd.com/) — 开源 GPU 计算平台
- ROCm 社区对 AMD GPU AI 的支持

---

🔗 **链接:** [Docker Hub](https://hub.docker.com/r/selcarpa/comfyui-rocm) | [GitHub](https://github.com/selcarpa/comfyui-rocm) | [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
