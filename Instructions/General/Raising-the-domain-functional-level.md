# Raising the domain functional level

## Desktop experience

1. Open **Active Directory Administrative Center**.
1. In Active Directory Administrative Center, in the context-menu of the domain, click **Raise the domain functional level...**

1. In Raise domain function level, click **OK**.

1. In the message box This change affects the entire domain. After you raise the domain functional level, it is possible that you may not be able to reverse it., click **OK**.

1. In the message box Raise Domain Functional Level, click **OK**.

## PowerShell

1. Open a terminal.
1. Set the domain mode to Windows Server 2025.

    ````powershell
    # Between the quotes, insert the FQDN name of the domain
    $identity = ''
    Set-ADDomainMode -Identity $identity -DomainMode Windows2025Domain
    ````

    If you receive an error message **Set-ADDomainMode : A referral was returned from the server**, restart the domain controller and try again.

    ````powershell
    $computerName = '' # Insert the name of the DC
    Restart-Computer -ComputerName $computerName -WsmanAuthentication Default
    ````

1. At the prompt **Performing the operation "Set" on target ...**, enter **y**.
