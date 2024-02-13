#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if kubectl get secret vault-token -n vault; then
  kubectl delete secret vault-token -n vault
fi
kubectl create secret generic vault-token --from-literal=token="$VAULT_TOKEN" --namespace=vault
