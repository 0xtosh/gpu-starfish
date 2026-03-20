#!/bin/bash

# Exit on error
set -e

echo "------------------------------------------------"
echo "Starting Home GPU Cluster Node Setup..."
echo "------------------------------------------------"

# 1. Update and Install System Dependencies
echo "[1/4] Installing system dependencies..."
sudo apt update
sudo apt install -y build-essential cmake git libvulkan-dev glslc \
nvidia-cuda-toolkit nvidia-driver-535 nvidia-utils-535

# 2. Clone and Build llama.cpp
echo "[2/4] Cloning and building llama.cpp with Vulkan & RPC..."
if [ ! -d "llama.cpp" ]; then
    git clone https://github.com/ggerganov/llama.cpp
fi

cd llama.cpp
mkdir -p build && cd build

# Compile with Vulkan for cross-GPU support and RPC for networking
cmake .. -DGGML_VULKAN=1 -DGGML_RPC=1
cmake --build . --config Release --target rpc-server

# 3. Create the Systemd Service
echo "[3/4] Creating systemd service..."
CURRENT_USER=$(whoami)
INSTALL_DIR=$(pwd)

cat <<EOF | sudo tee /etc/systemd/system/llama-worker.service
[Unit]
Description=Llama.cpp RPC Worker
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$INSTALL_DIR
# Default port is 50052
ExecStart=$INSTALL_DIR/bin/rpc-server --host 0.0.0.0 --port 50052
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 4. Enable and Start the Service
echo "[4/4] Starting worker service..."
sudo systemctl daemon-reload
sudo systemctl enable llama-worker.service
sudo systemctl start llama-worker.service

echo "------------------------------------------------"
echo "SETUP COMPLETE!"
echo "Node IP: $(hostname -I | awk '{print $1}')"
echo "Port: 50052"
echo "Your GPU node is now ready for orchestration."
echo "------------------------------------------------"