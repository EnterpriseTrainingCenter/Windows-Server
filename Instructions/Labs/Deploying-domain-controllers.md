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

You want to introduce new domain controllers to the domain running the latest version of Windows Server. Moreover, Adatum is expanding to a new location. An additional domain controller must be installed at the new location. Furthermore, Adatum launches a new subsidiary with the name Contoso. Because it is expected, that the subsidiary will be sold soon, a new forest needs to be created for the subsidiary.

## Exercises

1. [Deploy additional domain controllers](#exercise-1-deploy-additional-domain-controllers)
1. [Deploy a new forest](#exercise-2-deploy-a-new-forest)
1. [Check domain controller health](#exercise-3-check-domain-controller-health)
1. [Optimize DNS](#exercise-4-optimize-dns)
1. [Transfer flexible single master operation roles](#exercise-5-transfer-flexible-single-master-operation-roles)
1. [Join client to new forest](#exercise-6-join-client-to-new-forest)

## Exercise 1: Deploy additional domain controllers

1. On CL1 install the optional feature **RSAT: DNS Server Tools** (```Rsat.Dns.Tools```).

    You do not need to wait for the installation to complete.

    [Installing optional features on Windows 11](../General/Installing-optional-features-on-Windows-11.md)

1. On CL1, disable the network adapters **SAN1**, **SAN2**, and **CLST1** on **VN1-SRV5**.

   [Enabling or disabling network adapters](../General/Enabling-or-disabling-network-adapters.md) 

1. On CL1, install the role **Active Directory Domain Services** (```AD-Domain-Services```) on **VN1-SRV5** and **VN2-SRV1**.

    [Installing roles and features on Windows Server](../General/Installing-roles-and-features-on-Windows-Server.md)

1. Configure Active Directory Domain Services as additional domain controller. Start with VN1-SRV5. Then, continue to the next exercise. As soon as you finished the next exercise, repeat this task for VN2-SRV1.

    * Computername: **VN1-SRV5**, **VN2-SRV1**
    * Domain **ad.adatum.com**
    * **DNS server**
    * **Global Catalog** at the same time
    * Do not update the DNS delegation (this is not possibly anyways, ignore the warning)

    Leave all other parameters as default. If you want to use PowerShell, you may perform this task on either VN1-SRV5 and VN2-SRV1 locally or from CL1 remotely.

    *Note:* In a real-world scenario it is recommended to save the database and logs to a separate volume with host-based write-back caching disabled.

    ```powershell
    # Replace this with VN2-SRV1.ad.adatum.com on the second run
    $computerName = 'VN1-SRV5.ad.adatum.com' 

    $domainName = 'ad.adatum.com'
    $siteName = $null
    $installDns = $true
    $noGlobalCatalog = $false
    $createDnsDelegation = $false
    $dnsDelegationCredential = $null
    $replicationSourceDC = $null
    $databasePath = 'C:\Windows\NTDS'
    $logPath = 'C:\Windows\NTDS'
    $sysvolPath = 'C:\Windows\SYSVOL'
    ```

    [Configuring Active Directory Domain Services as an additional Domain Controller](../General/Configuring-Active-Directory-Domain-Services-as-an-additional-domain-controller.md)

## Exercise 2: Deploy a new forest

1. On CL1, install the role **Active Directory Domain Services** (```AD-Domain-Services```) on **VN2-SRV2**.

    [Installing roles and features on Windows Server](../General/Installing-roles-and-features-on-Windows-Server.md)

1. Configure Active Directory Domain Services as a new forest. If you want to use PowerShell, perform this task on VN2-SRV2 locally.

    * Computername: **VN2-SRV2**
    * Root domain name: **ad.contoso.com**
    * **DNS server**
    * NetBIOS domain name: **CONTOSO**
    * Do not update the DNS delegation (this is not possibly anyways, ignore the warning)

    Leave all other parameters as default.

    *Note:* In a real-world scenario it is recommended to save the database and logs to a separate volume with host-based write-back caching disabled.

    ```powershell

    $domainName = 'ad.contoso.com'
    $domainNetbiosName = 'CONTOSO'
    $installDns = $true
    $domainMode = 'Default'
    $forestMode = 'Default'
    $createDnsDelegation = $false
    $dnsDelegationCredential = $null
    $databasePath = 'C:\Windows\NTDS'
    $logPath = 'C:\Windows\NTDS'
    $sysvolPath = 'C:\Windows\SYSVOL'
    ```

    [Configuring Active Directory Domain Services as a new forest](../General/Configuring-Active-Directory-Domain-Services-as-a-new-forest.md)

## Exercise 3: Check domain controller health

1. On CL1, list the resource records in the zones **_msdcs.ad.adatum.com** and **ad.adatum.com** on VN1-SRV1, VN1-SRV5, and VN2-SRV1.

    In _msdcs.ad.adatum.com, there should be three CNAME records pointing to VN1-SRV1.ad.adatum.com, VN1-SRV5.ad.adatum.com, and VN2-SRV1.ad.adatum.com. Moreover, there should be several SRV records in the sub-domains dc, domains, gc, and pdc pointing to all three domain controllers.

    In ad.adatum.com, under _tcp, there should 12 SRV records for the services \_gc, \_kerberos, \_kpasswd, and \_ldap, pointing to VN1-SRV1.ad.adatum.com, VN1-SRV5.ad.adatum.com, and VN2-SRV1.ad.adatum.com.

    If any records, are missing, wait for at least 15 minutes and check again. If the problem persists, ask the instructor.

    [Managing resource records](../General/Managing-resource-records.md)

1. On CL1, verify that the shares **NETLOGON** and **SYSVOL** are present on **VN1-SRV5** and **VN2-SRV1**.

    [Managing shares](../General/Managing-shares.md)

1. On CL1, run the Best Practices Analyzer for **DNS** (```Microsoft/Windows/DNSServer```) and **AD DS** (```Microsoft/Windows/DirectoryServices```) on **VN1-SRV5** and **VN2-SRV1**.

    Review any warnings or errors, if present. If time permits, you can try to fix the warning and errors and run the the BPA scan again.

    [Running Best Practices Analyzer scans and managing scan results](../General/Running-Best-Practices-Analyzer-and-managing-scan-results.md)

## Exercise 4: Optimize DNS

1. On CL1, configure the forwarders of the DNS Server on **VN1-SRV5** and **VN2-SRV1** to **8.8.8.8** and **8.8.4.4**. Other forwarders should be deleted.

    [Configuring forwarders](../General/Configuring-forwarders.md)

1. On CL1 or, if you want to use SConfig, on VN1-SRV5 configure the DNS client settings for VN1-SRV5 as follows:

    Preferred DNS server: 10.1.2.8 (VN1-SRV2)
    Secondary DNS server: 127.0.0.1

    ````powershell
    $serverAddresses = '10.1.2.8', '127.0.0.1'
    ````

    [Changing TCP/IP settings on Windows Server](../General/Changing-TCP-IP-settings-on-Windows-Server.md)

1. On VN2-SRV2, configure the forwarders of the DNS Server to **8.8.8.8** and **8.8.4.4**. Other forwarders should be deleted.

    [Configuring forwarders](../General/Configuring-forwarders.md)

## Exercise 5: Transfer flexible single master operation roles

1. On CL1, transfer the **RID master**, **PDC emulator** and **Infrastructure master** roles to **VN1-SRV5**.

    [Transferring flexible single master operation roles](../General/Transferring-flexible-single-master-operation-roles.md)

1. On CL1, transfer the **Domain Naming master** and the **Schema master** role to **VN1-SRV5**.

    [Transferring flexible single master operation roles](../General/Transferring-flexible-single-master-operation-roles.md)

## Exercise 6: Join client to new forest

1. On CL3, change the DNS client server addresses to **10.1.2.16**.

    [Changing TCP/IP settings on Windows 11](../General/Changing-TCP-IP-settings-on-Windows-11.md)

1. Join CL3 to the domain **ad.contoso.com**.

    [Joining Windows 11 to a local Active Directory domain](../General/Joining-Windows-11-to-a-local-Active-Directory-domain.md)
