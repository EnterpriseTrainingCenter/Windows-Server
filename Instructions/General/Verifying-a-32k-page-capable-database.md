# Verifying a 32k page capable database

1. Open a terminal.
1. Verify the msDs-JetDBpageSize property.

    ````powershell

    <#
        Between the quotes, insert the DN of the domain, e.g.,
        DC=ad, DC=adatum, DC=com
    #>
    $domainDN = ''

    Get-ADObject `
        -LDAPFilter '(ObjectClass=nTDSDSA)' `
        -SearchBase "CN=Configuration,$domainDN" `
        -Properties msDS-JetDBPageSize |
    Format-List distinguishedName, msDs-JetDBPageSize
    ````

    msDs-JetDBPageSize should be 32768.
