# Path to the configuration file
$configFilePath = "./config.json"  # Update with the actual path to your config file

# Load the configuration file
if (-Not (Test-Path -Path $configFilePath)) {
    Write-Output "Configuration file not found at $configFilePath."
    return
}

# Parse the JSON configuration file
$config = Get-Content -Path $configFilePath | ConvertFrom-Json

# Get the Tenant ID from the first entry (assuming all users are in the same tenant)
$TenantID = $config[0].TenantID

# Connect to Microsoft Graph for the specified tenant
Connect-MgGraph -Scopes "RoleManagement.Read.Directory", "Directory.Read.All" -TenantId $TenantID -NoWelcome

# Loop through each user in the configuration
foreach ($entry in $config) {
    # Get user info from the entry
    $userToCheck = $entry.UserPrincipalName

    Write-Output "`nChecking roles for user '$userToCheck' in tenant '$TenantID'..."

    # Get the user information
    $user = Get-MgUser -UserId $userToCheck

    if ($null -eq $user) {
        Write-Output "User '$userToCheck' not found in tenant '$TenantID'."
        continue
    }

    # Initialize an array to store assigned roles for this user
    $assignedRoles = @()

    # Get all active directory roles in the tenant
    $roles = Get-MgDirectoryRole

    # Loop through each active role to check if the user is a member
    foreach ($role in $roles) {
        # Check if the user is a member of this role
        $isMember = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id | Where-Object { $_.Id -eq $user.Id }

        # If the user is a member, add the role to the assigned roles array
        if ($isMember) {
            $assignedRoles += [PSCustomObject]@{
                RoleName       = $role.DisplayName
                RoleId         = $role.Id
            }
        }
    }

    # Output the list of roles assigned to the user
    if ($assignedRoles.Count -gt 0) {
        Write-Output "Roles assigned to user '$($user.DisplayName)' ($userToCheck):"
        $assignedRoles | Format-Table -AutoSize
    } else {
        Write-Output "No roles are assigned to user '$($user.DisplayName)' ($userToCheck)."
    }
}

# Disconnect from Microsoft Graph for the tenant
Disconnect-MgGraph | Out-Null
