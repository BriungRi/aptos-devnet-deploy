#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

PUBLISH_COMMAND="${PUBLISH_COMMAND}"
CHECK_ADDRESS="${CHECK_ADDRESS}"

echo "PUBLISH_COMMAND: $PUBLISH_COMMAND"
echo "CHECK_ADDRESS: $CHECK_ADDRESS"

http_code=$(
  curl --write-out '%{http_code}' \
       --silent \
       --output /dev/null \
       https://fullnode.devnet.aptoslabs.com/v1/accounts/$CHECK_ADDRESS/resource/0x1::code::PackageRegistry
)

if [ $http_code -eq 200 ]; then
  echo "Package is already published at $CHECK_ADDRESS"
elif [ $http_code -eq 404 ]; then
  echo "Package is not published. Running publish command."
  aptos account fund-with-faucet \
    --account="$CHECK_ADDRESS" \
    --url="https://fullnode.devnet.aptoslabs.com/" \
    --faucet-url="https://faucet.devnet.aptoslabs.com"
  eval "$PUBLISH_COMMAND"
else
  echo "An unexpected error occurred. HTTP status code: $http_code"
fi
