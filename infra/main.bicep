targetScope = 'subscription'

@minLength(1)
@maxLength(17)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param name string = 'superapp'

@minLength(1)
@description('Primary location for all resources')
param location string

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
    location: location
    nameseed: name
  }
}
// output APP_WEB_BASE_URL string = serviceBusApp.outputs.ApplicationUrl
// output APPINSIGHTS_INSTRUMENTATIONKEY string = serviceBusApp.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
// output APPINSIGHTS_CONNECTION_STRING string = serviceBusApp.outputs.APPINSIGHTS_CONNECTION_STRING
output AZURE_LOCATION string = location
