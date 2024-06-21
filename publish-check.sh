#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

PACKAGE_DIR="${PACKAGE_DIR}"
NAMED_ADDRESSES="${NAMED_ADDRESSES}"
PRIVATE_KEY="${PRIVATE_KEY}"
UPGRADE_ALLOWED="${UPGRADE_ALLOWED}"
echo "UPGRADE_ALLOWED: $UPGRADE_ALLOWED"
DEVNET_URL="https://fullnode.devnet.aptoslabs.com/"
DEVNET_FAUCET_URL="https://faucet.devnet.aptoslabs.com/"
aptos init \
  --private-key=$PRIVATE_KEY \
  --network=devnet \
  --assume-yes
CHECK_ADDRESS=0x$(aptos config show-profiles | jq -r '.Result.default.account')

http_code=$(
  curl --write-out '%{http_code}' \
       --silent \
       --output /dev/null \
       https://fullnode.devnet.aptoslabs.com/v1/accounts/$CHECK_ADDRESS/resource/0x1::code::PackageRegistry
)

if [ $http_code -eq 404 ] || [ "$UPGRADE_ALLOWED" = "true" ]; then
  echo "Package is not published. Running publish command."
  aptos account fund-with-faucet \
    --account="$CHECK_ADDRESS" \
    --url="$DEVNET_URL" \
    --faucet-url="$DEVNET_FAUCET_URL"
  aptos move publish \
    --package-dir="$PACKAGE_DIR" \
    --named-addresses="$NAMED_ADDRESSES" \
    --url="$DEVNET_URL" \
    --assume-yes
elif [ $http_code -eq 200 ]; then
  echo "Package is already published at $CHECK_ADDRESS"
else
  echo "An unexpected error occurred. HTTP status code: $http_code"
fi
