#!/bin/bash

echo "Starting preprovision hook"
# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping predeploy hook and setting AZURE_AUTO_DEPLOYMENT to TRUE. Exiting."
   azd env set AZURE_AUTO_DEPLOYMENT "true"
   exit
fi
azd env set AZURE_AUTO_DEPLOYMENT "false"


echo "Completed preprovision hook"
