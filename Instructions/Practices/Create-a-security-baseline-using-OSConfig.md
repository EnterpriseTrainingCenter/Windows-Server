# Practice: Getting started with System Insights

## Required VMs

* VN1-SRV1
* VN1-SRV5
* CL1

## Setup

On CL1, sign in as **ad\Administrator**.

## Task

Install System Insights von VN1-SRV5, check the status of all capabilities, invoke all capabilities and check the default schedules.

## Instructions

Perform these steps on CL1.

1. Open **Terminal**.
1. Enter into a remote PowerShell session to VN1-SRV5.

    ````powershell
    Enter-PSSession VN1-SRV5
    ````

1. Install the OSConfig PowerShell module.

    ````powershell
    Install-Module `
        -Name Microsoft.OSConfig `
        -Scope AllUsers `
        -Repository PSGallery `
        -Force
    ````

1. At the prompt NuGet provider is required to continue, enter **y**.
1. Configure the security baseline for member servers.

    ````powershell
    $scenario = 'SecurityBaseline/WS2025/MemberServer'
    Set-OSConfigDesiredConfiguration -Scenario $scenario -Default
    ````

1. Check the compliance with the baseline.

    ````powershell
    Get-OSConfigDesiredConfiguration -Scenario $scenario |
    Format-Table `
        Name, `
        @{ Name = "Status"; Expression = { $PSItem.Compliance.Status } }, `
        @{ Name = "Reason"; Expression = { $_.Compliance.Reason } } `
        -AutoSize `
        -Wrap
    ````

1. Get the status of drift control.

    ````powershell
    Get-OSConfigDriftControl
    ````

    Drift control is enabled by default.

1. Disable drift control.

    ````powershell
    Disable-OSConfigDriftControl
    ````

1. Remove the security baseline.

    ````powershell
    Remove-OSConfigDesiredConfiguration -Scenario $scenario
    ````

1. At the prompt Confirm, enter **y**.
