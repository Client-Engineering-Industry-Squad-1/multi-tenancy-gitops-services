#!/usr/bin/env bash

# Set variables
if [[ -z ${B2B_DB_USER} ]]; then
  echo "Please provide environment variable B2B_DB_USER"
  exit 1
fi

if [[ -z ${B2B_DB_SECRET} ]]; then
  echo "Please provide environment variable B2B_DB_SECRET"
  exit 1
fi

B2B_DB_USER=${B2B_DB_USER}
B2B_DB_SECRET=${B2B_DB_SECRET}

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml
oc create secret generic b2b-db-secret --type=Opaque \
--from-literal=DB_USER=${B2B_DB_USER} \
--from-literal=DB_PASSWORD=${B2B_DB_SECRET} \
--dry-run=client -o yaml > delete-b2b-db-secret-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n tools --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-b2b-db-secret-secret.yaml > b2b-db-secret-secret.yaml

# NOTE, do not check delete-b2b-db-secret-secret.yaml into git!
rm delete-b2b-db-secret-secret.yaml