New-AzResourceGroup -Name "rg-portal-js-jagz" -Location "Canada Central"


New-AzResourceGroupDeployment -ResourceGroupName "rg-portal-js-jagz" -TemplateFile "simple-webapp.bicep"


Remove-AzResourceGroup -Name "rg-portal-js-jagz"