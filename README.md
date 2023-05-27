# AKS-Construction-azd
Accelerate your onboarding to AKS with; Helper Web App, bicep templating and CI/CD samples. Flexible &amp; secure AKS baseline implementations in a Microsoft + community maintained reference implementation.


```
git submodule init 
git submodule update
azd auth login
azd init
azd up
```

Wait for the deployment to fail
$NAME is the name you provided for the 'name' infrastructure parameter during azd up
make sure you saved the values for future use

```
export NAME=<place the name you used during azd up here>
source .azure/$NAME/.env
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_AKS_CLUSTER_NAME} --admin --context ${AZURE_AKS_CLUSTER_NAME} --file ~/.kube/${AZURE_AKS_CLUSTER_NAME}
export KUBECONFIG=~/.kube/${AZURE_AKS_CLUSTER_NAME}
helm repo add bitnami https://charts.bitnami.com/bitnami 
helm install ratings bitnami/mongodb --namespace ratingsapp --create-namespace --set image.tag=5.0.14-debian-11-r9,auth.rootPassword=mongo,auth.username=mongo,auth.password=mongo,auth.database=ratingsdb
azd deploy --debug

```

