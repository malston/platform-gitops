#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

echo -n "$VAULT_TOKEN" | vault login -

mc alias set kubelab https://minio.kubelab.app "$(vault kv get -mount=secret -format=json ci-secrets | jq -r .data.data.accesskey)" "$(vault kv get -mount=secret -format=json ci-secrets | jq -r .data.data.secretkey)"
mc admin info kubelab
mc ls kubelab --recursive
mkdir "$__DIR/../minio"
mc cp kubelab --recursive "$__DIR/../minio"
