#!/bin/bash

# Build script for Vercel deployment
# Clean Flutter web build without character issues

set -e  # Exit on error

echo "🔨 Building Tall Us for web deployment..."

# Install dependencies
flutter pub get

# Build web app
flutter build web --release

echo "✅ Build complete!"
echo "📂 Output directory: build/web"
