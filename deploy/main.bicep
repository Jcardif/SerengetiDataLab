param location string = resourceGroup().location
param synapseWorkspaceName string = 'SerengetiDataLab${uniqueString(resourceGroup().id)}'
param storageAccountName string = 'serengetidatalake${uniqueString(resourceGroup().id)}'
param fileSystemName string = 'synapsedef'
param vaultName string = 'serengetiVault${uniqueString(resourceGroup().id)}'

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



