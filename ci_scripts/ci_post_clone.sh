#!/bin/bash

# ci_post_clone.sh - Generate Secrets.xcconfig from Xcode Cloud env vars

set -e  # Exit on any error

echo "Generating Secrets.xcconfig from environment variables..."

cd "$CI_WORKSPACE" || cd /Volumes/workspace/repository || { echo "Failed to cd to repo root"; exit 1; }

cat > Secrets.xcconfig << EOL
//
//  Secrets.xcconfig
//  Unitrack
//
//  Auto-generated during Xcode Cloud build - DO NOT EDIT
//

REVENUE_CAT_KEY = ${REVENUE_CAT_KEY:-}
GEMINI_API_KEY = ${GEMINI_API_KEY:-}
EOL

echo "Generated Secrets.xcconfig in repo root:"
ls -l Secrets.xcconfig
cat Secrets.xcconfig | sed 's/=.*/= [REDACTED]/'

echo "Current directory after generation: $(pwd)"