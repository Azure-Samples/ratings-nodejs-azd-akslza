#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env

az acr import --name ${AZURE_CONTAINER_REGISTRY} --source docker.io/bitnami/mongodb:5.0.14-debian-11-r9 \
  --image bitnami/mongodb:5.0.14-debian-11-r9 --force

if kubectl get ns 2>&1 | grep 'no such host'; then 
   echo "Error, invalid kubeconfig"; 
   echo "Please ensure that you remove redundant or invalid references to ${AZURE_AKS_CLUSTER_NAME}"
   echo "Exiting"
   exit
fi


az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --file=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME} --overwrite-existing
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --context ${AZURE_AKS_CLUSTER_NAME} --overwrite-existing
azd env set KUBECONFIG ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
export KUBECONFIG=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}


export NAMESPACE=ratingsapp
if ! kubectl get namespaces|grep ${NAMESPACE}; then
   kubectl create namespace ${NAMESPACE}
fi

kubectl apply -n ${NAMESPACE} -f ./src/manifests/mongo/ratings-mongodb-configmap.yaml

