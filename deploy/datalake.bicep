param location string 
param storageAccountName string 

resource serengetiDataLake 'Microsoft.Storage/storageAccounts@2022-09-01'= {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'storageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
  }

}

  // output accountUrl and rersource id
  output accountUrl string = serengetiDataLake.properties.primaryEndpoints.blob
  output resourceId string = serengetiDataLake.id

