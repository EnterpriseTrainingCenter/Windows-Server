# Lab: Finalizing Active Directory upgrade

## Required VMs

* VN1-SRV1
* VN1-SRV4
* VN1-SRV5
* VN2-SRV1
* CL1

## Setup

1. On **CL1**, sign in as **ad\\Administrator**.
1. On **VN1-SRV1**, sign in as **ad\\Administrator**.
1. On **VN1-SRV5**, sign in as **ad\\Administrator**.

You must have completed the lab [Deploying domain controllers](../Labs/Deploying-domain-controllers.md). If you skipped the practice, on **CL1**, in Terminal, run ````C:\LabResources\Solutions\Install-DomainControllers.ps1````. However, be aware that this script may need some time to complete and you need to wait at least one hour after running the script before proceeding with this lab.

You must have completed the practice [Install Windows Admin Center using a script](../Practices/Install-Windows-Admin-Center-using-a-script.md). If you skipped the practice, on **VN1-SRV4**, sign in as **ad\Administrator**, and run ````C:\LabResources\Solutions\Install-AdminCenter.ps1````.

## Introduction

After deploying the new domain controllers running the latest version of Windows Server, you want to decommission the old domain controller, raise the domain and forest functional level and enable support for 32K database pages.

## Exercises

1. [Decommission a domain controller](#exercise-1-decommission-a-domain-controller)
1. [Raise domain and forest functional level](#exercise-2-raise-the-domain-and-forest-functional-level)
1. [Enable database 32K pages](#exercise-3-enable-database-32k-pages)

## Exercise 1: Decommission a domain controller

1. On CL1, change the DNS client server addresses to 10.1.1.40.

    ```powershell
    $interfaceAlias = 'Ethernet'
    $serverAddresses = '10.1.1.40'
    ```

    [Changing TCP/IP settings on Windows 11](../General/Changing-TCP-IP-settings-on-Windows-11.md)

1. On CL1, add the IP address  **10.1.1.9** to the interface **Ethernet** on **VN1-SRV1**. You need to use PowerShell for this task.

    ````powershell
    $computerName = 'VN1-SRV1'
    $interfaceAlias = 'Ethernet'
    $ipAddress = '10.1.1.9'
    $prefixLength = 24
    ````

    [Changing TCP/IP settings on Windows Server](../General/Changing-TCP-IP-settings-on-Windows-Server.md)

1. On CL1, remove the IP address  **10.1.1.8** from the interface **Ethernet** on **VN1-SRV1**.

    ````powershell
    $computerName = 'VN1-SRV1'
    $interfaceAlias = 'Ethernet'
    $ipAddress = '10.1.1.8'
    $prefixLength = 24
    ````

    [Changing TCP/IP settings on Windows Server](../General/Changing-TCP-IP-settings-on-Windows-Server.md)

1. On CL1, add the IP address **10.1.1.8** to the interface **VNet1** on **VN1-SRV5**. You need to use PowerShell for this task to leave the old IP address operational.

    ````powershell
    $computerName = 'VN1-SRV5'
    $interfaceAlias = 'VNet1'
    $ipAddress = '10.1.1.8'
    $prefixLength = 24
    ````

    [Changing TCP/IP settings on Windows Server](../General/Changing-TCP-IP-settings-on-Windows-Server.md)

    Note: In this exercise, we add the IP address of the decommissioned domain controller to the new domain controller, so we do not have to reconfigure the DNS client settings on the other computers on the network. If all computers use DHCP, you could reconfigure the DHCP option DNS server instead. You would do this before task 1 and then wait for the DHCP lease period to expire before proceeding. Moreover, you would skip tasks 2 and 3.

1. On CL1, clear the DNS client cache.

    ````powershell
    Clear-DnsClientCache
    ````

1. Demote **VN1-SRV1** as domain controller.

    [Demoting a domain controller](../General/Demoting-a-domain-controller.md)

    If you have trouble demoting the domain controller, wait for at least 15 minutes and try again.

1. On CL1, remove the roles **Active Directory Domain Services** (```AD-Domain-Services```), **DNS Server** (```DNS```), and **File Server** (```FS-FileServer```) from VN1-SRV1.

    [Removing roles and features on Windows Server](../General/Removing-roles-and-features-on-Windows-Server.md)

## Exercise 2: Raise the domain and forest functional level

1. On CL1, raise the domain functional level of **ad.adatum.com**.

    [Raising the domain functional level](../General/Raising-the-domain-functional-level.md)

1. On CL1, raise the forest functional level of **ad.adatum.com**.

    [Raising the forest functional level](../General/Raising-the-forest-functional-level.md)

## Exercise 3: Enable database 32K pages

1. On CL1, verify the that the domain **DC=ad, DC=adatum, DC=com** has a 32k page capable database.

    [Verifying a 32k page capable database](../General/Verifying-a-32k-page-capable-database.md)

1. On CL1, enable the Database 32k pages optional feature in the domain **ad.adatum.com** on server **VN1-SRV5**.

    [Enabling the Database 32k pages option](../General/Enabling-the-Database-32k-pages-option.md)