param kvName string
param appclientId string

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: kvName
}

var keyVaultSecretsUserRole = resourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
resource kvAppGwSecretsUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: kv
  name: guid(kv.id, appclientId, keyVaultSecretsUserRole)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole
    principalType: 'ServicePrincipal'
    principalId: appclientId
  }
}

resource postgressecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: 'pgpassword'
  properties: {
    value: 'PgPassword'
  }
}

resource mongodbURL 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: 'mongodburi'
  properties: {
    value: 'mongodb://root:mongo@ratings-mongodb.ratingsapp.svc.cluster.local'
  }
}
