# Practice: Install Group Policy Management

## Required VMs

* VN1-SRV1
* CL1

## Task

On CL1, install Group Policy Management.

## Instructions

### Desktop experience

Perform these steps on CL1.

1. Sign in as **.\Administrator** or **ad\Administrator**.
1. Open **Settings**.
1. In Settings, click **System**.
1. In System, click **Optional features**.
1. In Optional features, click the button **View features**.
1. In View features, if necessary, click **See available features**. In the text field **Find an available optional feature**, type **RSAT**. Activate the checkbox beside **RSAT: Group Policy Management Tools**. Click **Add (1)**.

If required, restart the computer.

### PowerShell

Perform these steps on CL1.

1. Sign in as **.\Administrator** or **ad\Administrator**.
1. Run **Terminal** as Administrator.
1. Add the windows capability RSAT: Group Policy Management Tools

    ````powershell
    Get-WindowsCapability -Online -Name 'RSAT.GroupPolicy.Management.Tools*' |
    Add-WindowsCapability -Online    
    ````

1. If required, restart the computer, otherwise sign out.

    ````powershell
    Restart-Computer
    ````
