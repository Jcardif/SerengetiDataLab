param location string = resourceGroup().location
param synapseWorkspaceName string 
param storageAccountName string 
param fileSystemName string 


module defaultSynapseDataLake 'datalake.bicep' ={
  name : 'defaultSynapseDataLake${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}


resource synapseSerengeti 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseWorkspaceName
  location: location

  properties: {
    defaultDataLakeStorage: {
      accountUrl: defaultSynapseDataLake.outputs.accountUrl
      createManagedPrivateEndpoint: false
      filesystem: fileSystemName
      resourceId: defaultSynapseDataLake.outputs.resourceId
    }

    managedResourceGroupName: '${resourceGroup().name}-mrg'

    sqlAdministratorLogin: 'sqladminuser'
    sqlAdministratorLoginPassword: uniqueString(resourceGroup().id)

  }
}

// output resource id of the synapse workspace
output synapseWorkspaceId string = synapseSerengeti.id
