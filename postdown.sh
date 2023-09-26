#!/bin/bash

# check to see if this is running as github action
if [[ ! -z "$CI" ]]; then
   echo "Running on github, skipping postdown hook. Exiting."
   exit
fi

if [ -f "${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}" ]; then
   rm ${HOME}/.kube/${AZURE_AKS_CLUSTER_NAME}
fi