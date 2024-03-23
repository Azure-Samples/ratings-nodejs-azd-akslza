#!/bin/bash

echo "Starting predeploy.sh hook"

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping predeploy hook. Exiting."
   exit
fi


if [[ -z "${AZURE_DNS_LABEL}" ]]; then
   read -p "Please provide dns label for application (this will be prepended to .${AZURE_LOCATION}.cloudapp.azure.com):" AZURE_DNS_LABEL
   if [[ ${AZURE_DNS_LABEL} == *"."* ]]; then
      echo "Error ${AZURE_DNS_LABEL} should not contain a \".\""
      echo "Exiting"
      exit
   fi
fi
azd env set AZURE_DNS_LABEL ${AZURE_DNS_LABEL}

if [[ -z "${AZURE_EMAIL_ADDRESS}" ]]; then
   read -p "Please provide an email address to register for a certificate with LetsEncrypt:" AZURE_EMAIL_ADDRESS
fi
azd env set AZURE_EMAIL_ADDRESS ${AZURE_EMAIL_ADDRESS}


az acr import --name ${AZURE_CONTAINER_REGISTRY} --source docker.io/bitnami/mongodb:5.0.14-debian-11-r9 \
  --image bitnami/mongodb:5.0.14-debian-11-r9 --force



# az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --file=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
# # az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
# azd env set KUBECONFIG ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
# export KUBECONFIG=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}

echo "Completed predeploy.sh hook"

