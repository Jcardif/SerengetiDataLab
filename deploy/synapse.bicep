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
param mlsparkpoolName string = 'mlsparkpool'

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
  identity: {
    type: 'SystemAssigned'
  }

}

//User-Assignment Managed Identity used to execute deployment scripts
resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'deploymentScriptUAMI'
  location: location
}

//Assign Owner Role to UAMI in the Synapse Workspace. UAMI needs to be Owner so it can assign itself as Synapse Admin and create resources in the Data Plane.
resource r_synapseWorkspaceOwner 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('cbe28037-09a6-4b35-a751-8dfd3f03f59d', subscription().subscriptionId, resourceGroup().id)
  scope: synapseSerengeti
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
    principalId: uami.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource dedicateSqlPool 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
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

resource mlPool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = {
  location: location
  name: mlsparkpoolName
  parent: synapseSerengeti
  properties: {
    autoPause: {
      delayInMinutes: 15
      enabled: true
    }
    sparkVersion: '3.2'
    nodeSize: 'Medium'
    nodeSizeFamily: 'HardwareAcceleratedGPU'
    nodeCount: 3
    autoScale: {
      enabled: true
      minNodeCount: 3
      maxNodeCount: 10
    }
  }
}

// output resource id of the synapse workspace
output synapseWorkspaceId string = synapseSerengeti.id
output synapseManagedIdentityId string = synapseSerengeti.identity.principalId
output synapsePoolId string = mlPool.id
