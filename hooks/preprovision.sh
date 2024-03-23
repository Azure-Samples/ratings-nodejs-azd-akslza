#!/bin/bash

echo "Starting preprovision hook"
# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping predeploy hook. Exiting."
   exit
fi

echo "Initializing git submodules"
git submodule init 
echo "Updating git submodules"
git submodule update

if [[ -z "${AZURE_INFRA_NAME}" ]]; then
   read -p "Please provide the infrastructure name seed:" AZURE_INFRA_NAME
   azd env set AZURE_INFRA_NAME ${AZURE_INFRA_NAME}
fi
AZURE_SIGNED_IN_USER=$(az ad signed-in-user show --query id -o tsv)

if [[ -z "${AZURE_SIGNED_IN_USER}" ]]; then
   echo "Signed in user not found.  Permissions on AKS will fail."
   exit
fi
azd env set AZURE_SIGNED_IN_USER ${AZURE_SIGNED_IN_USER}


echo "Completed preprovision hook"
