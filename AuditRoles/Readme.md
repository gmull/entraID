# Requirements


1. **Microsoft.Graph** - This module is required for interacting with Microsoft Graph in PowerShell. It includes commands like `Connect-MgGraph`, `Get-MgUser`, `Get-MgDirectoryRole`, and `Get-MgDirectoryRoleMember`.

2. **Microsoft.PowerShell.Management** - This module provides access to system management cmdlets, including `Get-Content`, which is used to read the configuration file.

To load these modules, you can add the following lines at the beginning of your script:

```powershell
# Import the Microsoft Graph PowerShell SDK
Import-Module Microsoft.Graph

# Import PowerShell Management module (if not loaded by default)
Import-Module Microsoft.PowerShell.Management
```

You’ll also need to ensure you have the necessary permissions in your Azure AD for the `RoleManagement.Read.Directory` and `Directory.Read.All` scopes, as specified in the `Connect-MgGraph` command. 

Let me know if you need further assistance with setting up Microsoft Graph in PowerShell!