[CmdletBinding()]
param (
    [string]
    $CsvPath = (Join-Path -Path $PSScriptRoot -ChildPath 'users.csv'),
    [char]
    $Delimiter = ';',
    [ValidateSet(
        'ascii',
        'ansi',
        'bigendianunicode',
        'bigendianutf32',
        'oem',
        'unicode',
        'utf7',
        'utf8',
        'utf8BOM',
        'utf8NoBom',
        'utf32'
    )]
    [string]
    $Encoding = 'default'
)
    

#region Install required modules
# Install the Microsoft.Graph module if not already installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module -Name Microsoft.Graph -Scope CurrentUser -Force
}

# Install the Azure module (Az) if not already installed
if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Install-Module -Name Az -Scope CurrentUser -Force
}
#endregion Install required modules

# Read user names from a CSV
$users = Import-Csv -Path $CsvPath -Delimiter $Delimiter -Encoding $Encoding

#region Get a list of tenants

Connect-AzAccount
$azTenants = Get-AzTenant
Disconnect-AzAccount

#endregion Get a list of tenants

# Clear the Entra tenants
foreach ($user in $users) {
    # Find the tenant ID of the users domain
    $azTenant = $azTenants | Where-Object { $user.Domain -in $PSItem.Domains }

    if ($null -ne $azTenant) {
        # Connect to Microsoft Graph
        Write-host "Connecting to Microsoft Graph in tenant $($user.Domain)"
        Connect-MgGraph `
            -TenantId $azTenant.Id `
            -Scopes @(
                'User.Read.All'
                'User.DeleteRestore.All'
                'Application.ReadWrite.All'
            )

        # Get the current user
        $currentUserPrincipalName = (
            Invoke-MgGraphRequest `
                -Method GET https://graph.microsoft.com/v1.0/me
        ).userPrincipalName

        #region Remove all users except the current user

        Get-MgUser -All |
        Where-Object { 
            $PSItem.UserPrincipalName -ne $currentUserPrincipalName 
        } |
        ForEach-Object { 
            Write-Host "Removing user $($PSItem.UserPrincipalName)"
            Remove-MgUser -UserId $PSItem.Id
        }
        
        #endregion Remove all users except the current user

        #region Remove all service principals and applications

        Get-MgServicePrincipal | ForEach-Object {
            Write-Host "Removing service principal $($PSItem.DisplayName)"
            Remove-MgServicePrincipal `
                -ServicePrincipalId $PSItem.Id -ErrorAction SilentlyContinue 
        }

        Get-MgServicePrincipal | ForEach-Object { 
            Write-Host "Disabling service principal $($PSItem.DisplayName)"
            Update-MgServicePrincipal `
                -ServicePrincipalId $_.Id `
                -BodyParameter @{ "accountEnabled" = "false" } `
                -ErrorAction SilentlyContinue
        }

        Get-MgApplication |
        ForEach-Object { 
            Write-Host "Removing application $($PSItem.DisplayName)"
            Remove-MgApplication -ApplicationId $PSItem.Id
        }


        #endregion Remove all service principals and applications


        # Disconnect from Microsoft Graph
        Disconnect-MgGraph
    }
}
