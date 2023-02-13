param location string = resourceGroup().location
param synapseWorkspaceName string 
param fileSystemName string 
param storageAccountUrl string
param storageResourceId string

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

    sqlAdministratorLogin: 'sqladminuser'
    sqlAdministratorLoginPassword: uniqueString(resourceGroup().id)

  }
}

// output resource id of the synapse workspace
output synapseWorkspaceId string = synapseSerengeti.id
