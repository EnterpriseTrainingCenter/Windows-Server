# Practice: Harden SMB

## Required VMs

* VN1-SRV1
* VN1-SRV5
* VN1-SRV10
* CL1

## Setup

If you skipped the practice [Install prerequisites for file server](./Install-prerequisites-for-file-serving.md), on CL1, run ````C:\LabResources\Solutions\New-Shares.ps1````.

## Task

Verify that SMB 1.0 is disabled and uninstalled on VN1-SRV10.

Enable SMB encryption on server VN1-SRV5 and on the share \\\\VN1-SRV10\\IT.

## Instructions

Perform these steps on CL1.

1. Sign in as **ad\Administrator**.
1. Run **Terminal** as Administrator.
1. Create a remote PowerShell session with **VN1-SRV10**.

    ````powershell
    Enter-PSSession -ComputerName VN1-SRV10
    ````

1. Verify that SMB 1.0 is disabled.

    ````powershell
    Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol
    ````

    The value of EnableSMB1Protocol should be False.

1. Verify that SMB 1.0 is not installed.

    ````powershell
    Get-WindowsFeature -Name FS-SMB1*
    ````

    The features FS-SMB1, FS-SMB1-CLIENT, and FS-SMB1-SERVER should have an Install State of Available.

1. Exit the remote PowerShell session, but leave Terminal open.

    ````powershell
    Exit-PSSession
    ````

1. Create a remote PowerShell session with **VN1-SRV5**.

    ````powershell
    Enter-PSSession -ComputerName VN1-SRV5
    ````

1. Enable SMB encryption for the server

    ````powershell
    Set-SmbServerConfiguration -EncryptData $true
    ````

1. Under **Confirm**, enter **y**.
1. Exit the remote PowerShell session, but leave Terminal open.

    ````powershell
    Exit-PSSession
    ````

1. Enable encryption for the share **\\\\VN1-SRV10\\IT**.

    ````powershell
    Invoke-Command -ComputerName VN1-SRV10 -ScriptBlock {
        Set-SmbShare -Name IT -EncryptData $true -Force
    }
    ````
