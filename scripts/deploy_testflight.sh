#!/bin/bash

# AssetWorks Mobile - TestFlight Deployment Script
# This script builds and uploads the iOS app to TestFlight

set -e

echo "🚀 AssetWorks Mobile - TestFlight Deployment"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Step 1: Clean the project
print_status "Cleaning Flutter project..."
flutter clean

# Step 2: Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Step 3: Pod install
print_status "Installing iOS pods..."
cd ios
pod install
cd ..

# Step 4: Build the iOS app
print_status "Building iOS app for release..."
flutter build ios --release

# Step 5: Archive the app
print_status "Creating Xcode archive..."
cd ios
xcodebuild -workspace Runner.xcworkspace \
    -scheme Runner \
    -configuration Release \
    -archivePath ../build/Runner.xcarchive \
    archive

# Step 6: Export the archive
print_status "Exporting archive for App Store..."
xcodebuild -exportArchive \
    -archivePath ../build/Runner.xcarchive \
    -exportPath ../build/ios-release \
    -exportOptionsPlist ExportOptions.plist

cd ..

# Step 7: Upload to TestFlight
print_status "Uploading to TestFlight..."
xcrun altool --upload-app \
    --type ios \
    --file build/ios-release/Runner.ipa \
    --username "$APPLE_ID" \
    --password "$APP_SPECIFIC_PASSWORD"

print_status "🎉 Successfully uploaded to TestFlight!"
print_status "The app will be available in TestFlight after processing (usually 5-10 minutes)"

echo ""
echo "Next steps:"
echo "1. Open App Store Connect (https://appstoreconnect.apple.com)"
echo "2. Go to TestFlight section"
echo "3. Add test information if needed"
echo "4. Submit for external testing if desired"