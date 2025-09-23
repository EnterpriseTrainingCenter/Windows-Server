# Lab: Migrate Active Directory

## Required VMs

* VN1-SRV1
* VN1-SRV4
* VN1-SRV5
* VN1-SRV9
* CL1

## Setup

1. On **CL1**, sign in as **ad\\Administrator**.
1. On **VN1-SRV9**, sign in as **ad\\Administrator**.
1. Open **Terminal**.
1. In Terminal, run the script ````C:\LabResources\Solutions\Install-Service.ps1````

You must have completed the practice [Explore Server Manager](../Practices/Explore-Server-Manager.md). If you skipped the practice, on **CL1**, in Terminal, run ````C:\LabResources\Solutions\Add-ServerManagerServers.ps1````.

You must have completed the practice [Install Windows Admin Center using a script](../Practices/Install-Windows-Admin-Center-using-a-script.md). If you skipped the practice, on **VN1-SRV4**, sign in as **ad\Administrator**, and run ````C:\LabResources\Solutions\Install-AdminCenter.ps1````.

## Introduction

The domain controller still running Windows Server 2022 must be replaced by a Windows Server 2025 domain controller. After the upgrade, you want to enable database 32K pages. Moreover, you want to validate delegated managed service accounts.

## Exercises

1. [Deploy an additional domain controller](#exercise-1-deploy-an-additional-domain-controller)
1. [Check domain controller health](#exercise-2-check-domain-controller-health)
1. [Transfer flexible single master operation roles](#exercise-3-transfer-flexible-single-master-operation-roles)
1. [Optimize DNS](#exercise-4-optimize-dns)
1. [Decommission a domain controller](#exercise-5-decommission-a-domain-controller)
1. [Raise domain and forest functional level](#exercise-6-raise-the-domain-and-forest-functional-level)
1. [Enable database 32K pages](#exercise-7-enable-database-32k-pages)
1. [Validate delegated managed service accounts](#exercise-8-validate-delegated-managed-service-accounts)

## Exercise 1: Deploy an additional domain controller

1. On CL1 install the optional feature **RSAT: DNS Server Tools** (```Rsat.Dns.Tools```).

    You do not need to wait for the installation to complete.

    [Installing optional features on Windows 11](../General/Installing-optional-features-on-Windows-11.md)

1. On CL1, disable the network adapters **SAN1**, **SAN2**, and **CLST1** on **VN1-SRV5**.

   [Enabling or disabling network adapters](../General/Enabling-or-disabling-network-adapters.md)

1. On CL1, install the role **Active Directory Domain Services** (```AD-Domain-Services```) on **VN1-SRV5**.

    [Installing roles and features on Windows Server](../General/Installing-roles-and-features-on-Windows-Server.md)

1. Configure Active Directory Domain Services as additional domain controller

    * Computername: **VN1-SRV5**
    * Domain: **ad.adatum.com**
    * **DNS server**
    * **Global Catalog** at the same time
    * Do not update the DNS delegation (this is not possibly anyways, ignore the warning)

    Leave all other parameters as default. If you want to use PowerShell, you may perform this task on either VN1-SRV5 locally or from CL1 remotely.

    *Note:* In a real-world scenario it is recommended to save the database and logs to a separate volume with host-based write-back caching disabled.

    ```powershell
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

1. On CL1, configure the forwarders of the DNS Server on **VN1-SRV5** to **8.8.8.8** and **8.8.4.4**. Other forwarders should be deleted.

    [Configuring forwarders](../General/Configuring-forwarders.md)

## Exercise 2: Check domain controller health

1. On CL1, retrieve the expected DNS records from VN1-SRV5 and VN2-SRV1.

    ````powershell
    $computerName = 'VN1-SRV5.ad.adatum.com', 'VN2-SRV1.ad.adatum.com'
    $expectedDNSRecords = Invoke-Command `
        -ComputerName $computerName -ScriptBlock {
            Get-Content -Path 'C:\Windows\System32\config\netlogon.dns'
        }
    $expectedDNSRecords
    ````

    Notice, that the file is space separated. The first column contains the name of the record. The fourth column contains the type of the record. Depending on the type, additional columns may follow. The last column contains the target name.

    Do not close the terminal! You will need the variables of the session in the next task.

1. On CL1, query the DNS servers **10.1.1.8**, **10.1.1.40**, and **10.1.2.8** for the expected DNS records and ensure, all are present. You can use this PowerShell script. Alternatively, you can either check the records in the DNS console on each server or resolve the records manually.

    ````powershell
    $dnsServers = '10.1.1.8', '10.1.1.40', '10.1.2.8'

    # Query each DNS server
    foreach ($server in $dnsServers) {

        # Go through the list of all expected DNS records line by line
        foreach ($expectedDNSRecord in $expectedDNSRecords) {

            # Split the line into columns using the space delimiter
            $expectedDNSRecordSplit = $expectedDNSRecord -split ' '

            # First column is the name
            $name = $expectedDNSRecordSplit[0]
            # Fourth column is the type
            $type = $expectedDNSRecordSplit[3]
            # Last column is the target
            $target = $expectedDNSRecordSplit[-1]

            <# 
                If the target ends with a dot, remove it.
                Resolve-DnsName will return the target without the ending dot.
            #>
            if ($target[-1] -eq '.' ) {
                $target = $target.Substring(0, $target.Length - 1)
            }

            # Try to resolve the record
            $dnsRecords = Resolve-DnsName -Name $name -Type $type -Server $server

            <# 
                Check if target is in the result.
                Unfortunately the property name for the target varies depending
                on the type. Therefore, we mus handle each type separately.
            #>
            $missingRecord = $false
            switch ($type) { 
                'A' {  
                    if ($dnsRecords.IPAddress -notcontains $target) {
                        $missingRecord = $true
                    }
                }
                'SRV' {  
                    if ($dnsRecords.NameTarget -notcontains $target) {
                        $missingRecord = $true
                    }
                }
                'CNAME' {
                    if ($dnsRecords.NameHost -notcontains $target) {
                        $missingRecord = $true
                    }
                }
                Default {
                    Write-Warning "Type $type not expected."
                }
            }

            # If record found write information
            if (-not $missingRecord) {
                Write-Host `
                    "$type record $name targeting $target found on $server"
            }

            # If record is missing write a warning
            if ($missingRecord) {
                Write-Warning `
                    "$type record $name targeting $target missing on $server"
            }
        }
    }
    ````

    If any records, are missing, wait for at least 15 minutes and check again. If the problem persists, ask the instructor.

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

## Exercise 4: Optimize DNS

1. On CL1, configure the forwarders of the DNS Server on **VN1-SRV5** to **8.8.8.8** and **8.8.4.4**. Other forwarders should be deleted.

    [Configuring forwarders](../General/Configuring-forwarders.md)

1. On CL1 or, if you want to use SConfig, on VN1-SRV5 configure the DNS client settings for VN1-SRV5 as follows:

    Preferred DNS server: 10.1.1.8
    Secondary DNS server: 127.0.0.1

    ````powershell
    $serverAddresses = '10.1.1.8', '127.0.0.1'
    ````

    [Changing TCP/IP settings on Windows Server](../General/Changing-TCP-IP-settings-on-Windows-Server.md)

1. On CL1 or, if you want to use SConfig, on VN1-SRV1 configure the DNS client settings for VN1-SRV1 as follows:

    Preferred DNS server: 10.1.1.40 (VN1-SRV5)
    Secondary DNS server: 10.1.1.8 (VN1-SRV1)

    ````powershell
    $serverAddresses = '10.1.1.40', '10.1.1.8'
    ````

    [Changing TCP/IP settings on Windows Server](../General/Changing-TCP-IP-settings-on-Windows-Server.md)

## Exercise 5: Decommission a domain controller

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

## Exercise 6: Raise the domain and forest functional level

1. On CL1, raise the domain functional level of **ad.adatum.com**.

    [Raising the domain functional level](../General/Raising-the-domain-functional-level.md)

1. On CL1, raise the forest functional level of **ad.adatum.com**.

    [Raising the forest functional level](../General/Raising-the-forest-functional-level.md)

## Exercise 7: Enable database 32K pages

1. On CL1, verify the that the domain **DC=ad, DC=adatum, DC=com** has a 32k page capable database.

    [Verifying a 32k page capable database](../General/Verifying-a-32k-page-capable-database.md)

1. On CL1, enable the Database 32k pages optional feature in the domain **ad.adatum.com** on server **VN1-SRV5**.

    [Enabling the Database 32k pages option](../General/Enabling-the-Database-32k-pages-option.md)

## Exercise 8: Validate delegated managed service accounts

1. On VN1-SRV9, inspect the service **PSService** and the file c:\LabResources\service.ps1. Verify, the startup type is Automatic and the service is running. Verify the executable.

    > Which account does the service use?

    nssm.exe is a tool to run any program as service. In our case, it runs the PowerShell script C:\LabResources\service.ps1. See <https://nssm.cc/> for more information about NSSM.

    Every 30 seconds, the script service.ps1 writes all GPO objects found in SYSVOL to C:\Logs\Policies.log.

    [Managing services](../General/Managing-services.md)

1. On CL1, generate the KDS root key

    [Generating the KDS root key](../General/Generating-the-KDS-root-key.md)

1. On CL1, create a delegated managed service account:

    ```powershell
    $path = 'ou=Service accounts, dc=ad, dc=adatum, dc=com'
    $name = 'dMSA_PSService'
    $dNSHostname = 'vn1-srv9.ad.adatum.com'
    ```

    [Creating a delegated managed service account](../General/Creating-a-delegated-managed-service-account.md)

1. On CL1, add the registry value DelegatedMSAEnabled on VN1-SRV9 and set it to 1.

    ```powershell
    $computerName = 'VN1-SRV9'
    $path = `
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
    $name = 'DelegatedMSAEnabled'
    $type = 'DWORD'
    $value = 1
    ```

1. Migrate the service account to the dMSA.

    ```powershell
    $identity = `
        'cn=dMSA_PSService, ou=Service accounts, dc=ad, dc=adatum, dc=com'
    $supersededAccount = `
        'cn=Powershell Service, ou=Service accounts, dc=ad, dc=adatum, dc=com'
    ```

    [Migrating a service account to a dMSA](../General/Migrating-a-service-account-to-a-dMSA.md)

    If time allows, check that the service is still configured to log on with the superseded service account.
