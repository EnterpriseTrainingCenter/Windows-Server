# Practice: Getting started with System Insights

## Required VMs

* VN1-SRV1
* VN1-SRV6
* CL1

## Setup

If you skipped the practice [Install Remote Server Administration Tools](/Instructions/Practices/Install-Remote-Server-Administration-Tools.md), on CL1, run the script **C:\LabResources\Solutions\Install-RemoteServerAdministrationTools.ps1**.

## Task

Install System Insights von VN1-SRV6, check the status of all capabilities, invoke all capabilities and check the default schedules.

## Instructions

Perform these steps on CL1.

1. On CL1, sign in as **ad\Administrator**.
1. Open **Terminal**.
1. In Terminal, install the Windows feature **System-Insights** on VN1-SRV6.

    ````powershell
    Add-WindowsFeature `
        -Computername VN1-SRV6 `
        -Name System-Insights `
        -IncludeManagementTools
    ````

1. Enter into a remote PowerShell session to VN1-SRV6.

    ````powershell
    Enter-PSSession VN1-SRV6
    ````

1. Get capabilities and their status.

    ````powershell
    Get-InsightsCapability
    ````

    State should be enabled for all capabilities, but the status is None, because they have not run yet.

1. Invoke all capabilities.

    ````powershell
    Get-InsightsCapability | Invoke-InsightsCapability
    ````

1. On the prompt Invoking a capability, enter **y**. Repeat this step for all capabilities.
1. Get the last run of all capabilities.

    ````powershell
    Get-InsightsCapability | Format-Table Name, Description, Status, LastRun
    ````

    LastRun should be the current date now.

1. Get the results of all capabilities.

    ````powershell
    Get-InsightsCapability | Get-InsightsCapabilityResult
    ````

    You will not see any results, because System Insights has to run for 5 days at least, before it can make any forecasts.

1. Check the default schedule of all capabilities.

    ````powershell
    Get-InsightsCapability | Get-InsightsCapabilitySchedule
    ````

1. Exit the remote PowerShell session

    ````powershell
    Exit-PSSession
    ````
