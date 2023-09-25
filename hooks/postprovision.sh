#!/bin/bash

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping postprovision hook. Exiting."
   exit
fi
#. .azure/cqaksazd02/.env
AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN='b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
SIGNED_IN_USER=$(az ad signed-in-user show --query id -o tsv)
echo "Found AKS Resource ID ${AZURE_AKS_RESOURCE_ID}"

if [[ -z "${SIGNED_IN_USER}" ]]; then
   echo "Signed in user not found.  Skipping AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN role assignment."
   exit
fi

az role assignment create --role ${AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN} \
   --assignee-object-id ${SIGNED_IN_USER} --assignee-principal-type User --scope ${AZURE_AKS_RESOURCE_ID}

# AKS_ID=$(az aks show --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER_NAME --query id -o tsv)

az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --file=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
azd env set KUBECONFIG ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
export KUBECONFIG=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}