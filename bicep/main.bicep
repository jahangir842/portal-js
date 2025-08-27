// main.bicep - Main template file with modules
@description('The name prefix for all resources')
param namePrefix string = 'portal-js-jagz'

@description('The Azure region where resources will be deployed')
param location string = 'Canada Central'

@description('The pricing tier for the App Service Plan')
@allowed([
  'F1'
  'B1'
  'B2'
  'S1'
  'S2'
  'P1V2'
  'P2V2'
])
param appServicePlanSku string = 'F1'

@description('Node.js runtime version')
param nodeVersion string = '18-lts'

@description('Environment name (dev, staging, prod)')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'dev'

// Variables
var resourceNames = {
  appServicePlan: 'asp-${namePrefix}-${environment}'
  webApp: '${namePrefix}-${environment}'
  resourceGroup: resourceGroup().name
}

// Module: App Service Plan
module appServicePlan 'modules/app-service-plan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: resourceNames.appServicePlan
    location: location
    sku: appServicePlanSku
    environment: environment
  }
}

// Module: Web App
module webApp 'modules/web-app.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: resourceNames.webApp
    location: location
    appServicePlanId: appServicePlan.outputs.id
    nodeVersion: nodeVersion
    environment: environment
  }
}

// Outputs
output webAppName string = webApp.outputs.name
output webAppUrl string = webApp.outputs.url
output appServicePlanName string = appServicePlan.outputs.name
output resourceGroupName string = resourceNames.resourceGroup
