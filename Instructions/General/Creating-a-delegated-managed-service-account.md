# Creating a delegated managed service account

1. Open a terminal.
1. Create a delegated managed service account.

    ```powershell
    $name = '' # Between the quotes, insert the name of the account
    <# 
        Between the quotes, insert the distinguished name of the OU where the 
        account should be created.
    #>
    $path = ''

    <#
        Between the quotes, insert the FQDN of the server, where the service
        using the delegated managed service account, runs.
    #>
    $dNSHostName = ''

    New-ADServiceAccount `
        -Path $path `
        -Name $name `
        -DNSHostName $dNSHostName `
        -CreateDelegatedServiceAccount `
        -KerberosEncryptionType AES256
    ````

## References

[Setting up delegated Managed Service Accounts](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/delegated-managed-service-accounts/delegated-managed-service-accounts-set-up-dmsa)