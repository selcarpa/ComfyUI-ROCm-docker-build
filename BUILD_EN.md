# Build Guide

[中文](BUILD.md)

## Default Version Info

Default versions configured in `build.sh`:

| Component | Version |
|-----------|---------|
| **ComfyUI** | v0.22.0 |
| **Base Image** | `rocm/pytorch:rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.10.0` |

Edit `COMIFYUI_TAG` and `BASE_IMAGE_TAG` in `build.sh` to change versions.

## Build Image

```bash
./build.sh
```

Or with a version tag:

```bash
./build.sh v1.0.0
```

The script tags the image as both `selcarpa/comfyui-rocm:latest` and `selcarpa/comfyui-rocm:<detailed-version>` (includes date, ComfyUI tag and base image tag).

The following variables can be configured in `build.sh`:
- `COMIFYUI_TAG` — ComfyUI Git tag to checkout
- `BASE_IMAGE_TAG` — ROCm PyTorch base image version

## Using docker build directly

```bash
docker build \
  -f docker/Dockerfile \
  --build-arg COMIFYUI_TAG=v0.22.0 \
  --build-arg BASE_IMAGE_TAG=rocm7.2.4_ubuntu24.04_py3.12_pytorch_release_2.10.0 \
  -t selcarpa/comfyui-rocm:latest .
```

Build arguments:
- `COMIFYUI_TAG` — ComfyUI Git tag (e.g. `v0.22.0`), checked out at build time
- `BASE_IMAGE_TAG` — Version tag for the base image `rocm/pytorch`. Available tags can be found on [Docker Hub](https://hub.docker.com/r/rocm/pytorch/tags).
