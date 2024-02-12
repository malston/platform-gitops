#!/usr/bin/env bash

set -o errexit

kubectl label clusterrolebinding/envoy kapp.k14s.io/app-
kubectl label clusterrolebinding/contour kapp.k14s.io/app-
kubectl label clusterrole/contour kapp.k14s.io/app-
kubectl label customresourcedefinition/tlscertificatedelegations.projectcontour.io kapp.k14s.io/app-
kubectl label customresourcedefinition/extensionservices.projectcontour.io kapp.k14s.io/app-
kubectl label customresourcedefinition/contourdeployments.projectcontour.io kapp.k14s.io/app-
kubectl label customresourcedefinition/contourconfigurations.projectcontour.io kapp.k14s.io/app-
kubectl label customresourcedefinition/httpproxies.projectcontour.io kapp.k14s.io/app-
kubectl label clusterrole/envoy kapp.k14s.io/app-
