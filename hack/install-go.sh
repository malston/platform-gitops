#!/usr/bin/env bash

# Versions
GO_VERSION="1.21.4"

# Arch
if [[ $(uname -m) == "x86_64" ]]; then
  LINUX_ARCH="amd64"
elif [[ $(uname -m) == "aarch64" ]]; then
  LINUX_ARCH="arm64"
fi

# Directory
if ! [[ -d ~/go ]]; then
  mkdir ~/go
fi

# Go
wget -q -O go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz https://golang.org/dl/go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz
tar -C /usr/local -xzf go${GO_VERSION}.linux-${LINUX_ARCH}.tar.gz
PATH=$PATH:/usr/local/go/bin
go version

