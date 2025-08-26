Here's how to create an Azure Web App using Bicep with modules:## Installation Requirements

Before using these Bicep templates, make sure you have:

### 1. Install Bicep CLI
```powershell
# Via Azure CLI
az bicep install

# Or via PowerShell
winget install Microsoft.Bicep
```

### 2. Install Azure PowerShell (if using PowerShell script)
```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```

## Key Features of This Bicep Solution

1. **Modular Design**: Separates App Service Plan and Web App into reusable modules
2. **Environment Support**: Supports dev/staging/prod environments
3. **Best Practices**: Includes security settings, HTTPS-only, proper tagging
4. **Node.js 18 Configuration**: Pre-configured for your Node.js application
5. **Flexible Pricing**: Easy to change between Free, Basic, Standard tiers
6. **Automated Deployment**: PowerShell script handles the entire deployment process

## Quick Start

1. Create a folder structure as shown above
2. Copy the Bicep files into their respective locations
3. Customize the parameters in `main.bicepparam`
4. Run the deployment:

```powershell
.\deploy.ps1 -SubscriptionId "your-subscription-id" -ResourceGroupName "rg-portal-js-jagz"
```

