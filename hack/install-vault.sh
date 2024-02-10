#!/usr/bin/env bash

# Versions
VAULT_VERSION="1.15.5"

# Arch
if [[ $(uname -m) == "x86_64" ]]; then
  LINUX_ARCH="386"
elif [[ $(uname -m) == "aarch64" ]]; then
  LINUX_ARCH="arm64"
fi

# HashiCorp
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${LINUX_ARCH}.zip
unzip -o -d /usr/local/bin/ vault_${VAULT_VERSION}_linux_${LINUX_ARCH}.zip
rm ./*.zip

