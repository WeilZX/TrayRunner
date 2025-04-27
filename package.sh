#!/bin/bash

set -euo pipefail

APP_NAME="TrayRunner"
SCHEME="$APP_NAME"
CONFIGURATION="Release"
OUTPUT_DIR="$(pwd)/build"
ZIP_NAME="$APP_NAME.zip"

echo "🧹 Cleaning previous builds..."
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "🏗️ Building $APP_NAME ($CONFIGURATION configuration)..."
xcodebuild clean -scheme "$SCHEME" -configuration "$CONFIGURATION"
xcodebuild -scheme "$SCHEME" -configuration "$CONFIGURATION" -derivedDataPath "$OUTPUT_DIR/DerivedData" build

echo "📦 Locating built app..."
APP_PATH="$OUTPUT_DIR/DerivedData/Build/Products/$CONFIGURATION/$APP_NAME.app"

if [ ! -d "$APP_PATH" ]; then
    echo "❌ ERROR: App not found at expected path: $APP_PATH"
    exit 1
fi

echo "🗂️ Copying app to output folder..."
cp -R "$APP_PATH" "$OUTPUT_DIR/$APP_NAME.app"

echo "🗜️ Zipping $APP_NAME.app..."
cd "$OUTPUT_DIR"
zip -r "$ZIP_NAME" "$APP_NAME.app"

echo "🚀 Moving $ZIP_NAME to project root..."
mv "$ZIP_NAME" "$(dirname "$OUTPUT_DIR")/"

echo "🧹 Cleaning temporary build artifacts..."
cd "$(dirname "$OUTPUT_DIR")"
rm -rf "$OUTPUT_DIR"

echo "✅ Done!"
echo "Output: $(pwd)/$ZIP_NAME"