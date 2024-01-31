#!/bin/bash
echo "Entering postdeploy hook"
# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping postdeploy hook. Exiting."
   exit
fi

export NAMESPACE=ratingsapp

docker rmi ${SERVICE_API_IMAGE_NAME}
docker rmi ${SERVICE_WEB_IMAGE_NAME}

INGRESS_IP=$(kubectl get ingress -n ${NAMESPACE} ratings-web-https -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [[ -z $INGRESS_IP ]];then
   echo "Error, no ingress ip assigned to ingress ${NAMESPACE} ratings-web-https.  Exiting."
   exit
fi
echo "Ingress IP for ratings-web-https is ${INGRESS_IP}"

PIP_NAME=$(az network application-gateway show -g ${AZURE_RESOURCE_GROUP} -n ${AZURE_APP_GATEWAY_NAME} --query "frontendIPConfigurations[].publicIPAddress[].id" -o tsv|sed 's/\/.*\///g')
if [[ -z $PIP_NAME ]];then
   echo "Error, no pip found on Azure App Gateway ${AZURE_APP_GATEWAY_NAME} in resource group ${AZURE_RESOURCE_GROUP}.  Exiting."
   exit
fi
echo "PIP for Azure App Gateway found: ${PIP_NAME}.  Preparing to assign dns label ${AZURE_DNS_LABEL}."

az network public-ip update -g ${AZURE_RESOURCE_GROUP} -n $PIP_NAME --dns-name ${AZURE_DNS_LABEL}

echo "==================================================================================="
echo "===  Please was a few minutes for the new fqdn to propogate through dns and then "
echo "===  You may access the application at "
echo "===  https://${AZURE_DNS_LABEL}.${AZURE_LOCATION}.cloudapp.azure.com"
echo "==================================================================================="
