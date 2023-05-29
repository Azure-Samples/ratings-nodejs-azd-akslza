# AKS-Construction-azd
Accelerate your onboarding to AKS with; Helper Web App, bicep templating and CI/CD samples. Flexible &amp; secure AKS baseline implementations in a Microsoft + community maintained reference implementation.

{warning:title=Warning}Make sure to remove previous cluster configuration from your .kube files.{warning}

After you git clone the environment, run the following commands
```
git submodule init 
git submodule update
azd auth login
azd init
azd up
```

Now open up a web brower to the external ip address from the last step

