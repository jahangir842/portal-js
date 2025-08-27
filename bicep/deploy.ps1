# deploy.ps1 - Deployment script for Bicep templates

param(
    [Parameter(Mandatory=$false)]
    [string]$SubscriptionId = 'b806251a-5643-4df5-9e3b-cc2781372122',
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "rg-portal-js-jagz",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "Canada Central",
    
    [Parameter(Mandatory=$false)]
    [string]$Environment = "dev"
)

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "Starting Azure Web App deployment..." -ForegroundColor Green
Write-Host "Subscription ID: $SubscriptionId" -ForegroundColor Cyan
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Cyan
Write-Host "Location: $Location" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Cyan

# 1. Login to Azure (if not already logged in)
try {
    $context = Get-AzContext
    if (-not $context) {
        Write-Host "Logging in to Azure..." -ForegroundColor Yellow
        Connect-AzAccount
    }
} catch {
    Write-Host "Logging in to Azure..." -ForegroundColor Yellow
    Connect-AzAccount
}

# 2. Set the subscription context
Write-Host "Setting subscription context..." -ForegroundColor Yellow
Set-AzContext -SubscriptionId $SubscriptionId

# 3. Create Resource Group if it doesn't exist
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Host "Creating Resource Group: $ResourceGroupName" -ForegroundColor Green
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location
} else {
    Write-Host "Resource Group $ResourceGroupName already exists" -ForegroundColor Yellow
}

# 4. Validate the Bicep template
Write-Host "Validating Bicep template..." -ForegroundColor Yellow
try {
    $validationResult = Test-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile "main.bicep" `
        -TemplateParameterFile "main.bicepparam" `
        -Verbose

    if ($validationResult) {
        Write-Host "Template validation failed:" -ForegroundColor Red
        Write-Host "Error Details:" -ForegroundColor Red
        $validationResult | ForEach-Object { 
            Write-Host "Code: $($_.Code)" -ForegroundColor Red
            Write-Host "Message: $($_.Message)" -ForegroundColor Red
            Write-Host "Target: $($_.Target)" -ForegroundColor Red
            if ($_.Details) {
                Write-Host "Details:" -ForegroundColor Red
                $_.Details | ForEach-Object { Write-Host "  - $($_.Message)" -ForegroundColor Red }
            }
            Write-Host "---" -ForegroundColor Red
        }
        exit 1
    }
} catch {
    Write-Host "Validation error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "Template validation passed!" -ForegroundColor Green

# 5. Deploy the Bicep template
$deploymentName = "WebAppDeployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "Starting deployment: $deploymentName" -ForegroundColor Green
Write-Host "This may take a few minutes..." -ForegroundColor Yellow

try {
    $deployment = New-AzResourceGroupDeployment `
        -Name $deploymentName `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile "main.bicep" `
        -TemplateParameterFile "main.bicepparam" `
        -Verbose

    # 6. Display deployment results
    Write-Host "`n=== Deployment Completed Successfully! ===" -ForegroundColor Green
    Write-Host "Deployment Name: $deploymentName" -ForegroundColor Cyan
    Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Cyan
    
    # Display outputs
    if ($deployment.Outputs) {
        Write-Host "`n=== Deployment Outputs ===" -ForegroundColor Green
        foreach ($output in $deployment.Outputs.Keys) {
            $value = $deployment.Outputs[$output].Value
            Write-Host "$output : $value" -ForegroundColor Cyan
        }
    }

    # 7. Optional: Open the web app in browser
    if ($deployment.Outputs.webAppUrl) {
        $webAppUrl = $deployment.Outputs.webAppUrl.Value
        Write-Host "`nWeb App URL: $webAppUrl" -ForegroundColor Green
        Write-Host "Opening in browser..." -ForegroundColor Yellow
        Start-Process $webAppUrl
    }

} catch {
    Write-Host "`nDeployment failed:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Deployment Script Completed ===" -ForegroundColor Green