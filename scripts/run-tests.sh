#!/bin/sh
set -e  # Fail fast

COLLECTION=$1
ENV_FILE=$2

echo "Running collection: $COLLECTION"
echo "Using environment: $ENV_FILE"

# Validate inputs
if [ ! -f "$COLLECTION" ]; then
  echo "ERROR: Collection not found!"
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: Environment file not found!"
  exit 1
fi

# Create report directory
mkdir -p /etc/newman/report

# Run tests
newman run "$COLLECTION" \
  -e "$ENV_FILE" \
  --env-var "GITHUB_USERNAME=$GITHUB_USERNAME" \
  --env-var "GITHUB_PASSWORD=$GITHUB_PASSWORD" \
  -r  cli,html \
  --reporter-html-export /etc/newman/report/report.html

echo "Test execution completed."