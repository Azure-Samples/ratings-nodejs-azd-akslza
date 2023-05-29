# AKS-Construction-azd
Accelerate your onboarding to AKS with; Helper Web App, bicep templating and CI/CD samples. Flexible &amp; secure AKS baseline implementations in a Microsoft + community maintained reference implementation.

| ⚠️: WARNING              |
|:---------------------------|
| Make sure to remove previous cluster configuration with the same name from your .kube files |
| Make sure that your name for the infrastructure is lower case  |

git clone this repo and then run the following commands
```
git submodule init 
git submodule update
azd auth login
azd init
azd up
```

Now open up a web brower to the external ip address from the last step

