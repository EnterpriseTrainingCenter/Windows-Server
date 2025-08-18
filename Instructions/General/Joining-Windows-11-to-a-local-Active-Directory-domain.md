# Joining Windows 11 to a local Active Directory domain

## Desktop experience

1. Open **Settings**.
1. In Settings, in the left pane, click **Accounts**.
1. In Accounts, click **Access work or school**.
1. In Access work or school, beside **Add a work or school account**, click **Connect**.
1. In Set up a work or school account, click the link **Join this device to a local Active Directory domain**.
1. In Join a domain, under **Domain name**, type the domain name and click **Next**.
1. In Windows Security, enter the credentials of a domain user.
1. In Add an account, click **Skip**.
1. In Restart your PC, click **Restart now**.

## PowerShell

Perform this task on CL3.

1. In the context menu of **Start**, click **Terminal (Admin)**.
1. Add the computer to the domain and restart it.

    ````powershell
    # Between the quotes, type the domain name
    $domainName = ''
    Add-Computer -DomainName $domainName -Restart
    ````

1. In **Windows PowerShell credential request**, enter the the credentials of a domain user.
