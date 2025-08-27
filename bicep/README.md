

### 2. Install Azure PowerShell (if using PowerShell script)
```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```

### 🚀 **1. Create a Resource Group**

Creates a new Azure resource group in **Canada Central**.

```powershell
New-AzResourceGroup -Name "rg-portal-js-jagz" -Location "Canada Central"
```

---

### 📦 **2. Deploy Bicep Template**

Deploys your infrastructure using the specified **Bicep file** and **parameter file**.

```powershell
New-AzResourceGroupDeployment -ResourceGroupName "rg-portal-js-jagz" `
  -TemplateFile "main.bicep" -TemplateParameterFile "main.bicepparam"
```

---

### 🗑️ **3. Delete the Resource Group (No Prompt)**

Deletes the resource group and all its resources **without confirmation**.

```powershell
Remove-AzResourceGroup -Name "rg-portal-js-jagz" -Force
```

---

### 🛡️ **Optional: Preview Deletion (Dry Run)**

Shows what would be deleted, **without actually deleting anything**.

```powershell
Remove-AzResourceGroup -Name "rg-portal-js-jagz" -WhatIf
```

---