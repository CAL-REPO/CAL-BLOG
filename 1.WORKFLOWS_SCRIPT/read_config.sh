#!/bin/bash

# Read the config.cfg file and export its variables
CONFIG_FILE="$1"

if [[ -f "$CONFIG_FILE" ]]; then
    export $(grep -v '^#' "$CONFIG_FILE" | xargs)
else
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi