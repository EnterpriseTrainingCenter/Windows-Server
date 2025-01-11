# Lab: FSLogix

## Required VMs

* VN1-SRV1
* VN1-SRV3
* VN1-SRV5
* VN1-SRV8
* VN1-SRV9
* VN1-SRV10
* VN2-SRV1
* VN2-SRV2
* PM-SRV3
* PM-SRV4
* CL1

## Setup

On **CL1**, sign in as **ad\\Administrator**.

You must have completed the lab [Deploy Remote Desktop Services](Deploy-Remote-Desktop-Services.md).

## Introduction

To provide a consistent user experience, you want to be the user profiles to be independent of the session hosts. For this reason, you want to implement and verify FSLogix with local profile containers.

## Exercises

1. [Implement FSLogix](#exercise-1-implement-fslogix)
1. [Verify Profile Containers](#exercise-2-verify-profile-containers)

## Exercise 1: Implement FSLogix

1. [Create organizational units](#task-1-create-organizational-units) in the domain: Servers\Remote Desktop Services\Session hosts
1. [Move session hosts to the organizational unit](#task-2-move-session-hosts-to-the-organizational-unit) Session hosts
1. [Install the file server role](#task-3-install-the-file-server-role) on VN1-SRV5
1. [Configure a volume](#task-4-configure-a-volume) on VN1-SRV5
1. [Create a file share](#task-5-create-a-file-share) on VN1-SRV5 on the new volume with the name Profiles
1. [Download and install FSLogix](#task-6-download-and-install-fslogix) on all session hosts
1. [Copy the group policy template](#task-7-copy-the-group-policy-templates) of Windows 11 and FSLogix to the central store on the domain's SYSVOL
1. [Configure settings for FSLogix](#task-8-configure-settings-for-fslogix) using a GPO

    * Set the VHD location to the file share
    * Set the VHD size to 1000000 MB
    * Set Temp Folder to Local path
    * Remove orphaned OST Files on Logoff
    * Enable Outlook Cached Mode
    * Delete local profile when VHD should apply
    * Roam identity
    * Enable FSLogix

### Task 1: Create organizational units

#### Active Directory Users and Computers

Perform this task on CL1.

1. Open **Active Directory Users and Computers**.
1. In Active Directory Users and Computers, expand **ad.adatum.com**.
1. In the context-menu of **ad.adatum.com**, click **New**, **Organizational Unit**.
1. In New Object - Organizational Unit, in **Name**, enter **Servers** and click **OK**.
1. In Active Directory Users and Computers, in the context-menu of **Servers**, click **New**, **Organizational Unit**.
1. In New Object - Organizational Unit, in **Name**, enter **Remote Desktop Services** and click **OK**.
1. In Active Directory Users and Computers, in the context-menu of **Remote Desktop Services**, click **New**, **Organizational Unit**.
1. In New Object - Organizational Unit, in **Name**, enter **Session hosts** and click **OK**.

#### Active Directory Administrative Center

Perform this task on CL1.

1. Open **Active Directory Administrative Center**.
1. In Active Directory Administrative Center, in the context-menu of **ad (local)**, click **New**, **Organizational Unit**.
1. In Create Organizational Unit, in **Name**, enter **Servers** and click **OK**.
1. In Active Directory Administrative Center, in the middle pane, in the context-menu of **ad (local)**, click **New**, **Organizational Unit**.
1. In Create Organizational Unit, in **Name**, enter **Remote Desktop Services** and click **OK**.
1. In Active Directory Administrative Center, in the middle pane, double-click **Servers**.
1. In the context-menu of **Remote Desktop Services**, click **New**, **Organizational Unit**.
1. In Create Organizational Unit, in **Name**, enter **Session hosts** and click **OK**.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**.
1. Create the organizational unit **Servers** at the domain level.

    ````powershell
    $adOrganizationalUnit = New-ADOrganizationalUnit `
        -Path 'DC=ad, DC=adatum, DC=com' `
        -Name 'Servers' `
        -Passthru
    ````

1. In the new organizational unit, create another organizational unit **Remote Desktop Services**.

    ````powershell
    $adOrganizationalUnit = New-ADOrganizationalUnit `
        -Path $adOrganizationalUnit.DistinguishedName `
        -Name 'Remote Desktop Services' `
        -Passthru
    ````

1. In the new organizational unit, create another organizational unit **Session hosts**.

    ````powershell
    $adOrganizationalUnit = New-ADOrganizationalUnit `
        -Path $adOrganizationalUnit.DistinguishedName `
        -Name 'Session hosts' `
        -Passthru
    ````

### Task 2: Move session hosts to the organizational unit

Perform this task on CL1.

1. Open **Active Directory Administrative Center**.
1. In Active Directory Administrative Center, click **ad (local)**and, in the middle pane, double-click **Computers**.
1. In Computers, click **VN1-SRV10**, hold down the CTRL key, and click **VN1-SRV8** and **VN1-SRV9**.
1. In the context-menu of one of the select computer objects, click **Move...**.
1. In Move, in the middle-pane, click **Servers**, in the right pane, click **Remote Desktop Services** and then **Session hosts**. Click **OK**.

### Task 3: Install the file server role

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, in the left pane, click **All Servers**.
1. In All Servers, in the context-menu of **VN1-SRV5**, click **Add Roles and Features**.
1. In the Add Rules and Features Wizard, on the page **Before You Begin**, click **Next >**.
1. On the page **Installation Type**, ensure **Role-based or feature-based installation** is selected and click **Next >**.
1. On the page **Server Selection**, ensure **VN1-SRV5.ad.adatum.com** is selected and click **Next >**.
1. On the page **Server Role**, expand **File and Storage Service** and expand **File and iSCSI Services**. Activate the checkbox next to **File Server** and click **Next >**.
1. On the page **Features**, click **Next >**.
1. On the page **Confirmation**, verify your selection, click to activate **Restart the destination server automatically if required** ([figure 1]) and click **Install**.
1. On the page **Results**, wait for the installation to succeed, then click **Close**.

### Task 4: Configure a volume

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, in the left pane, click **File and Storage Services**, then click **Disks**.
1. Under File and Storage Services > Volumes > Disks, under DISKS, under **VN1-SRV5**, in the context-menu of disk number **1** with a capacity of **1,00 TB**, click **Bring Online**.
1. In the dialog Bring Disk Online, click **Yes**.
1. In the contexte-menu of the disk, click **Initialize**.
1. In the dialog Initialize Disk, click **Yes**.
1. In the context-menu of the disk, click **New Volume...**
1. In the New Volume Wizard, click **Next >**.
1. On page Server and Disk, ensure that **VN1-SRV5** and **Disk 1** is selected and click **Next >**.
1. On page Size, ensure that **Volume size** is **1.024** **GB** and click **Next >**.
1. On page Drive Letter or Folder, ensure, **Drive letter** is **D** and click **Next >**.
1. On page File System Settings, ensure **File system** is **NTFS**. Beside **Volume label**, type **Data** and click **Next >**.
1. On page Confirm selections, verify your selections ([figure 2]) and click **Create**.
1. On page Results, click **Close**.

### Task 5: Create a file share

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, in the left pane, click **File and Storage Services**, then click **Shares**.
1. In File and Storage Services > Shares, under SHARES, click **TASKS**, **New Share...**
1. In the New Share Wizard, on page Select Profile, ensure **SMB Share - Quick** is selected and click **Next >**.
1. On page Share Location, under Server, click **VN1-SRV5**. Under Share location, click **D:**. Click **Next >**.
1. On page Share Name, beside **Share name**, type **Profiles** and click **Next>**.
1. On page Other Settings, click to activate **Enable access-based enumeration**, click to deactivate **Allow caching of share** and click to activate **Encrypt data access**. Click **Next >**.
1. In New Share Wizard, on page Permissions, click **Next >**.
1. On page Confirmation, verify your selections ([figure 3]) and click **Create**.
1. On page Results, click **Close**.

### Task 6: Download and install FSLogix

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, download FSLogix.

    ````powershell
    $destination = 'C:\LabResources\'
    Start-BitsTransfer `
        -Source https://aka.ms/fslogix_download `
        -Destination "$destination\FSLogix_Apps.zip"
    ````

1. Uncompress the downloaded archive.

    ````powershell
    $destinationPath = 'C:\LabResources\FSLogix_Apps\'
    Expand-Archive `
        -Path "$destination\FSLogix_Apps.zip" `
        -DestinationPath $destinationPath
    ````

1. Save the names of the session hosts in a variable.

    ````powershell
    $rDServer = Get-RDServer `
        -Role RDS-RD-SERVER -ConnectionBroker vn2-srv1.ad.adatum.com |
        Select-Object -ExpandProperty Server
    ````

1. Create remote PowerShell sessions to the session hosts.

    ````powershell
    $pSSession = New-PSSession $rDServer
    ````

1. Copy the FSLogix Apps to the session hosts.

    ````powershell
    $psSession | ForEach-Object {
        Copy-Item `
            -Path "$destinationPath\x64\Release\FSLogixAppsSetup.exe" `
            -ToSession $PSItem `
            -Destination $destination
    }
    ````

1. Install the FSLogix apps unattended.

    ````powershell
    Invoke-Command -Session $pSSession { 
        & "$($using:destination)\FSLogixAppsSetup.exe" /install /quiet
    }
    ````

1. Verify that FSLogix Apps are installed on all servers.

    ````powershell
    Invoke-Command -Session $pSSession {
        Get-Package -Name 'Microsoft FSLogix Apps' 
    }
    ````

### Task 7: Copy the group policy templates

Perform these steps on CL1.

1. Open **Terminal**.
1. Copy the Windows 11 group policy templates to the central store.

    `````powershell
    Copy-Item `
        -Path \Windows\PolicyDefinitions\ `
        -Destination \\ad.adatum.com\SYSVOL\ad.adatum.com\Policies\ `
        -Container `
        -Recurse `
        -Force
    ````

1. Copy the group policy templates for FSLogix to the central store.

    ````powershell
    Copy-Item `
        -Path C:\LabResources\FSLogix_Apps\fslogix.admx `
        -Destination `
            \\ad.adatum.com\SYSVOL\ad.adatum.com\Policies\PolicyDefinitions\
    Copy-Item `
        -Path C:\LabResources\FSLogix_Apps\fslogix.adml `
        -Destination `
            \\ad.adatum.com\SYSVOL\ad.adatum.com\Policies\PolicyDefinitions\en-US\    
    ````

### Task 8: Configure settings for FSLogix

Perform this task on CL1.

1. Open **Group Policy Management**.
1. In Group Policy Management, expand **Forest: ad.adatum.com**, **Domains**, **ad.adatum.com**, and click **Group Policy Objects**.
1. In the context menu of **Group Policy Objects**, click **New**.
1. In New GPO, under Name, type **Custom Computer FSLogix Profile Containers** and click **OK**.
1. In Group Policy Management, in the context-menu of **Custom Computer FSLogix Profile Containers**, click **Edit**.
1. In Group Policy Management Editor, under Computer Configuration, expand **Policies**, **Administrative Templates**, **FSLogix** and click **Profile Containers**.
1. In Profile Containers, double-click **VHD Locations**.
1. In VHD Locations, click **Enabled** and, below, under **VHD Locations**, type **\\\\VN1-SRV5\\Profiles**. Click **OK**.
1. In Group Policy Management Editor, double-click **Size in MBs**.
1. In Size in MBs, click **Enabled** and, below, beside **Size in MBs**, type **1000000**. Click **OK**.
1. In Group Policy Management Editor, double-click **Set Temp Folders to Local Path**.
1. In Set Temp Folders to Local Path, click **Enabled** and, below, click **Redirect TEMP, TMP and InetCache to local drive**. Click **OK**.
1. For the following settings, in Group Policy Management Editor, double-click the setting, then in the setting dialog, click **Enabled** and click **OK**

    * Remove Orphaned OST Files on Logoff
    * Enabled
    * Outlook Cached Mode
    * Delete Local Profile When VHD Should Apply
    * Roam Identity

1. Close **Group Policy Management Editor**.
1. In Group Policy Management, expand **Servers**, **Remote Desktop Services**.
1. In the context-menu of **Session hosts**, click **Link an Existing GPO...**
1. In Select GPO, click **Custom Computer FSLogix Profile Containers** and click **OK**.
1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services** and **Servers**.
1. In Remote Desktop-Services, Servers, click VN1-SRV10, hold down the CTRL key and click **VN1-SRV8** and **VN1-SRV9**.
1. In the context-menu of any of the selected servers, click **Restart Server**.
1. In the dialog Are you sure you want to restart these servers, click **OK**.

## Exercise 2: Verify Profile Containers

1. [Verify the user experience with FSLogix](#task-1-verify-the-user-experience-with-fslogix)
1. [Verify the files created by FSLogix](#task-2-verify-the-files-created-by-fslogix)

    > Which files are created on the share?

    > What remains on the local server after the user signs out?

### Task 1: Verify the user experience with FSLogix

Perform this task on CL1.

1. Open **File Explorer**.
1. In File Explorer navigate to **Downloads**.
1. Double-click **cpub-Standard_desktop-Standard_desktop-CmsRdsh.rdp**
1. In Remote Desktop connection security warning, ensure, beside **Gateway server**, **remote.adatum.com** is shown. Click **Connect**.
1. In Windows Security, click **More choices** and **Use a different account**. Sign in as **AD\Ada**.

    Wait for the connection to complete. During the sign in, you should see messages regarding FSLogix.

1. Open **Windows PowerShell**.
1. List the redirections from FSLogix.

    ````powershell
    & 'C:\Program Files\FSLogix\Apps\frx.exe' list-redirects
    ````

    You should see a list of redirections. Redirections to HarddiskVolume6 are redirections to the attached VHD. Redirections to HardDiskVolume4 are to the local disk.

1. Sign out.

### Task 2: Verify the files created by FSLogix

Perform this task on CL1.

1. Open **File Explorer**.
1. In File Explorer, navigate to **\\\\VN1-SRV5\\Profiles**.

    You should see a folder with a SID ending with _Ada.

1. Double-click the folder.

    You should see a Hard Disk-Image File with the name Profile_Ada.

1. Open **Terminal**.

1. Save the names of the session hosts in a variable.

    ````powershell
    $rDServer = Get-RDServer `
        -Role RDS-RD-SERVER -ConnectionBroker vn2-srv1.ad.adatum.com |
        Select-Object -ExpandProperty Server
    ````

1. List the user profile folders on the local disks of the session hosts.

    ````powershell
    $rDServer | ForEach-Object { Get-ChildItem \\$PSItem\C$\Users }
    ````

    You should not see a folder for Ada. If you are still unsure, run the following command.

    ````powershell
    $rDServer | ForEach-Object { Get-ChildItem \\$PSItem\C$\Users\*Ada }
    ````

    You should not get a result.

[figure 1]: /images/Add-File-Server-role-Confirm-installation-selections.png
[figure 2]: /images/New-Volume-Wizard-Confirm-selections.png
[figure 3]: /images/New-Share-Wizard-Confirm-selections.png