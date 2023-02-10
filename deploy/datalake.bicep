param location string = 'eastus'

resource serengetiDataLake 'Microsoft.Storage/storageAccounts@2022-09-01'= {
  name: 'serengetiDataLake'
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
