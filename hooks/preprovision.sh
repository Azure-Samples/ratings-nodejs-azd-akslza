#!/bin/bash

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping predeploy hook. Exiting."
   exit
fi

if [[ -z "${AZURE_INFRA_NAME}" ]]; then
   read -p "Please provide the infrastructure name seed:" AZURE_INFRA_NAME
   azd env set AZURE_INFRA_NAME ${AZURE_INFRA_NAME}
fi


