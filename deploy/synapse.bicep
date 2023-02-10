param location string = resourceGroup().location
param synapseWorkspaceName string = 'SerengetiDataLab${uniqueString(resourceGroup().id)}'
param storageAccountName string = 'serengetidatalake${uniqueString(resourceGroup().id)}'

module defaultSynapseDataLake 'datalake.bicep' ={
  name : 'defaultSynapseDataLake${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

resource serengetiSynapse 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseWorkspaceName
  location: location
  properties:{
    defaultDataLakeStorage: defaultSynapseDataLake
  }
}
