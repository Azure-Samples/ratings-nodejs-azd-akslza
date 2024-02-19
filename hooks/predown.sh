#!/bin/bash


# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping predown hook. Exiting."
   exit
fi

echo "Starting predown.sh hook"
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
echo "Completed predown.sh hook"
