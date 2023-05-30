#!/bin/bash
source .azure/${AZURE_ENV_NAME}/.env

kubectl config unset clusters.${AZURE_AKS_CLUSTER_NAME}
