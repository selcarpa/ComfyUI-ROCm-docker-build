#!/bin/bash
# ComfyUI Startup Script

set -e

log() {
    echo "[ComfyUI] $1"
}

MANAGER_SRC="/workspace/.default_nodes/comfyui-manager"
MANAGER_DST="/workspace/ComfyUI/custom_nodes/comfyui-manager"
if [ "${COMFYUI_MANAGER_DISABLED}" != "true" ] && [ ! -d "$MANAGER_DST" ]; then
    log "Restoring ComfyUI-Manager from image backup..."
    cp -r "$MANAGER_SRC" "$MANAGER_DST"
    log "ComfyUI-Manager restored."
fi

MANAGER_FLAG=""
if [ "${COMFYUI_MANAGER_DISABLED}" != "true" ] && [ -d "$MANAGER_DST" ]; then
    MANAGER_FLAG="--enable-manager"
fi

# Start ComfyUI
log "Starting ComfyUI on port 8188..."
exec python main.py --listen 0.0.0.0 --port 8188 $MANAGER_FLAG "$@"