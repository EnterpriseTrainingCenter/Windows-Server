# Lab: Configure high availability for Remote Desktop Services

## Required VMs

* VN1-SRV1
* VN1-SRV8
* VN1-SRV9
* VN1-SRV10
* VN2-SRV1
* VN2-SRV2
* PM-SRV3
* PM-SRV4
* CL1

## Setup

1. On **CL1**, sign in as **ad\\Administrator**.
1. On **VN1-SRV3**, sing in as **.\Administrator**.
1. On **VN2-SRV1**, sing in as **.\Administrator**.
1. On **VN2-SRV2**, sing in as **.\Administrator**.

You must have completed the lab [Configure external access to Remote Desktop Services](Configure-external-access-to-Remote-Desktop-Services.md).

## Introduction

To ensure business continuity of Remote Desktop Services, you want to configure high availability of licensing, RD Web Access, RD Gateway, and RD Connection Broker.

## Exercises

1. [Configure high availability for licensing](#exercise-1-configure-high-availbility-for-licensing)
1. [Configure high availability for RD Web Access](#exercise-2-configure-high-availbility-for-rd-web-access)
1. [Configure high availability for RD Gateway](#exercise-3-configure-high-availability-for-rd-gateway)
1. [Configure high availability for RD Connection Broker](#exercise-4-configure-high-availability-for-rd-connection-broker)
1. [Verify the high availability configuration](#exercise-5-verify-the-high-availability-configuration)

## Exercise 1: Configure high availbility for licensing

1. [Add RD Licensing server](#task-1-add-rd-licensing-server) VN2-SRV2
1. [Configure licensing](#task-2-configure-licensing) per user

### Task 1: Add RD Licensing server

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT SERVERS, click **TASKS**, **Add RD Licensing Servers**.
1. In Add RD Licensing Services, under Server Pool, click **VN2-SRV2.ad.adatum.com**, click the arrow button between the columns and click **Next >**.
1. On page Confirm selections, verify your selection ([figure 1]) and click **Add**.

    Wait for the installation to complete. This will take a few minutes.

1. On page Results, click **Close**.

### Task 2: Configure licensing

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, click **TASKS**, **Edit Deployment Properties**.
1. In Deployment Properties, click the page **RD Licensing**.
1. On page RD Licensing, click **Per User**. Here, you could change the order of licensing server to which license requests are sent.
1. Click **OK**.

## Exercise 2: Configure high availbility for RD Web Access

1. [Add RD Web Access server](#task-1-add-rd-web-access-server) PM-SRV4
1. [Install the certificate for RD Web Access](#task-2-install-the-certificate-for-rd-web-access) again
1. [Add a DNS Record](#task-3-add-a-dns-record) for remote.adatum.com pointing to 10.1.200.32 (PM-SRV4)

*Note*: In real world, instead of creating a DNS round-robin configuration, you would configure a load balancer in front of the RD Web Access servers.

### Task 1: Add RD Web Access Server

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT SERVERS, click **TASKS**, **Add RD Web Access Servers**.
1. In Add RD Web Access Servers, under Server Pool, click **PM-SRV4.ad.adatum.com**, click the arrow button between the columns and click **Next >**.
1. On page Confirm selections, verify your selection ([figure 2]) and click **Add**.

    Wait for the installation to complete. This will take a few minutes.

1. On page Results, click **Close**.

### Task 2: Install the certificate for RD Web Access

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, click **TASKS**, **Edit Deployment Properties**.
1. In Deployment Properties, click the page **Certificates**.

    The Status of RD Web Access should show Error.

1. On page Certificates, click **RD Web Access** and click **Select existing certificate...**.
1. In Select Existing Certificate, click **Choose a different certificate** and click **Browse...**.
1. In Open, open the file **c:\\certs\\rdweb.pfx**
1. In Select Existing Certificate, under **Password**, type the password you assigned to the PFX file. Click to enable **Allow the certificate to be added to the Trusted Root Certification Authorities certificate store on the destination computer** and click **OK**.
1. In Deployment Properties, click **Apply**.

    Wait for the changes to be applied. For the Role Service RD Web Access, the Status column should be OK now.

1. In Deployment Properties, click **OK**.

### Task 3: Add a DNS record

Perform these steps on CL1.

1. Open **DNS**.
1. In DNS Manager, expand **VN1-SRV1.ad.adatum.com**, **Forward Lookup Zones**, and click **adatum.com**.
1. In the context-menu of **adatum.com**, click **New Host (A or AAAA)...**
1. In New Host, under **Name (uses parent domain if blank)**, type **remote**. Ensure, that under **Fully qualified domain name (FQDN)**, **remote.adatum.com** appears. Under **IP address**, type **10.1.200.32**. Click **Add Host**.
1. In The host record remote.adatum.com was successfully created, click **OK**.
1. In New Host, click **Done**.

## Exercise 3: Configure high availability for RD Gateway

1. [Add RD Web Gateway Server](#task-1-add-rd-gateway-server) PM-SRV4
1. [Install the certificate for RD Gateway](#task-2-install-the-certificate-for-rd-gateway) again

*Note:* Because RD Web Access and RD Gateway are installed on the same servers, you do not need to create additional DNS entries. In real world, instead of creating a DNS round-robin configuration, you would configure a load balancer in front of the RD Gateway servers.

### Task 1: Add RD Gateway Server

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT SERVERS, click **TASKS**, **Add RD Gateway Servers**.
1. In Add RD Gateway Servers, under Server Pool, click **PM-SRV4.ad.adatum.com**, click the arrow button between the columns and click **Next >**.
1. On page Confirm selections, verify your selection ([figure 3]) and click **Add**.

    Wait for the installation to complete. This will take a few minutes.

1. On page Results, click **Close**.

### Task 2: Install the certificate for RD Gateway

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, click **TASKS**, **Edit Deployment Properties**.
1. In Deployment Properties, click the page **Certificates**.

    The Status of RD Gateway should show Error.

1. On page Certificates, click **RD Gateway** and click **Select existing certificate...**.
1. In Select Existing Certificate, click **Choose a different certificate** and click **Browse...**.
1. In Open, open the file **c:\\certs\\rdweb.pfx**
1. In Select Existing Certificate, under **Password**, type the password you assigned to the PFX file. Click to enable **Allow the certificate to be added to the Trusted Root Certification Authorities certificate store on the destination computer** and click **OK**.
1. In Deployment Properties, click **Apply**.

    Wait for the changes to be applied. For the Role Service RD Web Access, the Status column should be OK now.

1. In Deployment Properties, click **OK**.

## Exercise 4: Configure high availability for RD Connection Broker

1. [Create an organizational unit](#task-1-create-an-organizational-unit) with the name Organizational groups
1. [Create a domain group for the connection brokers](#task-2-create-a-domain-group-for-the-connection-brokers) with the name RD connection brokers in the OU Organizational groups
1. [Enable the firewall rules for File and Printer Sharing](#task-3-enable-the-firewall-rules-for-file-and-printer-sharing) on VN1-SRV3
1. [Add SQL login](#task-4-add-sql-login) on VN1-SRV3 for the group RD connection brokers and grant it the sysadmin server role
1. [Install Microsoft Visual C++ Redistributable (x64) - 14 on the connection brokers](#task-5-install-microsoft-visual-c-redistributable-x64---14-on-the-connection-brokers) VN2-SRV1 and VN2-SRV2
1. [Install Microsoft ODBC Driver 18 for SQL Server on the connection brokers](#task-6-install-microsoft-odbc-driver-18-for-sql-server-on-the-connection-brokers) VN2-SRV1 and VN2-SRV2
1. [Add DNS records for the connection brokers](#task-7-add-dns-records-for-the-connection-brokers) with the name rdcb.ad.adatum.com pointing to 10.1.2.8 and 10.1.2.16
1. [Configure high availability for the connection broker](#task-8-configure-high-availability-for-the-connection-broker)
1. [Add RD Connection Broker server](#task-9-add-rd-connection-broker-server) VN2-SRV2
1. [Install the certificates for RD Connection Broker](#task-10-install-the-certificates-for-rd-connection-broker) again

*Note*: In real world, instead of creating a DNS round-robin configuration, you would configure a load balancer in front of the RD Connection Broker servers.

### Task 1: Create an organizational unit

#### Active Directory Users and Computers

Perform this task on CL1.

1. Open **Active Directory Users and Computers**.
1. In Active Directory Users and Computers, expand **ad.adatum.com**.
1. In the context-menu of **ad.adatum.com**, click **New**, **Organizational Unit**.
1. In New Object - Organizational Unit, in **Name**, enter **Organizational Groups** and click **OK**.

#### Active Directory Administrative Center

Perform this task on CL1.

1. Open **Active Directory Administrative Center**.
1. In Active Directory Administrative Center, in the context-menu of **ad (local)**, click **New**, **Organizational Unit**.
1. In Create Organizational Unit, in **Name**, enter **Organizational Groups** and click **OK**.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**.
1. Create the organizational unit **Organizational Groups** at the domain level.

    ````powershell
    New-ADOrganizationalUnit `
        -Path 'DC=ad, DC=adatum, DC=com' `
        -Name 'Organizational Groups'
    ````

### Task 2: Create a domain group for the connection brokers

#### Active Directory Users and Computers

Perform this task on CL1.

1. From the desktop, open **Active Directory Users and Computers**.
1. In **Active Directory Users and Computers**, expand **ad.adatum.com**.
1. Click **Organizational Groups**.
1. In the context-menu of Organizational Groups, click **New**, **Group**.
1. In New Object - Group, in **Group name**, type **RD connection brokers**. **Group scope** should be **Global** and **Group type** should be **Security**. Click **OK**.
1. In Active Directory Users and Computers, under Organizations Groups, double-click the group **RD connection brokers**.
1. In RD connection brokers Properties, click the tab **Members**.
1. On the tab Members, click **Add...**.
1. In Select Groups, Contacts, Computers, Service Accounts, or Groups, click **Object Types...**.
1. In Object Types, click to activate **Computers** and click **OK**.
1. In Select Groups, Contacts, Computers, Service Accounts, or Groups, under **Enter the object names to select**, type **VN2-SRV1; VN2-SRV2** and click **Check Names**.

    The computer names should be underlined now.

1. Click **OK**.
1. On the tab Members, click **OK**.

#### Active Directory Administrative Center

Perform this task on CL1.

1. Open **Active Directory Administrative Center**.
1. Click **ad (local)**.
1. Double-click **Organizational groups**.
1. In the pane **Tasks**, click **New**, **Group**.
1. In Create Group, in **Group name**, type **RD connection brokers**.
1. On the left, click **Members**.
1. Under Members, click **Add...**.
1. In Select Groups, Contacts, Computers, Service Accounts, or Groups, click **Object Types...**.
1. In Object Types, click to activate **Computers** and click **OK**.
1. In Select Groups, Contacts, Computers, Service Accounts, or Groups, under **Enter the object names to select**, type **VN2-SRV1; VN2-SRV2** and click **Check Names**.

    The computer names should be underlined now.

1. Click **OK**.
1. In Create Group: RD connection brokers, click **OK**.

### Task 3: Enable the firewall rules for File and Printer Sharing

Perform these steps on VN1-SRV3.

1. In SConfig, enter **15**.
1. Enable the firewall rules of group File and Printer Sharing (group **@FirewallAPI.dll,-28502**).

    ````powershell
    # File and Printer sharing
    Enable-NetFirewallRule -Group '@FirewallAPI.dll,-28502'
    ````

1. Log off.

    ````powershell
    logoff
    ````

### Task 4: Add SQL login

Perform these steps on CL1.

1. Open **SQL Server Management Studio 19**.
1. In Connect to Server, in **Server name**, type **VN1-SRV3.ad.adatum.com** and click **Connect**.
1. In Microsoft SQL Server Management Studio (Administrator), expand **Security**.
1. In the context-menu of **Logins**, click **New Login...**.
1. In Login - New, on page General, beside Login name, click **Search...**.
1. In select User or Group, click **Locations...**
1. In Locations, click **Entire Directory** and click **OK**.
1. In Select User, Service Account, or Group, click **Object types...**
1. In Object Types, click to active **Groups** and click **OK**.
1. In Select User, Service Account, or Group, under Enter the object name to select, type **RD connection brokers** and click **Check names**.

    The group name should be underlined now.

1. Click **OK**.
1. In Login - New, click the page **Server Roles**.
1. On page Server Roles, click to activate **sysadmin** ([figure 4]).
1. Click **OK**.

### Task 5: Install Microsoft Visual C++ Redistributable (x64) - 14 on the connection brokers

Perform these steps on VN2-SRV1.

1. Open **Microsoft Edge**.
1. In Microsoft edge, navigate to <https://aka.ms/vs/15/release/vc_redist.x64.exe>.

    Wait for the download to complete. This will take a few seconds.

1. Under Downloads, under VC-redist.x64.exe, click **Open file**.
1. In Microsoft Visual C++ Redistributable (x64) - 14.16.27052 (32 bit), click to activate **I agree to the license terms and conditions** and click **Install** ([figure 5]).

    Wait for the setup to be successful. This will take a few seconds.

1. Click close.

Repeat these steps on VN2-SRV2.

### Task 6: Install Microsoft ODBC Driver 18 for SQL Server on the connection brokers

Perform these steps on VN2-SRV1.

1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to <https://go.microsoft.com/fwlink/?linkid=2280794>.

    Wait for the download to complete. This will take a few seconds.

1. Under Downloads, under msodbcsql.msi, click **Open file**.
1. In Microsoft ODBC Driver 18 for SQL Server Setup, on page Welcome to the Installation Wizard for ODBC Driver 18 for SQL Server, click **Next >**.
1. On page License Agreement, click **I accept the terms in the license agreement** and click **Next >**.
1. On page Feature Selection, ensure the status of **Client components** is **Will be installed on the local hard drive** ([figure 6]), and click **Next >**.
1. On page Ready to Install the Program, click **Install**.

    Wait for the installation to complete. This will take a few seconds.

1. On page Completing the ODBC Driver 18 for SQL Server installation, click **Finish**.
1. Restart the computer.

Repeat these steps on VN2-SRV2.

### Task 7: Add DNS records for the connection brokers

Perform these steps on CL1.

1. Open **DNS**.
1. In DNS Manager, expand **VN1-SRV1.ad.adatum.com**, **Forward Lookup Zones**, and click **ad.adatum.com**.
1. In the context-menu of **ad.adatum.com**, click **New Host (A or AAAA)...**
1. In New Host, under **Name (uses parent domain if blank)**, type **rdcb**. Ensure, that under **Fully qualified domain name (FQDN)**, **rdcb.ad.adatum.com** appears. Under **IP address**, type **10.1.2.8**. Click **Add Host**.
1. In The host record remote.adatum.com was successfully created, click **OK**.
1. In New Host, under **Name (uses parent domain if blank)**, type **rdcb**. Ensure, that under **Fully qualified domain name (FQDN)**, **rdcb.ad.adatum.com** appears. Under **IP address**, type **10.1.2.16**. Click **Add Host**.
1. In New Host, click **Done**.

### Task 8: Configure high availability for the connection broker

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, in the context-menu of **RD Connection Broker**, click **Configure High Availability**.
1. In Configure RD Connection Broker for High Availability, on page Before You Begin, click **Next >**.
1. On page Configuration type, click **Dedicated database server**, and click **Next >**.
1. On page Configure High Availabiality, under **DNS name for the RD Connection Broker cluster**, type **rdcb.ad.adatum.com**. Under connection string, type **DRIVER=ODBC Driver 18 for SQL Server;SERVER=VN1-SRV3.ad.adatum.com;DATABASE=RDConnections;Trusted_Connection=Yes;Encrypt=Optional**.
1. On page Confirmation, verify your selections ([figure 7]) and click **Configure**.

    Wait for the configuration to finish.

1. Click **Close**.

### Task 9: Add RD Connection Broker server

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, in the contex-menu of **RD Connection Broker**, click **Add RD Connection Broker Server**.
1. In Add RD Connection Broker Servers, click **Next >**.
1. On page Server Selection, under Server Pool, click **VN2-SRV2.ad.adatum.com**, click the arrow button between the columns and click **Next >**.
1. On page Confirm selections, verify your selection ([figure 8]) and click **Add**.

    Wait for the installation to complete. This will take a few minutes.

1. On page Results, click **Close**.

### Task 10: Install the certificates for RD Connection Broker

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, click **TASKS**, **Edit Deployment Properties**.
1. In Deployment Properties, click the page **Certificates**.

    The Status of RD connection Broker - Enable Single Sign On and RD Connection Broker - Publishing should show Error.

1. On page Certificates, click **RD connection Broker - Enable Single Sign On** and click **Select existing certificate...**.
1. In Select Existing Certificate, click **Choose a different certificate** and click **Browse...**.
1. In Open, open the file **c:\\certs\\rdcb.pfx**
1. In Select Existing Certificate, under **Password**, type the password you assigned to the PFX file. Click to enable **Allow the certificate to be added to the Trusted Root Certification Authorities certificate store on the destination computer** and click **OK**.
1. In Deployment Properties, click **Apply**.

    Wait for the changes to be applied. For the Role Service RD connection Broker - Enable Single Sign On, the Status column should be OK now.

1. Repeat steps 5 - 9 for **RD Connection Broker - Publishing**.
1. In Deployment Properties, click **OK**.

## Exercise 5: Verify the high availability configuration

Connect to Remote Desktop Services using RD Web from CL1.

If time allows, you might want to try to pause various VMs in Hyper-V to verify the business continuity. However, because of the lack of a real load balancer, the DNS round-robin configuration might require several connection attempts after a server becomes unavailable.

### Task: Connect to Remote Desktop Services using RD Web

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

1. Close the Remote Desktop Connection.


[figure 1]: /images/Add-RD-Licensing-Servers-Confirm-selections.png
[figure 2]: /images/Add-RD-Web-Access-Servers-Confirm-selections.png
[figure 3]: /images/Add-RD-Gateway-Servers-Confirm-selections.png
[figure 4]: /images/SQL-Login-New.png
[figure 5]: /images/Microsoft-Visual-C++-2017-Redistributable.png
[figure 6]: /images/Microsoft-ODBC-Driver-18-for-SQL-Server-Setup.png
[figure 7]: /images/Configure-RD-Connection-Broker-for-High-Availability.png
[figure 8]: /images/Add-RD-Connection-Broker-Servers-Confirm-selections.png
