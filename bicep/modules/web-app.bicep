// modules/web-app.bicep - Web App module
@description('Web App name')
param name string

@description('Location for the Web App')
param location string

@description('App Service Plan resource ID')
param appServicePlanId string

@description('Node.js runtime version')
param nodeVersion string

@description('Environment name')
param environment string

// Web App resource
resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: name
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: 'NODE|${nodeVersion}'
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'ENABLE_ORYX_BUILD'
          value: 'true'
        }
        {
          name: 'NODE_ENV'
          value: environment == 'prod' ? 'production' : 'development'
        }
      ]
      alwaysOn: environment == 'prod' ? true : false
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      http20Enabled: true
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 35
    }
    httpsOnly: true
    clientAffinityEnabled: false
  }
  tags: {
    Environment: environment
    Application: 'Node.js Express Server'
  }
}

// Optional: Application Insights (uncomment if needed)
/*
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${name}-insights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtension'
  }
  tags: {
    Environment: environment
  }
}

// Add Application Insights connection string to app settings
resource webAppInsightsConfig 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: webApp
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.properties.ConnectionString
  }
}
*/

// Outputs
output id string = webApp.id
output name string = webApp.name
output url string = 'https://${webApp.properties.defaultHostName}'
output principalId string = webApp.identity.principalId
