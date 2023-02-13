param location string = resourceGroup().location
var synapseWorkspaceName = 'SerengetiDataLab${uniqueString(resourceGroup().id)}'
var storageAccountName = substring('serengetistore${uniqueString(resourceGroup().id)}', 0, 24)
var fileSystemName = 'synapsedef'
var vaultName = 'serengetiVault${uniqueString(resourceGroup().id)}'
var amlWorkspaceName = 'SerengetiAML${uniqueString(resourceGroup().id)}'


param sqlAdministratorLogin string = 'sqladminuser'

@secure()
param sqlAdministratorLoginPassword string 

module defaultSynapseDataLake 'datalake.bicep' = {
  name: 'defaultSynapseDataLake${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

module synapseWorkspace 'synapse.bicep' = {
  name: 'synapseWorkspace'
  params: {
    location: location
    synapseWorkspaceName: synapseWorkspaceName
    fileSystemName: fileSystemName
    storageAccountUrl: defaultSynapseDataLake.outputs.accountUrl
    storageResourceId: defaultSynapseDataLake.outputs.resourceId
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: vaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: synapseWorkspace.outputs.synapseWorkspaceId
        permissions: {
          keys: [
            'get'
          ]
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
    enabledForTemplateDeployment: true
  }
}

// Create a secret
resource passwordSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: '${keyVault.name}/SqlPoolPassword'
  properties: {
    value: sqlAdministratorLoginPassword
    contentType: 'text/plain'
  }
}

resource AccessKeySecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: '${keyVault.name}/ADLS-AccessKey'
  properties: {
    value: defaultSynapseDataLake.outputs.storageAccountKey
    contentType: 'text/plain'
  }
}

resource serengetiAml 'Microsoft.MachineLearningServices/workspaces@2022-10-01' = {
  name: amlWorkspaceName
  location: location

  properties:{
    storageAccount: defaultSynapseDataLake.outputs.resourceId
  }
}




