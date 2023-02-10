param location string = resourceGroup().location
param synapseWorkspaceName string = 'SerengetiDataLab${uniqueString(resourceGroup().id)}'
param storageAccountName string = 'serengetidatalake${uniqueString(resourceGroup().id)}'
param fileSystemName string = 'synapsedef'
