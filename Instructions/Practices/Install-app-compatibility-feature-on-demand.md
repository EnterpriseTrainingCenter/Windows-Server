# Practice: Install app compatibility feature on demand

## Required VMs

* VN1-SRV1
* VN1-SRV5

## Setup

On **VN1-SRV5**, logon as **ad\Administrator**.

### Task

On VN1-SRV5, install the application compatibility feature and verify the functionality.

### Instructions

Perform this task on VN1-SRV5.

1. In SConfig, enter **15**.
1. Mount the Windows Server Languages and Optional Features ISO image file.

    ````powershell
    $isoPath = 'C:\LabResources\20348.1.210507-1500.fe_release_amd64fre_SERVER_LOF_PACKAGES_OEM.iso'
    $fodIso = Mount-DiskImage -ImagePath $isoPath
    $fodDriveLetter = ($fodIso | Get-Volume).DriveLetter
    ````

1. Install the Application Compatibility Feature.

    ````powershell
    $name = 'ServerCore.AppCompatibility~~~~0.0.1.0'
    $source = "${fodDriveLetter}:\LanguagesAndOptionalFeatures\"
    Add-WindowsCapability -Online -Name $name -Source $source -LimitAccess
    ````

1. Restart the computer.

    ````powershell
    Restart-Computer
    ````

1. Login as **ad\Administrator**.
1. In SConfig, enter **15**.
1. Try to run the follwoing tools.

    ````powershell
    mmc.exe
    eventvwr.msc
    perfmon.exe
    resmon.exe
    devmgmt.msc
    explorer.exe
    powershell_ise.exe
    diskmgmt.msc
    CluAdmin.msc
    ````

1. Close all open graphical applications.
