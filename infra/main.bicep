targetScope = 'subscription'

@minLength(1)
@maxLength(17)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param name string


@minLength(1)
@description('Primary location for all resources')
param location string

// cq added
@minLength(1)
@description('Signed In User')
param signedinuser string

//var resourceToken = '${name}-${toLower(uniqueString(subscription().id, name, location))}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${name}-rg'
  location: location
  tags: {
    'azd-env-name': name
  }
}

module resources 'resources.bicep' = {
  scope: resourceGroup
  name: 'resources-${name}'
  params: {
    signedinuser: ''
//    signedinuser: signedinuser
    location: location
    nameseed: name
  }
}
// output APP_WEB_BASE_URL string = serviceBusApp.outputs.ApplicationUrl
// output APPINSIGHTS_INSTRUMENTATIONKEY string = serviceBusApp.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
// output APPINSIGHTS_CONNECTION_STRING string = serviceBusApp.outputs.APPINSIGHTS_CONNECTION_STRING
output AZURE_LOCATION string = location
output AZURE_AKS_CLUSTER_NAME string = resources.outputs.aksClusterName
output AZURE_CONTAINER_REGISTRY string = resources.outputs.containerRegistryName
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = '${resources.outputs.containerRegistryName}.azurecr.io'
output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AZURE_TENANT_ID string = subscription().tenantId
output AZURE_KEY_VAULT_NAME string = resources.outputs.kvAppName
output AZURE_APP_MSI string = resources.outputs.idsuperappClientId
output AZURE_APP_GATEWAY_NAME string = resources.outputs.AZURE_APP_GATEWAY_NAME
output AZURE_AKS_RESOURCE_ID string = resources.outputs.AZURE_AKS_RESOURCE_ID

