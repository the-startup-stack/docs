#!/bin/bash

set -e

source secrets.sh
# secrets.sh is intentionally excluded from the source code. It includes secret API keys and service ids
bundle exec jekyll build
cd _site && aws s3 sync . $S3_BUCKET --cache-control="public,max-age=3600"
curl -X POST -H "Fastly-Key: $FASTLY_KEY" https://api.fastly.com/service/$FASTLY_SERVICE_ID/purge_all