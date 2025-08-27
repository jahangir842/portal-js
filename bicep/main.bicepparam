// main.bicepparam - Parameters file
using './main.bicep'

// Basic parameters
param namePrefix = 'portal-js-jagz'
param location = 'Canada Central'
param environment = 'dev'

// App Service Plan configuration
param appServicePlanSku = 'F1'  // Free tier

// Runtime configuration
param nodeVersion = '22-lts'
