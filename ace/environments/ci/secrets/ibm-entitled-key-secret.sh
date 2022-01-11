#!/usr/bin/env bash

# Set variables
#IBM_ENTITLEMENT_KEY=<ENTITLEMENT-KEY>
IBM_ENTITLEMENT_KEY=${IBM_ENTITLEMENT_KEY}
#SEALEDSECRET_NAMESPACE=sealed-secrets
SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml
oc create secret docker-registry ibm-entitlement-key \
--docker-username=cp \
--docker-server=cp.icr.io \
--docker-password=${IBM_ENTITLEMENT_KEY} \
--dry-run=true -o yaml > delete-ibm-entitled-key-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
#kubeseal --scope cluster-wide --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-entitled-key-secret.yaml > ibm-entitled-key-secret.yaml
kubeseal -n ci --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-ibm-entitled-key-secret.yaml > ibm-entitled-key-secret.yaml

# NOTE, do not check delete-ibm-entitled-key-secret.yaml into git!
 rm delete-ibm-entitled-key-secret.yaml