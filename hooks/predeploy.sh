#!/bin/bash

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping predeploy hook. Exiting."
   exit
fi

AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN='b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
SIGNED_IN_USER=$(az ad signed-in-user show --query id -o tsv)
echo "Found AKS Resource ID ${AZURE_AKS_RESOURCE_ID}"

if [[ -z "${SIGNED_IN_USER}" ]]; then
   echo "Signed in user not found.  Skipping AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN role assignment."
   exit
fi

az role assignment create --role ${AZURE_KUBERNETES_SERVICE_RBAC_CLUSTER_ADMIN} \
   --assignee-object-id ${SIGNED_IN_USER} --assignee-principal-type User --scope ${AZURE_AKS_RESOURCE_ID}
#make sure to sleep for a bit after assignment
sleep 120

az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --file=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
azd env set KUBECONFIG ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
export KUBECONFIG=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}

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

# if kubectl get ns 2>&1 | grep 'no such host'; then 
#    echo "Error, invalid kubeconfig"; 
#    echo "Please ensure that you remove redundant or invalid references to ${AZURE_AKS_CLUSTER_NAME}"
#    echo "Exiting"
#    exit
# fi


az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --file=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
# az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --overwrite-existing --admin
azd env set KUBECONFIG ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
export KUBECONFIG=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}


# export NAMESPACE=ratingsapp
# if ! kubectl get namespaces|grep ${NAMESPACE}; then
#    kubectl create namespace ${NAMESPACE}
# fi

# if kubectl get ingress -n ${NAMESPACE} |grep ratings-web-https; then
#    kubectl delete ingress -n ${NAMESPACE} ratings-web-https
# fi

# kubectl apply -n ${NAMESPACE} -f ./src/manifests/mongo/ratings-mongodb-configmap.yaml
# kubectl apply -f ./src/manifests/cert-manager/cert-manager.yaml


