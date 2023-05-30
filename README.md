# AKS-Construction-azd
Accelerate your onboarding to AKS with; Helper Web App, bicep templating and CI/CD samples. Flexible &amp; secure AKS baseline implementations in a Microsoft + community maintained reference implementation.

| ⚠️ WARNING              |
|---------------------------|
| Make sure to remove previous cluster configuration with the same name from your .kube files |
| Make sure that your name for the infrastructure is lower case  |

Full deployment of the system and applications takes approximately 12 minutes

git clone this repo and then run the following commands
```
git submodule init 
git submodule update
azd auth login
azd init
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
