# Migrating a service account to a dMSA

1. Open a terminal.
1. Start the migration from the superseded account to the dMSA.

    ````powershell
    $identity = '' # Insert the DN of the dMSA
    $supersededAccount = '' # Insert the DN of the superseded account

    Start-ADServiceAccountMigration `
        -Identity $identity -SupersededAccount $supersededAccount
    ````

1. Verify the properties **msDS-DelegatedMSAState** and **msDS-ManagedAccountPrecededByLink** of the dMSA.

    ````powershell
    Get-ADServiceAccount `
        -Identity $identity `
        -Properties msDS-DelegatedMSAState, msDS-ManagedAccountPrecededByLink
    ````

    msDS-DelegatedMSAState should be 1. msDS-ManagedAccountPrecededByLink should contain the DN of the superseded account.

1. Verify the properties **msDS-SupersededServiceAccountState** and **msDS-SupersededManagedAccountLink** of the superseded account.

    ````powershell
    Get-ADUser `
        -Identity $supersededAccount `
        -Properties `
            msDS-SupersededServiceAccountState, `
            msDS-SupersededManagedAccountLink
    ````

    msDS-SupersededServiceAccountState should be 1. msDS-SupersededManagedAccountLink should contain the DN of the dMSA.

1. Restart the service, which should use the dMSA.

    [Managing services](./Managing-services.md)

1. Complete the account migration from the account.

    ````powershell
    Complete-ADServiceAccountMigration `
        -Identity $identity -SupersededAccount $supersededAccount
    ````

1. Verify the property **msDS-DelegatedMSAState** of the dMSA.

    ````powershell
    Get-ADServiceAccount -Identity $identity -Properties msDS-DelegatedMSAState
    ````

    msDS-DelegatedMSAState should be 2.

1. Verify the property **msDS-SupersededServiceAccountState** of the superseded service account.

    ````powershell
    Get-ADUser `
        -Identity $supersededAccount `
        -Properties msDS-SupersededServiceAccountState
    ````

1. Disable the superseded service account.

    ````powershell
    Disable-ADAccount -Identity $supersededAccount
    ````

1. Restart the service, which should use the dMSA again.

    [Managing services](./Managing-services.md)

    This is not necessary, but we want to check, if the service still starts.

1. Reset the password of the old service account.

    ````powershell
    Set-ADAccountPassword -Identity $supersededAccount -Reset
    ````

1. At the prompts **Password** and **Repeat Password**, enter a new secure password.

## References

[Setting up delegated Managed Service Accounts
](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/delegated-managed-service-accounts/delegated-managed-service-accounts-set-up-dmsa)