#!/bin/bash

TARGET_IP="target"

ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@${TARGET_IP} "echo hello"
