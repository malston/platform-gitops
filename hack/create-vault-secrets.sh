#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if kubectl get secret vault-token -n external-secrets-operator; then
  kubectl delete secret vault-token -n external-secrets-operator
fi
kubectl create secret generic vault-token --from-literal=token="$VAULT_TOKEN" --namespace=cert-manager

echo -n "$VAULT_TOKEN" | vault login -

if [[ -z $AWS_ACCESS_KEY_ID ]]; then
  echo -n "Enter the route53 accesskeyID: "
  read -r AWS_ACCESS_KEY_ID
fi

if [[ -z $AWS_SECRET_ACCESS_KEY ]]; then
  echo -n "Enter the route53 secretAccessKey: "
  read -rs AWS_SECRET_ACCESS_KEY
fi

vault kv put -mount=secret route53 "accesskeyid=$AWS_ACCESS_KEY_ID" "secretaccesskey=$AWS_SECRET_ACCESS_KEY"
vault kv get -mount=secret -format=json route53
