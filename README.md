# AKS Landing Zone Accelerator on Azure Developer CLI (AZD)
Accelerate your onboarding to AKS with the Azure develper CLI and AKS landing zone accelerator. Provided here is a blueprint for getting a web app with a Node.js API on Azure using some of the AKS landing zone accelerator best practices. The blueprint includes sample application code (a ratings web app) which can be removed and replaced with your own application code. Add your own source code and use the Infrastructure as Code assets to get running quickly.

---
# Prerequisites
The following prerequisites are required to use this application. Please ensure that you have them all installed locally when using azd cli.
- [Azure Developer CLI](https://aka.ms/azd-install)
- [Node.js with npm (16.13.1+)](https://nodejs.org/) - for API backend and Web frontend
- [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://docs.docker.com/desktop/) - for building application images
- [kubelogin](https://github.com/Azure/kubelogin)
- [jq](https://jqlang.github.io/jq/download/)

This application utilizes the following Azure resources:

- [**AKS Construction**](https://github.com/Azure/AKS-Construction) to deploy an enterprise class secure AKS 
- [**AKS Landing Zone Accelerator**](https://github.com/Azure/AKS-Landing-Zone-Accelerator) for the secure AKS Landing Zone
- [**Ratings Application**](https://github.com/MicrosoftDocs/mslearn-aks-workshop-ratings-api) example application in AKS



| |⚠️ WARNING |
|:----|:---|
| SSL Certificate | Upon navigating to your new FQDN you will see you receive a certificate warning because it is not a production certificate. Using LetsEncrypt staging certificates for your Application Gateway/Ingress Controller is only advised for non-production environments. If you are using Ingress Controllers in your production workloads, we recommend you to purchase a paid TLS certificate. |
| Infrastructure name| Make sure that your name for the infrastructure is lower case  |
| KUBECONFIG | Make sure to remove previous cluster configuration with the same name from your .kube files and unset your KUBECONFIG variable.  During the deployment phase azd will use any KUBECONFIG environment variable and your default ~/.kube/config for both the cluster named in the infrastructure name (aks-${AZURE_INFRA_NAME}) as well as looking for a context of the same name.  If an alternate is set in your environment then the deployment step will attempt to use it.|


# Deploy with azd cli
To deploy with azd cli from a bash environment run the following steps:
Note: Full deployment of the system and applications takes approximately 12 minutes
Variables should either be in the environment or added to the .azure/${AZURE_ENV_NAME}/.env file

git clone this repo, cd into the repo directory and then run the following commands
```
unset KUBECONFIG
git submodule init 
git submodule update
azd auth login
azd init
# the AZURE_INFRA_NAME is the seed for azure resources (ie - ${AZURE_INFRA_NAME}-rg or aks-${AZURE_INFRA_NAME}
export AZURE_INFRA_NAME=<nameseed>
# the AZURE_DNS_LABEL is the short name for the app that is prepended to ${AZURE_LOCATION}.cloudapp.azure.com 
# and you need to make sure it is available first by running nslookup ${AZURE_DNS_LABEL}.${AZURE_LOCATION}.cloudapp.azure.com
export AZURE_DNS_LABEL=<dns short name>
# a valid email address that is required by LetsEncrypt in order to provide a staging certificate
AZURE_EMAIL_ADDRESS=<email address>
azd provision
kubectl config set-context --current --namespace=ratingsapp
azd deploy
```

Now wait a few minutes for the ingress and dns to establish and then open up a web browser to the external url provided from the last step

## Deleting Everything
In order to clean up all resources run:
```
azd down
```






