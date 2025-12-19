#!/bin/bash

TARGET_HOST="target"

NODE_VERSION="24.x"

ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@${TARGET_IP} "echo hello"

# Sync node packages.
scp -o StrictHostKeyChecking=no -i ${FILENAME} index.js \${USERNAME}@target:~/index.js
scp -o StrictHostKeyChecking=no -i ${FILENAME} package.json \${USERNAME}@target:~/package.json
scp -o StrictHostKeyChecking=no -i ${FILENAME} package-lock.json \${USERNAME}@target:~/package-lock.json

# Install nodejs and dependencies.
ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@${TARGET_HOST} "
  sudo apt update && sudo apt upgrade -y
  if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | sudo -E bash -
    sudo apt install -y nodejs
  fi
  if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
  fi
  npm install -g npm@latest  # Add this line to upgrade npm
  npm ci --omit=dev
"

# Run
ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@${TARGET_HOST} "
  cd ~
  pm2 delete myapp || true  # Ignore if not running
  pm2 start index.js --name myapp
  pm2 save
  pm2 startup | sudo bash
"
