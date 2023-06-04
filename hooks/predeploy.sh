#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env

az acr import --name ${AZURE_CONTAINER_REGISTRY} --source docker.io/bitnami/mongodb:5.0.14-debian-11-r9 \
  --image bitnami/mongodb:5.0.14-debian-11-r9 --force

export MONGODB_ROOT_PASSWORD=mongo
export NAMESPACE=ratingsapp
export MONGODB_URI="mongodb://root:${MONGODB_ROOT_PASSWORD}@ratings-mongodb.ratingsapp.svc.cluster.local"

az keyvault secret set --name mongodburi --vault-name ${AZURE_KEY_VAULT_NAME} --value "${MONGODB_URI}"

if ! kubectl get namespaces|grep ${NAMESPACE}; then
   kubectl create namespace ${NAMESPACE}
fi
# if kubectl get secret -n ${NAMESPACE} ratings-mongodb; then
#    kubectl delete secret -n ${NAMESPACE} ratings-mongodb
# fi 
# kubectl create secret generic -n ${NAMESPACE} ratings-mongodb --from-literal=mongodb-root-password=${MONGODB_ROOT_PASSWORD} --from-literal=mongodb-passwords=${MONGODB_ROOT_PASSWORD}

kubectl apply -n ${NAMESPACE} -f ./src/manifests/mongo/ratings-mongodb-configmap.yaml

azd env set MONGODB_URI ${MONGODB_URI}
azd env set MONGODB_ROOT_PASSWORD ${MONGODB_ROOT_PASSWORD}
