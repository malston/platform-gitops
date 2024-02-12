#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

kubectl port-forward svc/vault-internal -n vault 8200 &

export VAULT_ADDR=http://127.0.0.1:8200
vault status
vault operator init -key-shares=1 -key-threshold=1
vault operator unseal
