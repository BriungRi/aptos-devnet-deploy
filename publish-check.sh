#!/bin/bash

ACTION_PATH="${ACTION_PATH}"
PACKAGE_DIR="${PACKAGE_DIR}"
CHECK_ADDRESS="${CHECK_ADDRESS}"
NAMED_ADDRESSES="${NAMED_ADDRESSES}"
PRIVATE_KEY="${PRIVATE_KEY}"
UPGRADE_ALLOWED="${UPGRADE_ALLOWED}"
DEVNET_URL="https://fullnode.devnet.aptoslabs.com/"
DEVNET_FAUCET_URL="https://faucet.devnet.aptoslabs.com/"

http_code=$(
  curl --write-out '%{http_code}' \
       --silent \
       --output /dev/null \
       ${DEVNET_URL}v1/accounts/$CHECK_ADDRESS/resource/0x1::code::PackageRegistry
)

if [ $http_code -eq 404 ] || [ "$UPGRADE_ALLOWED" = "true" ]; then
  aptos init \
    --private-key=$PRIVATE_KEY \
    --network=devnet \
    --assume-yes
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
