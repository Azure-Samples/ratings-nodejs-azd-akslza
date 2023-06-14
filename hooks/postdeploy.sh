#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env

export NAMESPACE=ratingsapp

docker rmi ${SERVICE_API_IMAGE_NAME}
docker rmi ${SERVICE_WEB_IMAGE_NAME}
# cat ./src/manifests/misc/5-https-ratings-web-ingress.yaml |sed -e "s/\${AZURE_DNS_LABEL}/${AZURE_DNS_LABEL}/g" \
#     -e  "s/\${AZURE_LOCATION}/${AZURE_LOCATION}/g"| kubectl apply -n ${NAMESPACE} -f -

INGRESS_IP=$(kubectl get ingress -n ${NAMESPACE} ratings-web-https -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
PIP_NAME=$(az network application-gateway show -g ${AZURE_RESOURCE_GROUP} -n ${AZURE_APP_GATEWAY_NAME} --query "frontendIPConfigurations[].publicIPAddress[].id" -o tsv|sed 's/\/.*\///g')

az network public-ip update -g ${AZURE_RESOURCE_GROUP} -n $PIP_NAME --dns-name ${AZURE_DNS_LABEL}

echo "==================================================================================="
echo "===  Please was a few minutes for the new fqdn to propogate through dns and then "
echo "===  You may access the application at "
echo "===  https://${AZURE_DNS_LABEL}.${AZURE_LOCATION}.cloudapp.azure.com"
echo "==================================================================================="
