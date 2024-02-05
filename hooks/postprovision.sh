#!/bin/bash

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping postprovision hook. Exiting."
   exit
fi
#. .azure/cqaksazd02/.env
echo "Starting postprovision.sh hook"
AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN='b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
AZURE_SIGNED_IN_USER=$(az ad signed-in-user show --query id -o tsv)
echo "Found AKS Resource ID ${AZURE_AKS_RESOURCE_ID}"

if [[ -z "${AZURE_SIGNED_IN_USER}" ]]; then
   echo "Signed in user not found.  Skipping AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN role assignment."
   exit
fi

az role assignment create --role ${AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN} \
   --assignee-object-id ${AZURE_SIGNED_IN_USER} --assignee-principal-type User --scope ${AZURE_AKS_RESOURCE_ID}

sleep 60

echo "Completed postprovision.sh hook"
