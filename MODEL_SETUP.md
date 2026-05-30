# 模型设置指南

[English](MODEL_SETUP_EN.md)

本容器**不包含**也不会自动下载模型。您需要手动将模型文件放入对应目录。

## 快速开始

`docker-compose.yaml` 已定义好卷挂载，模型目录对应宿主机的 `./data/models/`：

```bash
# 1. 创建本地模型目录（如已存在则跳过）
mkdir -p ./data/models/checkpoints

# 2. 下载模型到对应子目录（示例：SD 1.5）
wget -O ./data/models/checkpoints/v1-5-pruned-emaonly.safetensors \
  https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors

# 3. 启动容器
docker compose up -d
```

## 常见模型来源

| 模型 | 来源 |
|---|---|
| Stable Diffusion 1.5 | [runwayml/stable-diffusion-v1-5](https://huggingface.co/runwayml/stable-diffusion-v1-5) |
| SDXL Base 1.0 | [stabilityai/stable-diffusion-xl-base-1.0](https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0) |
| SDXL Refiner 1.0 | [stabilityai/stable-diffusion-xl-refiner-1.0](https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0) |
| Realistic Vision V5.1 | [SG161222/Realistic_Vision_V5.1_noVAE](https://huggingface.co/SG161222/Realistic_Vision_V5.1_noVAE) |
| DreamShaper 8 | [Lykon/DreamShaper](https://huggingface.co/Lykon/DreamShaper) |
| Juggernaut XL | [RunDiffusion/Juggernaut-XL-v9](https://huggingface.co/RunDiffusion/Juggernaut-XL-v9) |

## 目录结构

模型文件需按类型放入对应子目录：

```
data/models/
├── checkpoints/       # 主模型文件 (.safetensors, .ckpt)
├── vae/               # VAE 模型
├── loras/             # LoRA 适配器
├── embeddings/        # Textual inversion 嵌入
├── upscale_models/    # 放大模型（ESRGAN 等）
├── controlnet/        # ControlNet 模型
└── ipadapter/         # IP-Adapter 模型
```
