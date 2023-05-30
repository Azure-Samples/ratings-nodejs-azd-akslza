#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env

export NAMESPACE=ratingsapp

docker rmi ${SERVICE_API_IMAGE_NAME}
docker rmi ${SERVICE_WEB_IMAGE_NAME}

INGRESS_IP=$(kubectl get svc -n ${NAMESPACE} ratings-web -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "==================================================================================="
echo "===   Application may be accessed at"
echo "===   http://${INGRESS_IP}"
echo "==================================================================================="
