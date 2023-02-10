param location string = 'eastus'

resource SerengetiSynapse 'Microsoft.Synapse/workspaces@2021-06-01' = {
  location: location
  name: 'SerengetiDataLab'
  properties:{
    defaultDataLakeStorage:
  }
}
