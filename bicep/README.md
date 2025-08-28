## 🔹 Step 1: Install Azure PowerShell (if using PowerShell script)

```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```

---

## 🔹 Step 2: Configure Service Connection & Permissions

1. **Create an OIDC Service Connection** (recommended) from **Project Settings** in Azure DevOps.
2. **Assign RBAC permissions** (Contributor role) to the service connection.

Retrieve the service principal details:

```powershell
Get-AzADServicePrincipal -ApplicationId <APP_ID_FROM_SERVICE_CONNECTION>
```

Example output:

```text
DisplayName : <service connection name>
Id          : 0bfe1352-e0c0-4b6f-ba20-19fce1aedc16   <-- Use this value for -ObjectId
AppId       : 11111111-2222-3333-4444-555555555555
```

⚠️ **Important:** Use the **Id** (not AppId) when assigning roles.

Assign Contributor role at the subscription level:

```powershell
New-AzRoleAssignment `
  -ObjectId <SP_OBJECT_ID> `
  -RoleDefinitionName "Contributor" `
  -Scope "/subscriptions/b806251a-5643-4df5-9e3b-cc2781372122"
```

Example:

```powershell
New-AzRoleAssignment `
  -ObjectId 0bfe1352-e0c0-4b6f-ba20-19fce1aedc16 `
  -RoleDefinitionName "Contributor" `
  -Scope "/subscriptions/b806251a-5643-4df5-9e3b-cc2781372122"
```

✅ Your service connection now has the correct RBAC permissions.
The pipeline can create resource groups and deploy your Bicep templates without permission issues.

---

## 🔹 Step 3: Manage Resources with PowerShell

### 🚀 Create a Resource Group

Creates a new resource group in **Canada Central**:

```powershell
New-AzResourceGroup -Name "rg-portal-js-jagz" -Location "Canada Central"
```

---

### 📦 Deploy Bicep Template

Deploy infrastructure using a Bicep template and parameter file:

```powershell
New-AzResourceGroupDeployment -ResourceGroupName "rg-portal-js-jagz" `
  -TemplateFile "main.bicep" `
  -TemplateParameterFile "main.bicepparam"
```

---

### 🗑️ Delete a Resource Group (No Prompt)

Deletes the resource group and all resources **without confirmation**:

```powershell
Remove-AzResourceGroup -Name "rg-portal-js-jagz" -Force
```

---

### 🛡️ Optional: Preview Deletion (Dry Run)

See what would be deleted, **without actually deleting anything**:

```powershell
Remove-AzResourceGroup -Name "rg-portal-js-jagz" -WhatIf
```

---

