#!/bin/bash

# Check if script is run as root (needed for /etc/hosts modification)
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root to modify /etc/hosts" >&2
    exit 1
fi

# Update /etc/hosts file
echo "Updating /etc/hosts file..."
entries=(
    "127.0.0.1        local.react"
    "127.0.0.1        local.kotlin"
)

for entry in "${entries[@]}"; do
    if ! grep -q "$entry" /etc/hosts; then
        echo "$entry" >> /etc/hosts
        echo "Added: $entry"
    else
        echo "Entry already exists: $entry"
    fi
done

echo -e "\nHosts file update complete.\n"

# Clone repositories
echo "Cloning repositories..."
repos=(
    "https://github.com/zivojindavidovic/PlaygroundMath-app"
    "https://github.com/zivojindavidovic/PlaygroundMath-react"
)

for repo in "${repos}"; do
    repo_name=$(basename "$repo")
    if [ ! -d "$repo_name" ]; then
        echo "Cloning $repo_name..."
        git clone "$repo"
        if [ $? -eq 0 ]; then
            echo "Successfully cloned $repo_name"
        else
            echo "Failed to clone $repo_name" >&2
        fi
    else
        echo "$repo_name already exists, skipping..."
    fi
done

echo -e "\nRepository cloning complete."