# Generating the KDS root key

1. Open a terminal.
1. In Terminal, verify if the KDS root key exists.

    ````powershell
    Get-KdsRootKey
    ````

1. If there is no KDS root key, generate it.

    ````powershell
    Add-KdsRootKey –EffectiveTime (Get-Date).AddHours((-10))
    ````

    *Note:* In a real-world scenario, it is recommended to not use the ```-EffectiveTime```parameter. Instead, after generating the KDS root key, wait for at least 10 hours before proceeding.

1. Verify the KDS root key again.

    ````powershell
    Get-KdsRootKey
    ````

## References

[Create a Key Distribution Service (KDS) root key](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key)