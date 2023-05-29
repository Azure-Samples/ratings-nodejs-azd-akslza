#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --admin --context ${AZURE_AKS_CLUSTER_NAME} --file=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME} --overwrite-existing
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --admin --context ${AZURE_AKS_CLUSTER_NAME} --overwrite-existing
export KUBECONFIG=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
kubectl config set-context ${AZURE_AKS_CLUSTER_NAME}
