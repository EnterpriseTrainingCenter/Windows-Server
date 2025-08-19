# Lab: Deploying domain controllers

## Required VMs

* VN1-SRV1
* VN1-SRV4
* VN1-SRV5
* VN2-SRV1
* VN2-SRV2
* CL1
* CL3

## Setup

1. On **CL1**, sign in as **ad\\Administrator**.
1. On **CL3**, sign in as **.\\Administrator**.
1. On **VN1-SRV1**, sign in as **ad\\Administrator**.
1. On **VN1-SRV5**, sign in as **ad\\Administrator**.
1. On **VN2-SRV2** sign in as **.\\Administrator**.

You must have completed the practice [Explore Server Manager](../Practices/Explore-Server-Manager.md). If you skipped the practice, on **CL1**, in Terminal, run ````C:\LabResources\Solutions\Add-ServerManagerServers.ps1````.

You must have completed the practice [Install Windows Admin Center using a script](../Practices/Install-Windows-Admin-Center-using-a-script.md). If you skipped the practice, on **VN1-SRV4**, sign in as **ad\Administrator**, and run ````C:\LabResources\Solutions\Install-AdminCenter.ps1````.

## Introduction

The domain controller still running Windows Server 2022 must be replaced by a Windows Server 2025 domain controller. Moreover, Adatum is expanding to a new location. An additional domain controller must be installed at the new location. Furthermore, Adatum launches a new subsidiary with the name Contoso. Because it is expected, that the subsidiary will be sold soon, a new forest needs to be created for the subsidiary.

## Exercises

1. [Deploy additional domain controllers](#exercise-1-deploy-additional-domain-controllers)
1. [Check domain controller health](#exercise-2-check-domain-controller-health)
1. [Transfer flexible single master operation roles](#exercise-3-transfer-flexible-single-master-operation-roles)
1. [Decommission a domain controller](#exercise-4-decommission-a-domain-controller)
1. [Raise domain and forest functional level](#exercise-5-raise-the-domain-and-forest-functional-level)
1. [Enable database 32K pages](#exercise-6-enable-database-32k-pages)
1. [Deploy a new forest](#exercise-7-deploy-a-new-forest)

Note: Exercise 6 is not dependent on the other exercises. To safe time, you may run the tasks of exercise 6 while you are waiting for execution of tasks in the other exercises.

## Exercise 1: Deploy additional domain controllers

1. On CL1 install the optional feature **RSAT: DNS Server Tools** (```Rsat.Dns.Tools```).

    You do not need to wait for the installation to complete.

    [Installing optional features on Windows 11](../General/Installing-optional-features-on-Windows-11.md)

1. On CL1, disable the network adapters **SAN1**, **SAN2**, and **CLST1** on **VN1-SRV5**.

   [Enabling or disabling network adapters](../General/Enabling-or-disabling-network-adapters.md) 

1. On VN1-SRV5 and VN2-SRV1, configure the network profile type for the connection **VNet1** or **Ethernet** as **Private network** on **VN1-SRV5** and **VN2-SRV1**. 

    [Configuring the network profile type](../General/Configuring-the-network-profile-type.md)

1. On CL1, install the role **Active Directory Domain Services** (```AD-Domain-Services```) on **VN1-SRV5** and **VN2-SRV1**.

    [Installing roles and features on Windows Server](../General/Installing-roles-and-features-on-Windows-Server.md)

1. Configure Active Directory Domain Services as additional domain controller

    * Computername: **VN1-SRV5**, **VN2-SRV1**
    * Domain **ad.adatum.com**
    * **DNS server**
    * **Global Catalog** at the same time
    * Do not update the DNS delegation (this is not possibly anyways, ignore the warning)

    Leave all other parameters as default. If you want to use PowerShell, you may perform this task on either VN1-SRV5 and VN2-SRV1 locally or from CL1 remotely.

    *Note:* In a real-world scenario it is recommended to save the database and logs to a separate volume with host-based write-back caching disabled.

    [Configuring Active Directory Domain Services as an additional Domain Controller](../General/Configuring-Active-Directory-Domain-Services-as-an-additional-domain-controller.md)

1. On CL1, configure the forwarders of the DNS Server on **VN1-SRV5** and **VN2-SRV1** to **8.8.8.8** and **8.8.4.4**. Other forwarders should be deleted.

    [Configuring forwarders](../General/Configuring-forwarders.md)

1. On CL1 or, if you want to use SConfig, on VN1-SRV5 configure the DNS client settings for VN1-SRV5 as follows:

    Preferred DNS server: 10.1.2.8 (VN1-SRV2)
    Secondary DNS server: 127.0.0.1

    ````powershell
    $serverAddresses = '10.1.2.8', '127.0.0.1'
    ````

    [Changing TCP/IP settings on Windows Server](../General/Changing-TCP-IP-settings-on-Windows-Server.md)

## Exercise 2: Check domain controller health

1. On CL1, list the resource records in the zones **_msdcs.ad.adatum.com** and **ad.adatum.com** on VN1-SRV5.

    In _msdcs.ad.adatum.com, there should be three CNAME records pointing to VN1-SRV1.ad.adatum.com, VN1-SRV5.ad.adatum.com, and VN2-SRV1.ad.adatum.com. Moreover, there should be several SRV records in the sub-domains dc, domains, gc, and pdc pointing to all three domain controllers.

    In ad.adatum.com, under _tcp, there should 12 SRV records for the services \_gc, \_kerberos, \_kpasswd, and \_ldap, pointing to VN1-SRV1.ad.adatum.com, VN1-SRV5.ad.adatum.com, and VN2-SRV1.ad.adatum.com.

    If any records, are missing, wait for at least 15 minutes and check again. If the problem persists, ask the instructor.

    [Managing resource records](../General/Managing-resource-records.md)

1. On CL1, verify that the shares **NETLOGON** and **SYSVOL** are present on **VN1-SRV5** and **VN2-SRV1**.

    [Managing shares](../General/Managing-shares.md)

1. On CL1, run the Best Practices Analyzer for **DNS** (```Microsoft/Windows/DNSServer```) and **AD DS** (```Microsoft/Windows/DirectoryServices```) on **VN1-SRV5** and **VN2-SRV1**.

    Review any warnings or errors, if present. If time permits, you can try to fix the warning and errors and run the the BPA scan again.

    [Running Best Practices Analyzer scans and managing scan results](../General/Running-Best-Practices-Analyzer-and-managing-scan-results.md)

## Exercise 3: Transfer flexible single master operation roles

1. On CL1, transfer the **RID master**, **PDC emulator** and **Infrastructure master** roles to **VN1-SRV5**.

    [Transferring flexible single master operation roles](../General/Transferring-flexible-single-master-operation-roles.md)

1. On CL1, transfer the **Domain Naming master** and the **Schema master** role to **VN1-SRV5**.

    [Transferring flexible single master operation roles](../General/Transferring-flexible-single-master-operation-roles.md)

## Exercise 4: Decommission a domain controller

1. On CL1, change the DNS client server addresses to 10.1.1.40.

    [Changing TCP/IP settings on Windows 11](../General/Changing-TCP-IP-settings-on-Windows-11.md)

1. On CL1, add the IP address  **10.1.1.9** to the interface **Ethernet** on **VN1-SRV1**. You need to use PowerShell for this task.

    ````powershell
    $computerName = 'VN1-SRV1'
    $interfaceAlias = 'Ethernet'
    $ipAddress = '10.0.0.9'
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

1. Change the DNS client settings on **VN1-SRV1** to **10.1.1.40** as the primary DNS server and **10.1.2.8** as the secondary DNS Server.

    ````powershell
    $computerName = 'VN1-SRV1'
    $interfaceAlias = 'Ethernet'
    $severAddresses = '10.1.1.40', '10.1.2.8'
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

1. Demote **VN1-SRV1** as domain controller.

    [Demoting a domain controller](../General/Demoting-a-domain-controller.md)

1. On CL1, remove the roles **Active Directory Domain Services** (```AD-Domain-Services```), **DNS Server** (```DNS```), and **File Server** (```FS-FileServer```) from VN1-SRV1.

    [Removing roles and features on Windows Server](../General/Removing-roles-and-features-on-Windows-Server.md)

## Exercise 5: Raise the domain and forest functional level

1. On CL1, raise the domain functional level of **ad.adatum.com**.

    [Raising the domain functional level](../General/Raising-the-domain-functional-level.md)

1. On CL1, raise the forest functional level of **ad.adatum.com**.

    [Raising the forest functional level](../General/Raising-the-forest-functional-level.md)

## Exercise 6: Enable database 32K pages

1. On CL1, verify the that the domain **DC=ad, DC=adatum, DC=com** has a 32k page capable database.

    [Verifying a 32k page capable database](../General/Verifying-a-32k-page-capable-database.md)

1. On CL1, enable the Database 32k pages optional feature in the domain **ad.adatum.com** on server **VN1-SRV5**.

    [Enabling the Database 32k pages option](../General/Enabling-the-Database-32k-pages-option.md)

## Exercise 7: Deploy a new forest

1. On CL1, install the role **Active Directory Domain Services** (```AD-Domain-Services```) on **VN2-SRV2**.

    [Installing roles and features on Windows Server](../General/Installing-roles-and-features-on-Windows-Server.md)

1. Configure Active Directory Domain Services as a new forest

    * Computername: **VN2-SRV2**
    * Root domain name: **ad.contoso.com**
    * **DNS server**
    * NetBIOS domain name: **CONTOSO**
    * Do not update the DNS delegation (this is not possibly anyways, ignore the warning)

    Leave all other parameters as default.

    *Note:* In a real-world scenario it is recommended to save the database and logs to a separate volume with host-based write-back caching disabled.

    [Configuring Active Directory Domain Services as a new forest](../General/Configuring-Active-Directory-Domain-Services-as-a-new-forest.md)

1. On VN2-SRV2, configure the forwarders of the DNS Server to **8.8.8.8** and **8.8.4.4**. Other forwarders should be deleted.

    [Configuring forwarders](../General/Configuring-forwarders.md)

1. On CL3, change the DNS client server addresses to **10.1.2.16**.

    [Changing TCP/IP settings on Windows 11](../General/Changing-TCP-IP-settings-on-Windows-11.md)

1. Join CL3 to the domain **ad.contoso.com**.

    [Joining Windows 11 to a local Active Directory domain](../General/Joining-Windows-11-to-a-local-Active-Directory-domain.md)
