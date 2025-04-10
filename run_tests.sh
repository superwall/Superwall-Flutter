#!/bin/bash

# Exit on error
set -e

# Function to display usage
usage() {
    echo "Usage: $0 [ios|android]"
    echo "  ios     - Run tests for iOS platform"
    echo "  android - Run tests for Android platform"
    exit 1
}

# Check if platform argument is provided
if [ $# -ne 1 ]; then
    usage
fi

PLATFORM=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Validate platform argument
if [ "$PLATFORM" != "ios" ] && [ "$PLATFORM" != "android" ]; then
    echo "Error: Invalid platform. Must be 'ios' or 'android'"
    usage
fi

# Set platform-specific variables
if [ "$PLATFORM" = "ios" ]; then
    APP_ID="com.superwall.Advanced"
else
    APP_ID="com.superwall.superapp"
fi

echo "Building Flutter app for $PLATFORM..."
flutter build $PLATFORM

echo "Running Maestro tests for $PLATFORM..."

# Run the tests
maestro test -e "PLATFORM_ID=$APP_ID" test_app/maestro/purchasecontroller/test_pc_purchases.yaml
maestro test -e "PLATFORM_ID=$APP_ID" test_app/maestro/purchasecontroller/no_pc_purchases.yaml
maestro test -e "PLATFORM_ID=$APP_ID" test_app/maestro/handler/flow.yaml
maestro test -e "PLATFORM_ID=$APP_ID" test_app/maestro/flow.yaml
maestro test -e "PLATFORM_ID=$APP_ID" test_app/maestro/delegate/flow.yaml

echo "All tests completed successfully!" 