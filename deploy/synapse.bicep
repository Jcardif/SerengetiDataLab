param location string = resourceGroup().location
param synapseWorkspaceName string 
param fileSystemName string 
param storageAccountUrl string
param storageResourceId string
param sqlPoolName string = 'defdedicated'
param performanceLevel string = 'DW1000c'
param capacity int = 100
param sqlPoolTier string = 'Standard'
param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string


resource synapseSerengeti 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseWorkspaceName
  location: location

  properties: {
    defaultDataLakeStorage: {
      accountUrl: storageAccountUrl
      createManagedPrivateEndpoint: false
      filesystem: fileSystemName
      resourceId: storageResourceId
    }

    managedResourceGroupName: '${resourceGroup().name}-mrg'

    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword

  }
}

resource symbolicname 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  name: sqlPoolName
  location: location
  sku: {
    capacity: capacity
    name: performanceLevel 
    tier: sqlPoolTier
  }
  parent: synapseSerengeti
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'

  }
}

// output resource id of the synapse workspace
output synapseWorkspaceId string = synapseSerengeti.id
