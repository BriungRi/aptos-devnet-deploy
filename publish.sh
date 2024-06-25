#!/bin/bash

# Fail immediately if any command exits with a non-zero status
set -e

PACKAGE_DIR="${PACKAGE_DIR}"
NAMED_ADDRESSES="${NAMED_ADDRESSES}"
PRIVATE_KEY="${PRIVATE_KEY}"
UPGRADE_ALLOWED="${UPGRADE_ALLOWED}"
DEVNET_URL="https://fullnode.devnet.aptoslabs.com/"
DEVNET_FAUCET_URL="https://faucet.devnet.aptoslabs.com/"
aptos init \
  --private-key=$PRIVATE_KEY \
  --network=devnet \
  --assume-yes
CHECK_ADDRESS=0x$(aptos config show-profiles | jq -r '.Result.default.account')

aptos account fund-with-faucet \
  --account="$CHECK_ADDRESS" \
  --url="$DEVNET_URL" \
  --faucet-url="$DEVNET_FAUCET_URL"
aptos move publish \
  --package-dir="$PACKAGE_DIR" \
  --named-addresses="$NAMED_ADDRESSES" \
  --url="$DEVNET_URL" \
  --assume-yes
