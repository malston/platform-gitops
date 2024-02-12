#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

echo -n "Enter the route53 accesskeyID: "
read -r AWS_ACCESS_KEY_ID

echo -n "Enter the route53 secretAccessKey: "
read -r AWS_SECRET_ACCESS_KEY

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
