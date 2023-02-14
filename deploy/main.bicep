param location string = resourceGroup().location
var synapseWorkspaceName = substring('serengetidatalab${uniqueString(resourceGroup().id)}', 0, 24)
var storageAccountName = substring('serengetistore${uniqueString(resourceGroup().id)}', 0, 24)
var fileSystemName = 'synapsedef'
var vaultName = substring('serengetikeyvault${uniqueString(resourceGroup().id)}', 0, 24)
var amlWorkspaceName = 'SerengetiAML${uniqueString(resourceGroup().id)}'
var appInsightsName = 'serengetiAppInsights${uniqueString(resourceGroup().id)}'
var logAnalyticsName = 'serengetiLogAnalytics${uniqueString(resourceGroup().id)}'
var containerRegistryName = 'serengetiContainers${uniqueString(resourceGroup().id)}'


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



resource SerengetiVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
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
        objectId: synapseWorkspace.outputs.synapseManagedIdentityId
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
  name: '${SerengetiVault.name}/SqlPoolPassword'
  properties: {
    value: sqlAdministratorLoginPassword
    contentType: 'text/plain'
  }
}

resource AccessKeySecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: '${SerengetiVault.name}/ADLS-AccessKey'
  properties: {
    value: defaultSynapseDataLake.outputs.storageAccountKey
    contentType: 'text/plain'
  }
}

module amlWorkspace 'azureml.bicep' = {
  name: 'amlWorkspace'
  params: {
    location: location
    amlWorkspaceName: amlWorkspaceName
    appInsightsName: appInsightsName
    logAnalyticsName: logAnalyticsName
    keyVaultId: SerengetiVault.id
    storageId: defaultSynapseDataLake.outputs.resourceId
    containerRegistryName: containerRegistryName
    synapseSparkPoolId: synapseWorkspace.outputs.synapsePoolId
    synapseWorkspaceId: synapseWorkspace.outputs.synapseWorkspaceId
  }
}







