@description('The name of the web app that will be created.')
param appName string

@description('The name of the environment that will be created.')
param envName string

@description('The name of the slot that will be created.')
param slotName string = 'preview'

@description('Describes plan\'s pricing tier and instance size. Check details at https://azure.microsoft.com/en-us/pricing/details/app-service/')
@allowed([
  'S1'
  'P1'
])
param skuName string = 'S1'

@description('Describes plan\'s instance count')
@minValue(1)
@maxValue(3)
param skuCapacity int = 1

@description('The admin user of the SQL Server')
param sqlAdministratorLogin string

@description('The password of the admin user of the SQL Server')
@secure()
param sqlAdministratorLoginPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

var prefix = '${appName}-${envName}'
var hostingPlanName = '${prefix}-asp'
var websiteName = '${prefix}-web'
var sqlserverName = '${prefix}-sql'
var databaseName = '${prefix}-db'

resource sqlserver 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlserverName
  location: location
  tags: {
    displayName: 'SQL Server'
  }
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
  }
}

resource sqlserverName_database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlserver
  name: '${databaseName}'
  location: location
  tags: {
    displayName: 'Database'
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
  }
}

resource sqlserverName_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  parent: sqlserver
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostingPlanName
  location: location
  tags: {
    displayName: 'HostingPlan'
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource website 'Microsoft.Web/sites@2020-12-01' = {
  name: websiteName
  location: location
  tags: {
    'hidden-related:${hostingPlan.id}': 'empty'
    displayName: 'Website'
  }
  properties: {
    serverFarmId: hostingPlan.id
  }
}

resource websiteName_appsettings 'Microsoft.Web/sites/config@2015-08-01' = {
  parent: website
  name: 'appsettings'
  tags: {
    displayName: 'config'
  }
  properties: {
    EnvName: 'ARM'
    FavoriteColor: 'lightgreen'
  }
}

resource websiteName_connectionstrings 'Microsoft.Web/sites/config@2020-12-01' = {
  parent: website
  name: 'connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlserver.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${sqlAdministratorLogin}@${sqlserver.properties.fullyQualifiedDomainName};Password=${sqlAdministratorLoginPassword};'
      type: 'SQLAzure'
    }
  }
}

resource websiteName_slot 'Microsoft.Web/sites/slots@2020-12-01' = {
  parent: website
  name: '${slotName}'
  location: location
  tags: {
    displayName: 'slotName'
  }
  properties: {
    serverFarmId: hostingPlan.id
  }
}

resource websiteName_slotName_appsettings 'Microsoft.Web/sites/slots/config@2018-11-01' = {
  parent: websiteName_slot
  name: 'appsettings'
  properties: {
    EnvName: slotName
    FavoriteColor: 'lightyellow'
  }
}

resource AppInsights_website 'Microsoft.Insights/components@2020-02-02' = {
  name: 'AppInsights${websiteName}'
  location: location
  tags: {
    'hidden-link:${website.id}': 'Resource'
    displayName: 'AppInsightsComponent'
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}