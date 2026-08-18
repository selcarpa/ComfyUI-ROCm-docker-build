#!/bin/bash
# generate_requirements.sh - Generate requirements file for this build
# Usage: ./scripts/generate_requirements.sh <comfyui_tag> [output_file]
# E.g.: ./scripts/generate_requirements.sh v0.22.0 /tmp/requirements_rocm.txt

set -e

COMFYUI_TAG="${1:-}"
OUTPUT_FILE="${2:-/tmp/requirements_rocm.txt}"

if [ -z "$COMFYUI_TAG" ]; then
  echo "Error: ComfyUI tag is required"
  echo "Usage: $0 <comfyui_tag> [output_file]"
  exit 1
fi

COMFYUI_REPO="Comfy-Org/ComfyUI"
REQUIREMENTS_URL="https://raw.githubusercontent.com/${COMFYUI_REPO}/${COMFYUI_TAG}/requirements.txt"

echo "Fetching requirements from ${COMFYUI_REPO} tag: ${COMFYUI_TAG}"

curl -sSL "${REQUIREMENTS_URL}" -o /tmp/comfyui_official_requirements.txt

if [ ! -s /tmp/comfyui_official_requirements.txt ]; then
  echo "Error: Failed to fetch requirements.txt"
  exit 1
fi

python3 << PYTHON_SCRIPT
import re

with open('/tmp/comfyui_official_requirements.txt', 'r') as f:
    comfyui_reqs = f.read()

with open('docker/requirements_rocm.txt', 'r') as f:
    rocm_reqs = f.read()

comfyui_packages = {}
for line in comfyui_reqs.split('\n'):
    line = line.strip()
    if not line or line.startswith('#'):
        continue
    match = re.match(r'^([a-zA-Z0-9_-]+)([=<>!]+)(.+)$', line)
    if match:
        pkg_name = match.group(1)
        if pkg_name.startswith('comfyui') and pkg_name != 'comfyui-manager':
            comfyui_packages[pkg_name] = line

updated_lines = []
for line in rocm_reqs.split('\n'):
    original_line = line
    stripped = line.strip()

    if not stripped or stripped.startswith('#'):
        updated_lines.append(original_line)
        continue

    match = re.match(r'^([a-zA-Z0-9_-]+)==([^#\s]+)(.*)$', stripped)
    if match:
        pkg_name = match.group(1)
        if pkg_name.startswith('comfyui') and pkg_name != 'comfyui-manager':
            if pkg_name in comfyui_packages:
                indent = line[:len(line) - len(stripped)]
                updated_lines.append(indent + comfyui_packages[pkg_name])
            else:
                updated_lines.append(original_line)
        else:
            updated_lines.append(original_line)
    else:
        updated_lines.append(original_line)

with open('${OUTPUT_FILE}', 'w') as f:
    f.write('\n'.join(updated_lines) + '\n')

print("Generated ${OUTPUT_FILE}")
print("Changes:")
for pkg, line in comfyui_packages.items():
    print(f"  {line}")
PYTHON_SCRIPT
