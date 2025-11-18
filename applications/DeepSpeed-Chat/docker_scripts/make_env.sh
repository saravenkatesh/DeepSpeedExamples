#!/bin/bash

read -p "You are about to reconfigure the Docker daemon. Doing so may affect other running Docker containers. Do you want to continue? (y/n): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Operation cancelled by user."
    exit 1
fi

# Move docker daemon's data-dir to a new spacious mount
mkdir /docker
mount -t tmpfs -o size=500G tmpfs /docker
echo '{"data-root": "/docker-data"}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker

# Set vm.max_map_count as specified in 
# https://lambdalabs.atlassian.net/wiki/spaces/HPC/pages/582844431/DeepSpeed+Cluster+ML+Test+Guide#Adjust-file-and-memory-limits-if-necessary-(%3E32-nodes)
sudo sysctl -w vm.max_map_count=1500000

