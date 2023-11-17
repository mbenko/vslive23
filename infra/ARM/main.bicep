targetScope= 'subscription'

param appName string
param envName string = 'bicep'
param color string = 'lightpink'

var rgName = '${appName}-${envName}-rg'

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: rgName
  location: 'eastus'
}

module site 'mySite.bicep' = {
  scope: rg
  name: 'site-deploy'
  params: {
    appName: appName
    color: color
    envName: envName
  }
}
