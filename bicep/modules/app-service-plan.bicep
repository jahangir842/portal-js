// modules/app-service-plan.bicep - App Service Plan module
@description('App Service Plan name')
param name string

@description('Location for the App Service Plan')
param location string

@description('App Service Plan SKU')
@allowed([
  'F1'
  'B1'
  'B2'
  'S1'
  'S2'
  'P1V2'
  'P2V2'
])
param sku string

@description('Environment name')
param environment string

// App Service Plan resource
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: name
  location: location
  kind: 'linux'
  properties: {
    reserved: true // Required for Linux
  }
  sku: {
    name: sku
    capacity: sku == 'F1' ? 1 : 2
  }
  tags: {
    Environment: environment
    Purpose: 'Web App Hosting'
  }
}

// Outputs
output id string = appServicePlan.id
output name string = appServicePlan.name
output location string = appServicePlan.location
