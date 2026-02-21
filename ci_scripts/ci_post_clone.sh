#!/bin/bash

# ci_post_clone.sh - Generate Secrets.xcconfig from Xcode Cloud env vars

set -e  # Exit on error

echo "Generating Secrets.xcconfig from environment variables..."

REPO_ROOT="/Volumes/workspace/repository"

cat > "$REPO_ROOT/Secrets.xcconfig" << EOL
//
//  Secrets.xcconfig
//  Unitrack
//
//  Auto-generated during Xcode Cloud build - DO NOT EDIT
//

REVENUE_CAT_KEY = ${REVENUE_CAT_KEY:-}
GEMINI_API_KEY = ${GEMINI_API_KEY:-}
EOL

if [ -f "$REPO_ROOT/Secrets.xcconfig" ]; then
    echo "Secrets.xcconfig successfully created in repo root:"
    ls -l "$REPO_ROOT/Secrets.xcconfig"
    cat "$REPO_ROOT/Secrets.xcconfig" | sed 's/=.*/= [REDACTED]/'  # Safe log
    echo "Current directory (should still be ci_scripts): $(pwd)"
else
    echo "Failed to create Secrets.xcconfig in $REPO_ROOT"
    exit 1
fi