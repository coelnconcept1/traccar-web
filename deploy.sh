#!/bin/bash

# ================================
# CONFIG
# ================================
SERVER="root@traccar.cc-entwicklung.de"
TARGET_DIR="/opt/traccar/web"
BUILD_DIR="build" 

# ================================
# BUILD
# ================================
echo "🔨 Building project..."
npm run build

if [ $? -ne 0 ]; then
  echo "❌ Build failed"
  exit 1
fi

echo "✅ Build successful"

# ================================
# OPTIONAL BACKUP
# ================================
echo "📦 Creating backup on server..."
ssh $SERVER "if [ -d $TARGET_DIR ]; then mv $TARGET_DIR .${TARGET_DIR}_backup_\$(date +%Y%m%d_%H%M%S); fi"

# ================================
# UPLOAD
# ================================
echo "🚀 Uploading build to server..."
scp -r $BUILD_DIR $SERVER:$TARGET_DIR

if [ $? -ne 0 ]; then
  echo "❌ Upload failed"
  exit 1
fi

echo "✅ Upload successful"

# ================================
# DONE
# ================================
echo "🎉 Deployment finished!"