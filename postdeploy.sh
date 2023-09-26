#!/bin/bash

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping postdeploy hook. Exiting."
   exit
fi


docker rmi ${SERVICE_API_IMAGE_NAME}
docker rmi ${SERVICE_WEB_IMAGE_NAME}

PIP_NAME=$(az network application-gateway show -g ${AZURE_RESOURCE_GROUP} -n ${AZURE_APP_GATEWAY_NAME} --query "frontendIPConfigurations[].publicIPAddress[].id" -o tsv|sed 's/\/.*\///g')
az network public-ip update -g ${AZURE_RESOURCE_GROUP} -n $PIP_NAME --dns-name ${AZURE_DNS_LABEL}