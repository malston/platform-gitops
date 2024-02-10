#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# argocd app list -o json | jq -r '.[].metadata.name' | grep -vE 'autopilot|argo-cd|root' | while read -r i; do argocd app set "$i" --sync-policy none; done
argocd app list -o json | jq -r '.[].metadata.name' | grep -vE 'autopilot|argo-cd|root' | while read -r i; do kubectl patch app "$i"  -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge; done
argocd app list -o json | jq -r '.[].metadata.name' | grep -vE 'autopilot|argo-cd|root' | while read -r i; do kubectl delete app "$i"; done