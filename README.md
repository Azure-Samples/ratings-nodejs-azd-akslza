# AKS Landing Zone Accelerator on Azure Developer CLI (AZD)
Accelerate your onboarding to AKS with the Azure develper CLI and AKS landing zone accelerator. Provided here is a blueprint for getting a web app with a Node.js API on Azure using some of the AKS landing zone accelerator best practices. The blueprint includes sample application code (a ratings web app) which can be removed and replaced with your own application code. Add your own source code and use the Infrastructure as Code assets to get running quickly.

| ⚠️ WARNING              ||
|---------------------------||
| KUBECONFIG | Make sure to remove previous cluster configuration with the same name from your .kube files and unset your KUBECONFIG variable.  During the deployment phase azd will use any KUBECONFIG environment variable and your default ~/.kube/config for both the cluster named in the infrastructure name (aks-${AZURE_INFRA_NAME}) as well as looking for a context of the same name.  If an alternate is set in your environment then the deployment step will attempt to use it.|
| Infrastructure name| Make sure that your name for the infrastructure is lower case  |

Full deployment of the system and applications takes approximately 12 minutes

git clone this repo and then run the following commands
```
git submodule init 
git submodule update
azd auth login
azd init
unset KUBECONFIG
azd up
```

Now open up a web brower to the external ip address from the last step

# Deleting Everything
In order to clean up all resources run:
```
azd down --no-prompt
```

| Issues that need to be fixed: |
|:---------------------------|
| AKS using local admin account |
| Need to put secrets in AKV |
| Need to have https on ingress |
| Need to figure out how to put mongo configmap in manifests without breaking azd since it can't handle format (talk to azd team) |
| remove pip from AKS - unsecure, instead use agic or app gateway and fw rules |
| figure out how to have re-usable tags on images so it doesn't clutter with lots of local docker image tags |
| fix checkin workflow |
