#!/bin/bash

UPGRADE_ALLOWED="${UPGRADE_ALLOWED}"
CHECK_ADDRESS="${CHECK_ADDRESS}"
DEVNET_URL="https://fullnode.devnet.aptoslabs.com/"

http_code=$(
  curl --write-out '%{http_code}' \
       --silent \
       --output /dev/null \
       ${DEVNET_URL}v1/accounts/$CHECK_ADDRESS/resource/0x1::code::PackageRegistry
)

if [ $http_code -eq 404 ] || [ "$UPGRADE_ALLOWED" = "true" ]; then
  exit 0
elif [ $http_code -eq 200 ]; then
  echo "Package is already published at $CHECK_ADDRESS"
  exit 1
else
  echo "An unexpected error occurred. HTTP status code: $http_code"
  exit 1
fi
