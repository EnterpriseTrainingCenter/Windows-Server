# Practice: Create a security baseline using OSConfig

## Required VMs

* VN1-SRV1
* VN1-SRV6
* CL1

## Task

On VN1-SRV6, apply the security baseline for member servers using OSConfig. Check the compliance, verify the status of drift control, disable drift control and remove the security baseline.

## Instructions

Perform these steps on CL1.

1. On CL1, sign in as **ad\Administrator**.
1. Open **Terminal**.
1. Enter into a remote PowerShell session to VN1-SRV6.

    ````powershell
    Enter-PSSession VN1-SRV6
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
1. Exit the remote PowerShell session.

    ````powershell
    Exit-PSSession
    ````
