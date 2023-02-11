param location string = resourceGroup().location
param synapseWorkspaceName string = 'SerengetiDataLab${uniqueString(resourceGroup().id)}'
param storageAccountName string = 'serengetidatalake${uniqueString(resourceGroup().id)}'
param fileSystemName string = 'synapsedef'
param vaultName = 'serengetiVault${uniqueString(resourceGroup().id)}'

module synapseWorkspace 'synapse.bicep' = {
  name: 'synapseWorkspace'
  params: {
    location: location
    synapseWorkspaceName: synapseWorkspaceName
    storageAccountName: storageAccountName
    fileSystemName: fileSystemName
  }
}

resource serengetiVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: vaultName
  location: location
  properties: {
    accessPolicies: [
      {
        applicationId: 'string'
        objectId: 'string'
        permissions: {
          certificates: [
            'string'
          ]
          keys: [
            'string'
          ]
          secrets: [
            'string'
          ]
          storage: [
            'string'
          ]
        }
        tenantId: 'string'
      }
    ]

    enableSoftDelete: true

    provisioningState: 'string'
    publicNetworkAccess: 'string'
    sku: {
      family: 'A'
      name: 'string'
    }
    softDeleteRetentionInDays: 30
    tenantId: 'string'
    vaultUri: 'string'
  }
}
