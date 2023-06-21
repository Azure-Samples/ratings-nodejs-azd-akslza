#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env

if [ -f "${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}" ]; then
   rm ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
fi