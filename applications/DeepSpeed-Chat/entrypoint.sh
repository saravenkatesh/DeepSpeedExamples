#!/bin/bash

# Copy SSH keys from mounted directory if present and not already set up
if [ -d /tmp/host_ssh ]; then
    echo "Copying SSH keys from /tmp/host_ssh to /root/.ssh..."
    mkdir -p /root/.ssh
    cp -r /tmp/host_ssh/* /root/.ssh/
    chown -R root:root /root/.ssh
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/id_rsa /root/.ssh/authorized_keys
fi

# Start SSHD
/usr/sbin/sshd

# Prevent container from exiting
tail -f /dev/null

