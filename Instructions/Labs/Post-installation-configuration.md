# Lab: Post installation configuration

## Required VMs

* VN1-SRV1
* VN1-SRV4
* VN1-SRV5
* VN1-SRV20
* VN1-SRV21

## Setup

On **CL1**, logon as **ad\Administrator**.
On **VN1-SRV5**, logon as **ad\Administrator**.

You must have completed the practices [Install Window Server with Desktop Experience manually](../Practices/Install-Windows-Server-with-Desktop-Experience-manually.md) and [Install Window Server manually](../Practices/Install-Windows-Server-manually.md) before starting with this lab.

## Introduction

After the initial setup, Windows Servers require some post-installation configuration like configuring TCP/IP. joining the domain, or setting some management options. Depending on the applications you are planning to install, you might also need the app compatiblity feature on demand.

## Exercises

1. [Configure password, TCP/IP, domain join and time zone on Windows Server with Desktop Experience](#exercise-1-configure-password-tcpip-domain-join-and-time-zone-on-windows-server-with-desktop-experience)
1. [Configure password, TCP/IP, domain join and time zone on Windows Server](#exercise-2-configure-password-tcpip-domain-join-and-time-zone-on-windows-server)
1. [Install App Compatibility Feature on Demand](#exercise-3-install-app-compatibility-feature-on-demand)

## Exercise 1: Configure password, TCP/IP, domain join and time zone on Windows Server with Desktop Experience

1. [Set the default Administrator password on Windows Server with Desktop Experience](#task-1-set-the-default-administrator-password-on-windows-server-with-desktop-experience)
1. [Configure the Ethernet adapter on Windows Server with Desktop Experience](#task-2-configure-the-ethernet-adapter-on-windows-server-with-desktop-experience) with the IPv4 address 10.1.1.160/24, default gateway 10.1.1.1 and DNS server 10.1.1.8
1. [Set the computer name and join the domain on Windows Server with Desktop Experience](#task-3-set-the-computer-name-and-join-the-domain-on-windows-server-with-desktop-experience): the computer name should be VN1-SRV20
1. [Set the time zone on Windows Server with Desktop Experience](#task-4-set-the-time-zone-on-windows-server-with-desktop-experience)

### Task 1: Set the default Administrator password on Windows Server with Desktop Experience

Perform this task on VN1-SRV20.

1. In Customize settings, enter a secure password in Password and **Reenter password** and click **Finish**.
1. Logon as **Administrator** with the password from the previous step.

### Task 2: Configure the Ethernet adapter on Windows Server with Desktop Experience

#### Desktop experience

Perform this task on VN1-SRV20.

1. In **Server Manager**, in the left pane, click **Local Server**.
1. Beside **Ethernet**, click **IPv4 address assigned by DHCP, IPv6 enabled**.
1. In **Network Connections**, in the context-menu of **Ethernet**, click **Properties**.
1. In Ethernet Properties, click **Interent Protocol Version 4 (TCP/IPv4)** and click **Properties**.
1. In Internet Protocol Version 4 (TCP/IPv4) Properties, click **Use the following IP address**.
1. In **IP address**, enter 10.1.1.160.
1. In **Subnet mask**, enter 255.255.255.0.
1. In **Default gateway**, enter 10.1.1.1.
1. In **Preferred DNS server**, enter 10.1.1.8.
1. Click **OK**.
1. In **Ethernet Properties**, click **OK**.
1. Close **Network Connections**.

#### PowerShell

Perform this task on VN1-SRV20.

1. Run **Windows PowerShell** as Administrator.
1. Configure the network adapter **Ethernet** with the IP address **10.1.1.160/24** and the default gateway 10.1.1.1.

    ````powershell
    New-NetIPAddress `
        -InterfaceAlias Ethernet `
        -AddressFamily IPv4 `
        -IPAddress 10.1.1.160 `
        -PrefixLength 24 `
        -DefaultGateway 10.1.1.1
    ````

1. Configure the network adapter **Ethernet** to use the DNS server addresss **10.1.1.8**

    ````powershell
    Set-DnsClientServerAddress `
        -InterfaceAlias Ethernet `
        -ServerAddresses 10.1.1.8
    ````

### Task 3: Set the computer name and join the domain on Windows Server with Desktop Experience

#### Desktop experience

Perform this task on VN1-SRV20.

1. In **Server Manager**, in the left pane, click **Local Server**.
1. Click **Workgroup**.
1. In System Properties, click **Change...**.
1. In Computer Name/Domain Change, in **Computer name**, enter **VN1-SRV20**.
1. Click **Domain** and enter **ad.adatum.com**.
1. In Windows Security, enter the credentials of **ad\Administrator**.
1. In **Welcome to the ad.adatum.com domain**, click **OK**.
1. In **System Properties**, click **Close**.
1. In **You must restart your computer to apply these change**, click **Restart Now**.

#### Windows Admin Center

Perform this task on CL1.

1. Using Microsoft Edge, navigate to <https://admincenter>.
1. In Windows Admin Center, click **Add**.
1. In Add or create resources, under **Servers**, click **Add**.
1. On the tab **Add one**, type 10.1.1.160.
1. Click **Use another account for this connection**.
1. Enter the credentials for the default Administrator account and click **Add**.
1. Click **10.1.1.160**.
1. Connected to 10.1.1.160, in Overview, click **Edit Computer ID**.
1. In the pane Edit computer ID, in **Computer name**, enter **VN1-SRV20**.
1. Click **Domain** and enter **ad.adatum.com.**.
1. Click **Next**.
1. Under **Current domain**, enter the credentials of **ad\Administrator** and click **Save**.
1. In **Overview**, click **Restart**.
1. In **Restart the computer**, click **Yes**.
1. In Windows Admin Center, activate the checkbox beside **10.1.1.160**.
1. Click **Remove**.

#### PowerShell

Perform this task on VN1-SRV20.

1. Run **Windows PowerShell** as Administrator.
1. Rename the computer to **VN1-SRV20** and join it to the domain **ad.adatum.com**.

    ````powershell
    Add-Computer -NewName VN1-SRV20 -DomainName ad.adatum.com -Restart
    ````

1. Enter the credentials for **ad\Administrator**.

### Task 4: Set the time zone on Windows Server with Desktop Experience

#### Desktop Experience

Perform this task von VN1-SRV20.

1. Logon as **ad\Administrator**.
1. In **Server Manager**, in the left pane, click **Local Server**.
1. In Properties For VN1-SRV20, right to **Time zone**, click **(UTC-08:00) Pacific Time (US & Canada)**.
1. In Date and Time, click **Change time zone...**.
1. In Time Zone Settings, under **Time zone**, select your local time zone and click **OK**.
1. In **Date and Time**, click **OK**.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**.
1. Set the time zone of VN1-SRV20 to the same time zone as CL1.

    ````powershell
    $timezone = Get-TimeZone
    Invoke-Command -ComputerName VN1-SRV20 { Set-TimeZone $using:timezone.id }
    ````

## Exercise 2: Configure password, TCP/IP, domain join and time zone on Windows Server

1. [Set the default Administrator password on Windows Server](#task-1-set-the-default-administrator-password-on-windows-server)
1. [Configure the Ethernet adapter on Windows Server](#task-2-configure-the-ethernet-adapter-on-windows-server) with the IPv4 address 10.1.1.168/24, default gateway 10.1.1.1 and DNS server 10.1.1.8
1. [Set the computer name and join the domain on Windows Server](#task-3-set-the-computer-name-and-join-the-domain-on-windows-server): the computername should be VN1-SRV21
1. [Set the time zone on Windows Server](#task-5-set-the-time-zone-on-windows-server)

### Task 1: Set the default Administrator password on Windows Server

Perform this task on VN1-SRV21.

1. Under **The user's password must be changed before signing in**, use the up/down arrow keys to select **OK** and press ENTER.
1. Under **Enter new credentials for Administrator or hit ESC to cancel**, beside **New password**, enter a secure password and press TAB.
1. Beside **Confirm password**, enter the secure password again and press ENTER.
1. Under **Your password has been changed.** press ENTER.

### Task 2: Configure the Ethernet adapter on Windows Server

#### Sconfig

Perform this task on VN1-SRV21.

1. In SConfig, enter **8**.
1. In Network settings, enter  **1**.
1. In Network adapter settings, enter **1**.
1. Beside **Select (D)HCP or (S)tatic IP address (Blank=Canel)**, enter **S**.
1. Beside **Enter static IP address (Blan=Cancel)**, enter **10.1.1.168**.
1. Beside **Enter subnet mask (Blank=255.255.255.0)**, press ENTER.
1. Beside **Enter default gateway (Blank=Cancel)**, enter **10.1.1.1**.
1. Under 4 success messages, press ENTER.
1. In **SConfig**, enter **8**.
1. In Network settings, enter  **1**.
1. In Network adapter settings, enter **2**.
1. Beside **Enter new preferred DNS server (Blank=Cancel)**, enter **10.1.1.8**.
1. Beside **Enter alternate DNS server (Blank=Cancel)**, press ENTER.
1. Under a success message, press ENTER.

#### PowerShell

Perform this task on VN1-SRV21.

1. In SConfig, enter **15**.
1. Configure the network adapter **Ethernet** with the IP address **10.1.1.168/24** and the default gateway 10.1.1.1.

    ````powershell
    New-NetIPAddress `
        -InterfaceAlias Ethernet `
        -AddressFamily IPv4 `
        -IPAddress 10.1.1.168 `
        -PrefixLength 24 `
        -DefaultGateway 10.1.1.1
    ````

1. Configure the network adapter **Ethernet** to use the DNS server addresss **10.1.1.8**

    ````powershell
    Set-DnsClientServerAddress `
        -InterfaceAlias Ethernet `
        -ServerAddresses 10.1.1.8
    ````

### Task 3: Set the computer name and join the domain on Windows Server

#### SConfig

Perform this task on VN1-SRV21.

1. In SConfig, enter **1**.
1. Under **Change domain/workgroup membership**, enter **d**.
1. Beside **Name of domain to join (Blank=Cancel)**, enter **ad.adatum.com**.
1. Beside **Specify an authorized domain\user (Blank=Canel)**, enter **ad\Administrator**.
1. Enter the password for ad\Administrator.
1. After you receive a success message, beside **Do you want to change the computer name befor restarting?**, enter **y**.
1. Beside **Enter new computer name (Blank=Cancel)**, enter **VN1-SRV21**.
1. Enter the password for ad\Administrator.
1. Beside **Restart now? (Y)es or (N)o**, enter **y**.

#### Windows Admin Center

Perform this task on CL1.

1. Using Microsoft Edge, navigate to <https://admincenter>.
1. In Windows Admin Center, click **Add**.
1. In Add or create resources, under **Servers**, click **Add**.
1. On the tab **Add one**, type 10.1.1.160.
1. Click **Use another account for this connection**.
1. Enter the credentials for the default Administrator account and click **Add**.
1. Click **10.1.1.160**.
1. Connected to 10.1.1.160, in Overview, click **Edit Computer ID**.
1. In the pane Edit computer ID, in **Computer name**, enter **VN1-SRV21**.
1. Click **Domain** and enter **ad.adatum.com.**.
1. Click **Next**.
1. Under **Current domain**, enter the credentials of **ad\Administrator** and click **Save**.1. In **Overview**, click **Restart**.
1. In Windows Admin Center, activate the checkbox beside **10.1.1.160**.
1. Click **Remove**.

#### PowerShell

Perform this task on VN1-SRV21.

1. Ensure, you are on the command line (PowerShell).
1. Rename the computer to **VN1-SRV21** and join it to the domain **ad.adatum.com**.

    ````powershell
    Add-Computer -NewName VN1-SRV21 -DomainName ad.adatum.com -Restart
    ````

1. Enter the credentials for **ad\Administrator**.

### Task 4: Set the time zone on Windows Server

#### SConfig

Perform this task von VN1-SRV21.

1. In the menu of **Connection to virtual Computer**, click **View**, **Enhanced Session** (Ansicht, **Erweiterte Sitzung**) to disable the enhanced session mode.
1. In the menu of **Connection to virtual Computer**, click **Action**, **CTRL+ALT+DEL** (**Aktion**, **STRG+ALT+ENTF**).
1. Under **Enter credentials for Administrator or hit ESC to switch users/sign-in methods**, press **ESC**.
1. Under **Select a sign-in option for Administrator or hit ESC to switch users**, press **ESC** again.
1. Under **Select a user**, use the up/down arrow keys to select **Other user** and press ENTER.
1. Under **Enter credentials for Other user or hit ESC to switch users/sign-in methods**, beside **User name**, enter **ad\Administrator** and press TAB.
1. Beside **Password**, enter the password for ad\Administrator and press ENTER.
1. In SConfig, enter **9**.
1. In Date and Time, click **Change time zone...**.
1. In Time Zone Settings, under **Time zone**, select your local time zone and click **OK**.
1. In **Date and Time**, click **OK**.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**.
1. Set the time zone of VN1-SRV20 to the same time zone as CL1.

    ````powershell
    $timezone = Get-TimeZone
    Invoke-Command -ComputerName VN1-SRV21 { Set-TimeZone $using:timezone.id }
    ````

## Exercise 3: Install App Compatibility Feature on Demand

1. [Install the Application Compatibility Feature](#task-1-install-the-application-compatibility-feature) on VN1-SRV5
1. [Verify the installation of the App Compatibility Feature](#task-2-verify-the-installation-of-the-app-compatibility-feature)

### Task 1: Install the Application Compatibility Feature

Perform this task on VN1-SRV5.

1. In SConfig, enter **15**.
1. Mount the Windows Server Languages and Optional Features ISO image file.

    ````powershell
    $imagePath = 'C:\LabResources\26100.1.240331-1435.ge_release_amd64fre_SERVER_LOF_PACKAGES_OEM.iso'
    $diskImage = Mount-DiskImage -ImagePath $imagePath
    $driveLetter = ($diskImage | Get-Volume).DriveLetter
    ````

1. Install the Application Compatibility Feature.

    ````powershell
    $name = 'ServerCore.AppCompatibility~~~~0.0.1.0'
    $source = "${driveLetter}:\LanguagesAndOptionalFeatures\"
    Add-WindowsCapability -Online -Name $name -Source $source -LimitAccess
    ````

1. Restart the computer.

    ````powershell
    Restart-Computer
    ````

### Task 2: Verify the installation of the App Compatibility Feature

Perform this task on VN1-SRV5.

1. Login as **ad\Administrator**.
1. In SConfig, enter **15**.
1. Try to run the following tools.

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
    taskschd.msc
    virtmgmt.msc
    ````

1. Close all open graphical applications.
