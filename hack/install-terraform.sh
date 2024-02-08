#!/usr/bin/env bash

# Versions
TERRAFORM_VERSION="1.7.3"

# Arch
if [[ $(uname -m) == "x86_64" ]]; then
  LINUX_ARCH="amd64"
elif [[ $(uname -m) == "aarch64" ]]; then
  LINUX_ARCH="arm64"
fi

# HashiCorp
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${LINUX_ARCH}.zip
unzip -o -d /usr/local/bin/ terraform_${TERRAFORM_VERSION}_linux_${LINUX_ARCH}.zip
rm ./*.zip

