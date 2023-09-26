#!/bin/bash

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping postprovision hook. Exiting."
   exit
fi

# SIGNED_IN_USER=$(az ad signed-in-user show --query id -o tsv)
# AKS_ID=$(az aks show --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER_NAME --query id -o tsv)
# AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN='b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'

# az role assignment create --role ${AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN} \
#    --assignee-object-id ${SIGNED_IN_USER} --assignee-principal-type User --scope ${AKS_ID}

kubelogin convert-kubeconfig -l azurecli
kubectl config current-context
kubectl get service