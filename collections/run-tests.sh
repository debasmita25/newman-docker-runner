#!/bin/sh

echo "Running GitHub API tests..."


newman run Collection_GitHub.postman_collection.json \
-e github-env.json \
--env-var GITHUB_USERNAME=$GITHUB_USERNAME \
--env-var GITHUB_TOKEN=$GITHUB_TOKEN -r cli,html \
--reporter-html-export reports/report.html