#!/bin/sh
echo "Prior to source"
source .azure/${AZURE_ENV_NAME}/.env
echo "after source"
if ! [ -z "${AZURE_INFRA_NAME}"]; then
   echo "Error, AZURE_INFRA_NAME environment variable not found.  Exiting."
   exit;
fi
azd env set AZURE_INFRA_NAME ${AZURE_INFRA_NAME}



