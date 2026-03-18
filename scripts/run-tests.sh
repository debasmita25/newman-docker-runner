#!/bin/sh

echo "Running GitHub API tests on jenkins..."
COLLECTION=$1
ENV_FILE=$2


echo "Making Report directory..." 
mkdir -p /etc/newman/tests/report

newman run $COLLECTION \
-e $ENV_FILE \
--env-var "GITHUB_USERNAME=$API_USERNAME" \
--env-var "GITHUB_TOKEN=$API_PASSWORD" -r html \
--reporter-html-export  /etc/newman/tests/report/report.html