# Model Setup Guide

[中文](MODEL_SETUP.md)

This container does **not** include or auto-download models. You need to place model files manually.

## Quick Start

`docker-compose.yaml` already defines the volume mounts. Models go into `./data/models/` on the host:

```bash
# 1. Create local model directory (skip if exists)
mkdir -p ./data/models/checkpoints

# 2. Download a model into the correct subdirectory (example: SD 1.5)
wget -O ./data/models/checkpoints/v1-5-pruned-emaonly.safetensors \
  https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors

# 3. Start the container
docker compose up -d
```

## Common Model Sources

| Model | Source |
|---|---|
| Stable Diffusion 1.5 | [runwayml/stable-diffusion-v1-5](https://huggingface.co/runwayml/stable-diffusion-v1-5) |
| SDXL Base 1.0 | [stabilityai/stable-diffusion-xl-base-1.0](https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0) |
| SDXL Refiner 1.0 | [stabilityai/stable-diffusion-xl-refiner-1.0](https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0) |
| Realistic Vision V5.1 | [SG161222/Realistic_Vision_V5.1_noVAE](https://huggingface.co/SG161222/Realistic_Vision_V5.1_noVAE) |
| DreamShaper 8 | [Lykon/DreamShaper](https://huggingface.co/Lykon/DreamShaper) |
| Juggernaut XL | [RunDiffusion/Juggernaut-XL-v9](https://huggingface.co/RunDiffusion/Juggernaut-XL-v9) |

## Directory Structure

Place model files into the correct subdirectory:

```
data/models/
├── checkpoints/       # Main model files (.safetensors, .ckpt)
├── vae/               # VAE models
├── loras/             # LoRA adapters
├── embeddings/        # Textual inversion embeddings
├── upscale_models/    # Upscalers (ESRGAN, etc.)
├── controlnet/        # ControlNet models
└── ipadapter/         # IP-Adapter models
```
