#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if [[ -z $AWS_ACCESS_KEY_ID ]]; then
  echo -n "Enter the route53 accesskeyID: "
  read -r AWS_ACCESS_KEY_ID
fi

if [[ -z $AWS_SECRET_ACCESS_KEY ]]; then
  echo -n "Enter the route53 secretAccessKey: "
  read -rs AWS_SECRET_ACCESS_KEY
fi

cat <<EOF | kubectl -n cert-manager apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: route53-secret
  namespace: cert-manager
type: Opaque
stringData:
  accesskeyid: $AWS_ACCESS_KEY_ID 
  secretaccesskey: $AWS_SECRET_ACCESS_KEY 
EOF

echo -n "$VAULT_TOKEN" | vault login -

vault kv put -mount=secret route53 "accesskeyid=$AWS_ACCESS_KEY_ID" "secretaccesskey=$AWS_SECRET_ACCESS_KEY"
vault kv get -mount=secret -format=json route53
