#!/bin/bash

# Exit on any error
set -e

ZOLA_VERSION="0.22.1"
ZOLA_TAR="zola-v${ZOLA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
ZOLA_URL="https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/${ZOLA_TAR}"

echo "Downloading Zola v${ZOLA_VERSION}..."
curl -L $ZOLA_URL -o zola.tar.gz

echo "Extracting Zola..."
tar -xzf zola.tar.gz

echo "Making Zola executable..."
chmod +x zola

echo "Building site with Zola v${ZOLA_VERSION}..."
./zola build
