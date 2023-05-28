#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env
#az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --admin --context ${AZURE_AKS_CLUSTER_NAME} --file ~/.kube/${AZURE_AKS_CLUSTER_NAME}
#export KUBECONFIG=${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
#kubectl config set-context ${AZURE_AKS_CLUSTER_NAME}
az acr import --name ${AZURE_CONTAINER_REGISTRY} --source docker.io/bitnami/mongodb:5.0.14-debian-11-r9 \
  --image bitnami/mongodb:5.0.14-debian-11-r9
#helm repo add bitnami https://charts.bitnami.com/bitnami 
#helm install ratings bitnami/mongodb --namespace ratingsapp --create-namespace --set image.tag=5.0.14-debian-11-r9,auth.rootPassword=mongo,auth.username=mongo,auth.password=mongo,auth.database=ratingsdb
export MONGODB_ROOT_PASSWORD=mongo
export NAMESPACE=ratingsapp
export MONGODB_URI="mongodb://root:${MONGODB_ROOT_PASSWORD}@ratings-mongodb.ratingsapp.svc.cluster.local"
kubectl create namespace ${NAMESPACE}
kubectl create secret generic -n ${NAMESPACE} ratings-mongodb --from-literal=mongodb-root-password=${MONGODB_ROOT_PASSWORD} --from-literal=mongodb-passwords=${MONGODB_ROOT_PASSWORD}
kubectl apply -n ${NAMESPACE} -f ../src/manifests/mongo/ratings-mongodb-configmap.yaml
azd env set MONGODB_URI ${MONGODB_URI}
azd env set MONGODB_ROOT_PASSWORD ${MONGODB_ROOT_PASSWORD}
