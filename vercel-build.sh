#!/bin/bash
set -e

echo "Downloading Zola 0.22.1 (musl static binary)..."
curl -L -s https://github.com/getzola/zola/releases/download/v0.22.1/zola-v0.22.1-x86_64-unknown-linux-musl.tar.gz | tar xz

echo "Verifying Zola version..."
if [ ! -f "./zola" ]; then
    echo "Error: Zola binary was not downloaded or extracted successfully."
    exit 1
fi

ZOLA_VERSION=$(./zola --version)
echo "Found: $ZOLA_VERSION"

if [[ "$ZOLA_VERSION" != *"zola 0.22.1"* ]]; then
  echo "Error: Downloaded Zola binary is not version 0.22.1"
  exit 1
fi

echo "Building site with Zola..."
./zola build

echo "Verifying build output..."
if [ ! -d "public" ]; then
  echo "Error: public/ directory does not exist."
  exit 1
fi

FILES_TO_CHECK=(
  "public/index.html"
  "public/assets"
  "public/blog"
  "public/blog/rss.xml"
  "public/sitemap.xml"
  "public/search_index.en.js"
)

for file in "${FILES_TO_CHECK[@]}"; do
  if [ ! -e "$file" ]; then
    echo "Error: Required file or directory '$file' is missing."
    exit 1
  fi
done

echo "Build verification passed. Ready for deployment."
