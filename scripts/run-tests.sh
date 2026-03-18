#!/bin/sh

echo "Running GitHub API tests..."
COLLECTION=$1
ENV_FILE=$2

newman run $COLLECTION \
-e $ENV_FILE \
--env-var GITHUB_USERNAME=$API_USERNAME \
--env-var GITHUB_TOKEN=$API_PASSWORD -r html \
--reporter-html-export  /etc/newman/report/report.html