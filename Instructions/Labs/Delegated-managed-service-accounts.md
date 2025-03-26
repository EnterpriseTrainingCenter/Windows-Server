# Lab: Delegated managed service accounts

## Required VMs

* VN1-SRV5
* VN1-SRV9
* CL1

## Setup

1. On **VN1-SRV5**, sign in ad **ad\\Administrator**.
1. On **CL1**, sign in as **ad\\Administrator**.
1. On **VN1-SRV9**, sign in as **ad\\Administrator**.
1. Open **Terminal**.
1. In Terminal, run the script ````C:\LabResources\Solutions\Install-Service.ps1````

## Introduction

To evaluate delegated managed service accounts, you want to migrate the service account of a sample service to a dMSA.

## Exercise: Validate delegated managed service accounts

1. [Inspect the service](#task-1-inspect-the-service) PSService on VN1-SRV9 and the file c:\LabResources\service.ps1

    > Which account uses the service to log on?
    > What does the service do?

1. [Generate the KDS root key](#task-2-generate-the-kds-root-key)
1. [Create a delegated managed service account](#task-3-create-a-delegated-managed-service-account) with the name dMSA_PSService in the organizational unit Service accounts for VN1-SRV9
1. [Add the registry value DelegatedMSAEnabled](#task-4-add-the-registry-value-delegatedmsaenabled) to the key HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters on VN1-SRV9
1. [Migrate the service account to the dMSA](#task-5-migrate-the-service-account-to-the-dmsa)

### Task 1: Inspect the service

Perform this task on VN1-SRV9.

1. Open **Services**
1. In Services, double-click the service **PSService**. Verify the **Startup type** is **Automatic** and the **Service status** is **Running**.

    On the tab General, you see as Path to executable C:\LabResources\nssm.exe.

    > nssm.exe is a tool to run any program as service. In our case, it runs the PowerShell script C:\LabResources\service.ps1. See <https://nssm.cc/> for more information about NSSM.

1. Click the tab **Log On**.

    > The service logs on as PSService@ad.adatum.com, which is a user account used as service account.

1. Click **Cancel**.
1. Open **File Explorer**.
1. In File Explorer, navigate to **C:\LabResources**.
1. In the context-menu of **service.ps1** click **Edit**.

    If you installed Visual Studio Code before, alternatively you can open the file with this app.

    > Every 30 seconds, the script write all GPO objects found in SYSVOL to C:\Logs\Policies.log.

1. In File Explorer, navigate to **C:\Logs**.
1. Open **Policies.log** and inspect its content.

### Task 2: Generate the KDS root key

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, verify if the KDS root key exists.

    ````powershell
    Get-KdsRootKey
    ````

1. If there is no KDS root key, generate it.

    ````powershell
    Add-KdsRootKey –EffectiveTime (Get-Date).AddHours((-10))
    ````

1. Verify the KDS root key again.

    ````powershell
    Get-KdsRootKey
    ````

### Task 3: Create a delegated managed service account

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, create a delegated managed service account with the name dMSA_PSService in the organizational unit Service accounts for VN1-SRV9

    ```powershell
    New-ADServiceAccount -Path 'ou=Service accounts, dc=ad, dc=adatum, dc=com' -Name dMSA_PSService -DNSHostName vn1-srv9.ad.adatum.com -CreateDelegatedServiceAccount -KerberosEncryptionType AES256
    ````

### Task 4: Add the registry value DelegatedMSAEnabled

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, add the registry value **DelegatedMSAEnabled** to the key to the key **HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters** on **VN1-SRV9**.

    ````powershell
    Invoke-Command -Computername VN1-SRV9 -ScriptBlock {
        $path = `
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
        New-Item $path -Force
        Set-ItemProperty `
            -Path $path -Name 'DelegatedMSAEnabled' -Value 1 -Type 'DWORD'

    }
    ````

### Task 5: Migrate the service account to the dMSA

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, start the migration from the account **PowerShell Service** to **dMSA_PSService**.

    ````powershell
    $identity = `
        'cn=dMSA_PSService, ou=Service accounts, dc=ad, dc=adatum, dc=com'
    $supersededAccount = `
        'cn=Powershell Service, ou=Service accounts, dc=ad, dc=adatum, dc=com'

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

1. Verify the properties **msDS-SupersededServiceAccountState** and **msDS-SupersededManagedAccountLink** of the old service account.

    ````powershell
    Get-ADUser `
        -Identity $supersededAccount `
        -Properties `
            msDS-SupersededServiceAccountState, `
            msDS-SupersededManagedAccountLink
    ````

    msDS-SupersededServiceAccountState should be 1. msDS-SupersededManagedAccountLink should contain the DN of the dMSA.

1. Restart the service **PSService** on **VN1-SRV9**.

    ````powershell
    Invoke-Command -ComputerName VN1-SRV9 -ScriptBlock {
        Restart-Service PSService
    }
    ````

1. Complete the account migration from the account **PowerShell Service** to **dMSA_PSService**.

    ````powershell
    Complete-ADServiceAccountMigration `
        -Identity $identity -SupersededAccount $supersededAccount
    ````

1. Verify the property **msDS-DelegatedMSAState** of the dMSA.

    ````powershell
    Get-ADServiceAccount -Identity $identity -Properties msDS-DelegatedMSAState
    ````

    msDS-DelegatedMSAState should be 2.

1. Verify the property **msDS-SupersededServiceAccountState** of the old service account.

    ````powershell
    Get-ADUser `
        -Identity $supersededAccount `
        -Properties msDS-SupersededServiceAccountState
    ````

1. Disable the old service account.

    ````powershell
    Disable-ADAccount -Identity $supersededAccount
    ````

1. Restart the service **PSService** on **VN1-SRV9** again.

    ````powershell
    Invoke-Command -ComputerName VN1-SRV9 -ScriptBlock {
        Restart-Service PSService
    }
    ````

    This is not necessary, but want to check, if the service still starts.

1. Reset the password of the old service account.

    ````powershell
    Set-ADAccountPassword -Identity $supersededAccount -Reset
    ````

1. At the prompts **Password** and **Repeat Password**, enter a new secure password that is different from any default passwords.

If time allows, check that the service is still configured to log on with the superseded service account.
