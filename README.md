# Aptos Devnet Autodeploy

This action lets you provide a publish command and an address to check on devnet.

Use this action to keep your package deployed on devnet.

Example:

```yaml
name: Publish Check

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master
  schedule:
    - cron: '* * * * *' # Every minute

jobs:
  devnet-autodeploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Check and Publish
        uses: BriungRi/aptos-devnet-deploy@master # Can use a pinned commit hash
        with:
          package_dir: example/aptos-devnet-autodeploy
          named_addresses: module_addr=0x3cb93ebcabdb73a76c23df00c3176a14efe64b948ca4b319f88561068e77df2d
          private_key: ${{ secrets.PRIVATE_KEY }}
          upgrade_allowed: true

```
