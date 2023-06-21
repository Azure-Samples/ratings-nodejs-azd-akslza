#!/bin/bash

if [ -f "${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}" ]; then
   rm ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
fi