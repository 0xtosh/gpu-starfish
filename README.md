# 🚀 Home GPU Cluster: Live-Bootable Node Tutorial

Turn your idle home PCs, laptops, headless machines, NUCs etc into a powerful, unified GPU cluster without wiping their hard drives. This setup uses a Live Linux USB (via Ventoy) with a persistent partition, allowing you to plug in, boot, and immediately contribute VRAM to a central orchestrator.

## Purpose

When your gaming rig, work laptop, or Intel NUC isn't in use, boot it from this "Cluster USB." It automatically starts a llama.cpp RPC (Remote Procedure Call) worker, making its GPU available over the network to a central machine (Windows/Mac/Linux) that pools all available VRAM to run massive LLMs.

### Supported Hardware (Tested)

| **Device** | **GPU** | **VRAM** | **Driver Note** | 
| ----- | ----- | ----- | ----- | 
| Gaming Desktop | **NVIDIA RTX 2080Ti** | 11GB | CUDA 12+ / Driver 535+ | 
| Old Laptop | **NVIDIA GTX 980M** | 4GB | Legacy Support | 
| Modern Rig | **Asus RTX 5060** | 8GB | CUDA 12+ | 
| Intel NUC | **AMD Radeon RX Vega M** | 4GB | Vulkan / Mesa | 

## Step 1: Prepare the "Cluster USB"

To ensure your drivers and builds stay on the USB across reboots, we use Ventoy with Persistence.

1. Install Ventoy: Download [Ventoy](https://www.ventoy.net/) and install it on a fast USB 3.0+ drive.

2. Create Persistence Image: Use the [VentoyPlugson](https://www.ventoy.net/en/plugin_persistence.html) tool to create a persistence file (e.g., persistence.dat). 10GB+ is recommended for drivers and models.

3. Add OS: Copy an Ubuntu 22.04 or 24.04 ISO to the USB.

4. Boot: Plug the USB into a node, boot from it, and ensure you select the "with persistence" option in the Ventoy menu.

## Step 2: One-Script Setup

Once booted into your Live environment, open a terminal and run the following command to install drivers, dependencies, and compile the worker:

```bash
# Replace with your actual repo link after you upload setup.sh
curl -sSL [https://raw.githubusercontent.com/0xtosh/gpu-starfish/main/setup.sh](https://raw.githubusercontent.com/0xtosh/gpu-starfish/main/setup.sh) | bash
