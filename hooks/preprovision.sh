#!/bin/bash
. .azure/${AZURE_ENV_NAME}/.env
echo "hello world"

# AZURE_INFRA_NAME=$(cat .azure/dev/config.json |jq -c '.infra.parameters.name'|tr -d \")

# azd env set AZURE_INFRA_NAME ${AZURE_INFRA_NAME}