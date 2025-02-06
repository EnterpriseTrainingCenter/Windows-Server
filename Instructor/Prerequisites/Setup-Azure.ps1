[CmdletBinding()]
param (
    [string]
    $CsvPath,
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

if ([string]::IsNullOrEmpty($CsvPath)) {
    $CsvPath = (Join-Path -Path $PSScriptRoot -ChildPath 'users.csv')
}
    

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

# Prepare an array to store the results
$results = @()

#region Create or reset users in the Entra ID tenant

Connect-MgGraph `
    -Scopes "User.ReadWrite.All", 'UserAuthenticationMethod.ReadWrite.All'

#region List the domains in the Entra ID tenant
$domains = Get-MgDomain
$domainMenu = for ($i = 0; $i -lt $domains.Count; $i++) {
    $domains[$i] | Select-Object @{ Name = "#"; Expression = { $i } }, Id
}
$domainMenu | Format-Table
#endregion List the domains in the Entra ID tenant

# Ask the user which domain to use
$domainIndex = Read-Host "Enter the # of the domain to use for creating users"
$domain = $domains[$domainIndex].Id

# Create or reset the users
foreach ($user in $users) {
    $userPrincipalName = "$($user.UserName)@$domain"
    $mgUser = Get-MgUser -Filter "userPrincipalName eq '$userPrincipalName'"

    # If user found, update the display name and reset authentication
    if ($null -ne $mgUser) {
        Write-Host "Updating display name for $userPrincipalName"
        Update-MgUser -UserId $mgUser.Id -DisplayName $user.DisplayName

        #region Reset the password
        Write-Host "Resetting password for $userPrincipalName"
        $authenticationMethodId = (
            Get-MgUserAuthenticationPasswordMethod -UserId $mgUser.Id).Id
        $newPassword = (
            Reset-MgUserAuthenticationMethodPassword `
                -UserId $mgUser.Id `
                -AuthenticationMethodId $authenticationMethodId
        ).NewPassword
        #endregion Reset the password

        #region Remove authentication methods other than password to reset MFA

        Write-Host "Resetting MFA for $userPrincipalName"
        $authenticationMethodId = Get-MgUserAuthenticationEmailMethod `
            -UserId $mgUser.Id
        if ($authenticationMethodId) {
            Remove-MgUserAuthenticationEmailMethod `
                -UserId $mgUser.Id `
                -EmailAuthenticationMethodId $authenticationMethodId
        }

        $authenticationMethodId = Get-MgUserAuthenticationFido2Method `
            -UserId $mgUser.Id
        if ($authenticationMethodId) {
            Remove-MgUserAuthenticationFido2Method `
                -UserId $mgUser.Id `
                -Fido2AuthenticationMethodId $authenticationMethodId
        }

        $authenticationMethodId = Get-MgUserAuthenticationPhoneMethod `
            -UserId $mgUser.Id
        if ($authenticationMethodId) {
            Remove-MgUserAuthenticationPhoneMethod `
                -UserId $mgUser.Id `
                -PhoneAuthenticationMethodId $authenticationMethodId
        }

        $authenticationMethodId = `
            Get-MgUserAuthenticationMicrosoftAuthenticatorMethod `
                -UserId $mgUser.Id
        if ($authenticationMethodId) {
            Remove-MgUserAuthenticationMicrosoftAuthenticatorMethod `
                -UserId $mgUser.Id `
                -MicrosoftAuthenticatorAuthenticationMethodId `
                    $authenticationMethodId
        }

        $authenticationMethodId = Get-MgUserAuthenticationPhoneMethod `
            -UserId $mgUser.Id
        if ($authenticationMethodId) {
            Remove-MgUserAuthenticationPhoneMethod `
                -UserId $mgUser.Id `
                PhoneAuthenticationMethodId $authenticationMethodId
        }

        $authenticationMethodId = `
            Get-MgUserAuthenticationWindowsHelloForBusinessMethod `
                -UserId $mgUser.Id
        if ($authenticationMethodId) {
                Remove-MgUserAuthenticationWindowsHelloForBusinessMethod `
                    -UserId $mgUser.Id `
                    -WindowsHelloForBusinessAuthenticationMethodId `
                    $authenticationMethodId  
        }

        $authenticationMethodId = Get-MgUserAuthenticationSoftwareOathMethod `
            -UserId $mgUser.Id
        if ($authenticationMethodId) {
            Remove-MgUserAuthenticationSoftwareOathMethod `
                -UserId $mgUser.Id `
                -SoftwareOathAuthenticationMethodId $authenticationMethodId
        }

        $authenticationMethodId = `
            Get-MgUserAuthenticationTemporaryAccessPassMethod -UserId $mgUser.Id
        if ($authenticationMethodId) {
            Remove-MgUserAuthenticationTemporaryAccessPassMethod `
                -UserId $mgUser.Id `
                -TemporaryAccessPassAuthenticationMethodId `
                    $authenticationMethodId
        }

        #endregion Remove authentication methods other than password to reset MFA

    }

    # If user not found, create a new user
    if ($null -eq $mgUser) {
        Write-Host "Creating user $userPrincipalName"
        
        <#
            Generate a random password consisting of 1 uppercase letter, 
            2 lowercase letters, and 5 digits
        #>
        $newPassword = `
            (
                -join (
                    (65..91) |
                    Get-Random -Count 1 |
                    ForEach-Object { [char] $PSItem }
                )
            ) + `
            (
                -join (
                    (97..122) |
                    Get-Random -Count 2 |
                    ForEach-Object { [char] $PSItem }
                ) 
            )+
            (
                -join (
                    (48..57) |
                    Get-Random -Count 5 |
                    ForEach-Object { [char] $PSItem }
                )
        )
        $passwordProfile = @{
            Password = $newPassword
            ForceChangePasswordNextSignIn = $false
        }

        # Create the user
        $mgUser = New-MgUser `
            -DisplayName $user.DisplayName `
            -UserPrincipalName $userPrincipalName `
            -MailNickname $user.UserName `
            -PasswordProfile $passwordProfile `
            -AccountEnabled
    }

    # Add the result to the array
    $user.NewPassword = $newPassword
    $user.UserPrincipalName = $userPrincipalName
    $results += $user
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph

#endregion Create or reset users in the Entra ID tenant

#region Add the users to the global administrator role in their tenants

$users = $results
$results = @()


#region Get a list of tenants

Connect-AzAccount
$azTenants = Get-AzTenant
Disconnect-AzAccount

#endregion Get a list of tenants

# Invite the users to their tenants and add them the Global Administrator role
foreach ($user in $users) {
    # Find the tenant ID of the users domain
    $azTenant = $azTenants | Where-Object { $user.Domain -in $PSItem.Domains }

    # Connect to Microsoft Graph
    Write-Host "Connecting to Microsoft Graph in tenant $($user.Domain)"
    Connect-MgGraph `
        -TenantId $azTenant.Id `
        -Scopes 'User.Invite.All', 'RoleManagement.ReadWrite.Directory'

    # Invite the user
    Write-Host `
        "Inviting user $($user.UserPrincipalName) to tenant $($user.Domain)"
    $invitation = New-MgInvitation `
        -InvitedUserEmailAddress $user.UserPrincipalName `
        -InviteRedirectUrl 'https://myapplications.microsoft.com' `
        -SendInvitationMessage:$false

    #region Assign the Global Administrator role to the invited user
    $roleDefinition = Get-MgDirectoryRole | 
        Where-Object { $_.DisplayName -eq "Global Administrator" }

    if ($roleDefinition) {
        $directoryRoleMember = Get-MgDirectoryRoleMember `
            -DirectoryRoleId $roleDefinition.Id `
            -Filter "Id eq '$($invitation.InvitedUser.Id)'"

        if ($null -eq $directoryRoleMember) {
            Write-Host `
                "Assigning the Global Administrator role to $(
                    $user.UserPrincipalName
                )"
            New-MgDirectoryRoleMemberByRef `
                -DirectoryRoleId $roleDefinition.Id `
                -BodyParameter @{
                    '@odata.id' = `
                        "https://graph.microsoft.com/v1.0/directoryObjects/$(
                            $invitation.InvitedUser.Id
                        )"
                }
        }
    }
    #endregion Assign the Global Administrator role to the invited user

    # Add the invitation redeem URL to the results
    $user.InvitationRedeemUrl = $invitation.InvitationRedeemUrl
    $results += $user

    # Disconnect from Microsoft Graph
    Disconnect-MgGraph
}

# Write back the results to the CSV file
$results | Export-Csv `
    -Path $csvPath -NoTypeInformation -Delimiter $Delimiter -Encoding $Encoding
Write-Host "Results written to $csvPath"
