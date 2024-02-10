#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# if kubectl get secret vault-token -n external-secrets-operator; then
#   kubectl delete secret vault-token -n external-secrets-operator
# fi
# kubectl create secret generic vault-token --from-literal=token="$VAULT_TOKEN" --namespace=external-secrets-operator

vault login "$VAULT_TOKEN" -address="$VAULT_ADDR"

echo -n "Enter the route53 accesskeyID: "
read -r AWS_ACCESS_KEY_ID
echo "$AWS_ACCESS_KEY_ID" | vault kv put -mount=secret route53 accesskeyid=-

echo -n "Enter the route53 secretAccessKey: "
read -r AWS_SECRET_ACCESS_KEY
echo "$AWS_SECRET_ACCESS_KEY" | vault kv put -mount=secret route53 secretaccesskey=-
