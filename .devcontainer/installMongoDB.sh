#!/bin/bash

set -euo pipefail

# Install MongoDB for Debian-based devcontainers.
# MongoDB does not currently publish a dedicated Debian 13 (trixie) repo,
# so we use the Debian 12 (bookworm) repository as a compatible fallback.

KEYRING_PATH="/usr/share/keyrings/mongodb-server-8.0.gpg"
LIST_PATH="/etc/apt/sources.list.d/mongodb-org-8.0.list"
REPO_CODENAME="bookworm"

source /etc/os-release

if [[ "${ID:-}" != "debian" ]]; then
	echo "This installer supports Debian devcontainers only. Detected: ${ID:-unknown}"
	exit 1
fi

if [[ "${VERSION_CODENAME:-}" != "bookworm" && "${VERSION_CODENAME:-}" != "trixie" ]]; then
	echo "Unsupported Debian codename: ${VERSION_CODENAME:-unknown}"
	echo "Expected bookworm or trixie."
	exit 1
fi

sudo install -d -m 0755 /usr/share/keyrings
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor -o "${KEYRING_PATH}"

# Remove legacy/incorrect MongoDB sources to avoid apt signature or distro conflicts.
sudo rm -f /etc/apt/sources.list.d/mongodb-org-7.0.list

echo "deb [arch=amd64,arm64 signed-by=${KEYRING_PATH}] https://repo.mongodb.org/apt/debian ${REPO_CODENAME}/mongodb-org/8.0 main" | sudo tee "${LIST_PATH}" >/dev/null

sudo apt-get update
sudo apt-get install -y mongodb-org

# Create necessary directories and set permissions
sudo mkdir -p /data/db
sudo mkdir -p /var/log/mongodb
if id -u mongodb >/dev/null 2>&1; then
	sudo chown -R mongodb:mongodb /data/db /var/log/mongodb
fi
