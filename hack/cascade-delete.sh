#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

argocd app list -o json | \
  jq -r '.[].metadata.name' | \
  grep -vE 'autopilot|argo-cd|root|contour-components' | \
  while read -r i; do argocd app set "$i" --sync-policy none; done
argocd app list -o json | \
  jq -r '.[].metadata.name' | \
  grep -vE 'autopilot|argo-cd|root|contour-components' | \
  while read -r i; do kubectl patch application "$i" -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge; done
argocd app list -o json | \
  jq -r '.[].metadata.name' | \
  grep -vE 'autopilot|argo-cd|root|contour-components' | \
  while read -r i; do kubectl delete application "$i"; done
argocd app list -o json | \
  jq -r '.[].metadata.name' | \
  grep -vE 'autopilot|argo-cd|root|contour-components' | \
  while read -r i; do argocd app set "$i" --sync-policy auto; done

# kubectl get application "registry" -o json \
#   | jq 'del(.metadata.finalizers)' \
#   | kubectl replace -f -
