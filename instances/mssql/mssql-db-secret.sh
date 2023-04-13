#!/usr/bin/env bash

# Set variables
if [[ -z ${MSSQL_SA_PASSWORD} ]]; then
  echo "Please provide environment variable MSSQL_SA_PASSWORD"
  exit 1
fi

MSSQL_SA_PASSWORD=${MSSQL_SA_PASSWORD}

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml
oc create secret generic mssql-db-secret --type=Opaque \
--from-literal=MSSQL_SA_PASSWORD=${MSSQL_SA_PASSWORD} \
--dry-run=client -o yaml > delete-mssql-db-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n tools --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-mssql-db-secret.yaml > mssql-db-secret.yaml

# NOTE, do not check delete-mssql-db-secret-secret.yaml into git!
rm delete-mssql-db-secret.yaml