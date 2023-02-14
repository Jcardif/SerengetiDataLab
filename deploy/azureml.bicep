param logAnalyticsName string
param appInsightsName string
param location string
param amlWorkspaceName string
param storageId string
param keyVaultId string
param containerRegistryName string



resource serengetiLogWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource serengetiAppInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId:serengetiLogWorkspace.id
    
  }
}

//todo : swelection of sku
resource serengetiContainerRegistry 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Standard'
  }
}

resource serengetiAml 'Microsoft.MachineLearningServices/workspaces@2022-10-01' = {
  name: amlWorkspaceName
  location: location

  properties:{
    storageAccount: storageId
    keyVault: keyVaultId
    applicationInsights: serengetiAppInsights.id
    containerRegistry: serengetiContainerRegistry.id
  }
}
