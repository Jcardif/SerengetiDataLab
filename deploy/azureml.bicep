param logAnalyticsName string
param appInsightsName string
param location string
param amlWorkspaceName string
param storageId string
param keyVaultId string



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

resource serengetiAml 'Microsoft.MachineLearningServices/workspaces@2022-10-01' = {
  name: amlWorkspaceName
  location: location

  properties:{
    storageAccount: storageId
    keyVault: keyVaultId
    applicationInsights: serengetiAppInsights.id
  }
}
