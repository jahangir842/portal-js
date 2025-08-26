// main.bicepparam - Parameters file
using './main.bicep'

// Basic parameters
param namePrefix = 'portal-js-jagz'
param location = 'East US'
param environment = 'dev'

// App Service Plan configuration
param appServicePlanSku = 'F1'  // Change to 'B1' for basic, 'S1' for standard

// Runtime configuration
param nodeVersion = '18-lts'
