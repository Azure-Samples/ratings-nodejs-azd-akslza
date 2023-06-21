#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env

if kubectl config get-contexts ${AZURE_AKS_CLUSTER_NAME} -o name 2>&1| grep ${AZURE_AKS_CLUSTER_NAME}; then
   echo "Remove previous kubeconfig context ${AZURE_AKS_CLUSTER_NAME}"
   kubectl config delete-context ${AZURE_AKS_CLUSTER_NAME} --kubeconfig=${HOME}/.kube/config
fi

if kubectl config get-clusters ${AZURE_AKS_CLUSTER_NAME} 2>&1| grep ${AZURE_AKS_CLUSTER_NAME}; then
   echo "Remove previous kubeconfig cluster ${AZURE_AKS_CLUSTER_NAME}"
   kubectl config delete-cluster ${AZURE_AKS_CLUSTER_NAME} --kubeconfig=${HOME}/.kube/config
fi

if [ -f "${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}" ]; then
   rm ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
fi