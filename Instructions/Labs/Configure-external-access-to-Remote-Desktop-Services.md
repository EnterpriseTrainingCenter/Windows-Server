# Lab: Configure external access to Remote Desktop Services

## Required VMs

* VN1-SRV1
* VN1-SRV8
* VN1-SRV9
* VN1-SRV10
* VN2-SRV1
* PM-SRV3
* CL1
* CL2

## Setup

1. On **CL1**, sign in as **ad\\Administrator**.
1. On **CL2**, sing in as **.\Administrator**.

You must have completed the lab [Deploy Remote Desktop Services](Deploy-Remote-Desktop-Services.md).

## Introduction

Because your users work from home office, you want to make your Remote Desktop Services Deployment available for external access. For this purpose, you want to deploy and verify the RD Gateway.

## Exercises

1. [Deploy an RD Gateway](#exercise-1-deploy-an-rd-gateway)
2. [Verify the RD Gateway](#exercise-2-verify-the-rd-gateway)

## Exercise 1: Deploy an RD Gateway

1. [Install the Remote Server Administration DNS Server Tools](#task-1-install-the-remote-server-administration-dns-server-tools) on CL1
1. [Create a DNS zone with a record](#task-2-create-a-dns-zone-with-a-record) with the name adatum.com and the record remote pointing to 10.1.200.24
1. [Add an RD gateway server](#task-3-add-an-rd-gateway-server) on PM-SRV3
1. [Configure RD Gateway](#task-4-configure-rd-gateway) by adding the RD Web certificate

### Task 1: Install the Remote Server Administration DNS Server Tools

#### Desktop experience

Perform these steps on CL1.

1. Open **Settings**.
1. In Settings, click **System**.
1. In System, click **Optional features**.
1. In Optional features, click the button **View features**.
1. In View features, if necessary, click **See available features**.
1. In Add an optional feature, in the text field **Find an available optional feature**, type **RSAT**. Activate the check box beside **RSAT: DNS Server Tools**. Click **Add (1)**.
1. If required, restart the computer.

Wait for the installation to complete.

#### PowerShell

Perform these steps on CL1.

1. In the context menu of **Start**, click **Terminal (Admin)**.
1. Add the windows capabilities **RSAT: Server DNS Server tools**.

    ````powershell
    Get-WindowsCapability -Online -Name 'Rsat.Dns.Tools*' |
    Add-WindowsCapability -Online
    ````

Wait for the installation to complete.

### Task 2: Create a DNS zone with a record

Perform these steps on CL1.

1. Open **DNS**.
1. In Connect to DNS-Server, click **The following computer** and, below, type VN1-SRV1.ad.adatum.com. Click **OK**.
1. In DNS Manager, expand **VN1-SRV1.ad.adatum.com**, **Forward Lookup Zones**, and click **Forward Lookup Zones**.
1. In the context-menu of **Forward Lookup Zones**, click **New Zone..**
1. In the New Zone Wizard, click **Next >**.
1. On page Zone Type, ensure, **Primary zone** is selected. Click to deactivate **Store the zone in Active Directory**. Click **Next >**.
1. On page Zone Name, type **adatum.com** and click **Next >**.
1. On page Zone file, ensure, **Create a new file with this file name** is selected and **adatum.com.dns** is typed in. Click **Next >**.
1. On page Dynamic update, ensure **Do not allow dynamic updates** is selected and click **Next >**.
1. On page Completing the New Zone Wizard, verify you selections and click **Finish**.
1. In DNS Manager, click **adatum.com**.
1. In the context-menu of **adatum.com**, click **New Host (A or AAAA)...**
1. In New Host, under **Name (uses parent domain if blank)**, type **remote**. Ensure, that under **Fully qualified domain name (FQDN)**, **remote.adatum.com** appears. Under **IP address**, type **10.1.200.24**. Click **Add Host**.
1. In The host record remote.adatum.com was successfully created, click **OK**.
1. In New Host, click **Done**.

### Task 3: Add an RD gateway server

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT SERVERS, click **TASKS**, **Add RD Gateway Servers**.

    Alternatively, under DEPLOYMENT OVERVIEW, click the green plus sign above RD Gateway.

1. In Add RD Gateway Servers, click **PM-SRV3.ad.adatum.com** and click the arrow button rbetween the columns. Click **Next >**.
1. On page Name the self-signed SSL certificate, type **remote.adatum.com** and click **Next >**.
1. On page Confirmation, click **Add**.

    Wait for the installation to complete.

1. On page Results, click **Close**.

### Task 4: Configure RD Gateway

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, click **TASKS**, **Edit Deployment Properties**.
1. In Deployment Properties, click the page **Certificates**.
1. On page Certificates, click **RD Gateway** and click **Select existing certificate...**.
1. In Select Existing Certificate, click **Choose a different certificate** and click **Browse...**.
1. In Open, open the file **c:\\certs\\rdweb.pfx**
1. In Select Existing Certificate, under **Password**, type the password you assigned to the PFX file. Click to enable **Allow the certificate to be added to the Trusted Root Certification Authorities certificate store on the destination computer** and click **OK**.
1. In Deployment Properties, click **Apply**.

    Wait for the changes to be applied. For the Role Service RD Gateway, the Level column should be Trusted now.

1. Click the page **RD Gateway**.
1. On page RD Gateway, ensure **Use these RD Gateway server settings** is selected. Ensure, under **Server name**, **remote.adatum.com** is typed in. Ensure, **Logon method** is **Password Authentication**. Ensure, both checkboxes are activated.
1. In Deployment Properties, click **OK**.

## Exercise 2: Verify the RD Gateway

1. [Connect to Remote Desktop Services using RD Web](#task-1-connect-to-remote-desktop-services-using-rd-web) from CL1.
1. [Create an external network switch](#task-2-create-an-external-network-switch) on the host computer
1. [Add a static NetNat mapping](#task-3-add-a-static-netnat-mapping) on the host computer forwarding port 443 to 10.1.200.24 and find out the external IP address of the Perimeter network.
1. [Connect WIN-CL2 to the external network switch](#task-4-connect-win-cl2-to-the-external-network-switch)
1. [Configure the network on the client](#task-5-configure-the-network-on-the-client) CL2: Set the network adapter to use DHCP for all configurations and add remote.adatum.com with the external IP address of the Perimeter network
1. [Connect to Remote Desktop Services from the external network](#task-6-connect-to-remote-desktop-services-from-the-external-network) on CL2

### Task 1: Connect to Remote Desktop Services using RD Web

Perform these steps on CL1.

1. Open **File Explorer**.
1. In File Explorer, navigate to **Downloads**.
1. Delete the file **cpub-Standard_desktop-Standard_desktop-CmsRdsh**, if it is present.

1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to <https://remote.adatum.com/RDWeb>.
1. On page Work Resources, sign in as **AD\Ada**.
1. On page Work Resources, under RemoteApp and Desktops, click **Standard desktop**.
1. Under Downloads, click **Keep**.
1. Under cpub-Standard_desktop-Standard_desktop-CMSRdsh.rdp, click **Open file**.
1. In Remote Desktop connection security warning, ensure, beside **Gateway server**, **remote.adatum.com** is shown. Click **Connect**.
1. In Windows Security, click **More choices** and **Use a different account**. Sign in as **AD\Ada**.

    Wait for the connection to complete.

1. In the connection bar, click the icon *Connection information* ([figure 1]).
1. In Remote Desktop Connection, click **Show details**.

    Beside Gateway name, Not in use is displayed. This is because Remote Desktop Connection determined that the session host is on the same network.

1. Click **OK**.
1. Close the Remote Desktop Connection.

### Task 2: Create an external network switch

Perform these steps on the host computer.

1. Open **Hyper-V-Manager**.
1. In Hyper-V-Manager, in the context-menu of your computer name, click **Virtual Switch Manager**.
1. In Virtual Switch Manager, click **New Virtual Network Switch**. Under What type of switch do you want to create, click **External**. Click **Create Virtual Switch**.
1. Under Virtual Switch Properties, under Name, type **External**. Under **External Network** select a network adapter. Your instructor will help you choose. Ensure, **Allow management operating system to share the network adapter** is activated and click **OK**.
1. In the confirmation dialog, click **Yes**.

### Task 3: Add a static NetNat mapping

Perform these steps on the host computer.

1. Open **Terminal** or **Windows PowerShell** ad Administrator.
1. In Terminal or Windows PowerShell, create a NAT rule to the RD Gateway.

    ````powershell
    $natName = 'Perimeter'
    Add-NetNatStaticMapping -NatName 'Perimeter' -Protocol TCP -ExternalIPAddress "0.0.0.0" -ExternalPort 443 -InternalIPAddress 10.1.200.24 -InternalPort 443
    ````

1. Query the external IP address of the **Perimeter** network and take a note.

    ````powershell
    Get-NetNatExternalAddress -NatName $natName |  
    Where-Object {
        $PSItem.IPAddress -notlike '127.*' `
        -and $PSItem.IPAddress -notlike '169.254.*'
    } |
    Select-Object -First 1 -ExpandProperty IPAddress
    ````

### Task 4: Connect WIN-CL2 to the external network switch

Perform these steps on the host computer.

1. Open **Hyper-V-Manager**.
1. In the context-menu of WIN-CL2, click **Settings**.
1. In Settings for WIN-CL2, click **Network adapter**.
1. Under Virtual Switch, click **External**.
1. Click **OK**.

### Task 5: Configure the network on the client

Perform these steps on CL2.

1. Open **Terminal** as Administrator.
1. Configure the network adapter to use DHCP for all settings.

    ````powershell
    Get-NetAdapter | Set-NetIPInterface -Dhcp Enabled
    Get-NetAdapter | Set-DnsClientServerAddress -ResetServerAddresses
    ````

1. Open the hosts file.

    ````powershell
    notepad.exe C:\windows\System32\drivers\etc\hosts
    ````

1. In the hosts file, add a new line at the end with theh following text. Replace **\<external IP address\>** with the IP address you noted in the previous task.

    ````text
    <external IP address>   remote.adatum.com
    ````

1. Save and close the hosts file.

### Task 6: Connect to Remote Desktop Services from the external network

Perform these steps on CL2.

1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to <https://remote.adatum.com/RDWeb>
1. On page Work Resources, sign in with **AD\Ada**.
1. On page Work Resources, under RemoteApp and Desktops, click **Standard desktop**.
1. Under Downloads, click **Keep**.
1. Under cpub-Standard_desktop-Standard_desktop-CMSRdsh.rdp, click **Open file**.
1. In Remote Desktop connection security warning, ensure, beside **Gateway server**, **remote.adatum.com** is shown. Click **Connect**.
1. In Windows Security, sign in as **AD\Ada**.
1. In the message with Certificate errors, click Yes.

    *Note:* The error occurs, because the certificate revocation list (CRL) is not available to CL2. In a real-world scenario, you should make the CRL of your enterprise root CA available on the public Internet.

    Wait for the connection to complete.

1. In the connection bar, click the icon *Connection information* ([figure 1]).
1. In Remote Desktop Connection, click **Show details**.

    Beside Gateway name, remote.adatum.com is shown.

1. Click **OK**.
1. Close the Remote Desktop Connection.

[figure 1]: /images/Remote-Desktop-Connection-Bar.png