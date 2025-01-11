# Lab: Deploy Remote Desktop Services

## Required VMs

* VN1-SRV1
* VN1-SRV8
* VN1-SRV9
* VN1-SRV10
* VN2-SRV1
* PM-SRV3
* CL1

## Setup

On **CL1**, sign in as **ad\\Administrator**.

If you skipped the practice [Explore Server Manager](../Practices/Explore-Server-Manager.md), on CL1, run ````C:\LabResources\Solutions\Add-ServerManagerServers.ps1````.
You must have completed the practice [Request and export certificates for the connection broker and RD web](../Practices/Request-and-export-certificates-for-the-connection-broker-and-RD-web.md)

## Introduction

Your company wants to create a full Remote Desktop Services session deployment. For the first tests, you want to implemnt a simple deployment consisting of a connection broker, three session hosts, an RD web and RD licensing. Moreover, you want to test the load balancing and reconnection of users between session hosts.

## Exercises

1. [Create an initial Remote Desktop Services deployment](#exercise-1-create-an-initial-remote-desktop-services-deployment)
1. [Verify the functionality of the Remote Desktop Services deployment](#exercise-2-verify-the-functionality-of-the-remote-desktop-services-deployment)
1. Configure session collection settings

## Exercise 1: Create an initial Remote Desktop Services deployment

1. [Create a Remote Desktop Services Installation](#task-1-create-a-remote-desktop-services-installation) with VN2-SRV1 as RD Connection Broker server, PM-SRV3 as RD Web Access server, and VN1-SRV8, VN1-SRV9, and VN1-SRV10 as RD Session Host servers.
1. [Install the certificate for the connection broker](#task-2-install-the-certificate-for-the-connection-broker)
1. [Install the certificate for RD Web](#task-3-install-the-certificate-for-rd-web)
1. [Install RD Licensing](#task-4-install-rd-licensing) on VN2-SRV1
1. [Create a collection](#task-5-create-a-collection) with the name Standard Desktop including all session hosts
1. [Configure session collection settings](#task-6-configure-session-collection-settings): Disconnected session should end after 3 hours, idle sessions should be disconnected after 5 minutes.

### Task 1: Create a Remote Desktop Services Installation

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Manage**, **Add Roles and Features**.
1. In the Add Roles and Features Wizard, Before You Begin, click **Next >**.
1. On page Select installation type, click **Remote Desktop Services Installation**, and click **Next >**.
1. On page Select deployment type, click **Standard deployment**, and click **Next >**.
1. On page Select deployment scenario, click **Session-based desktop deployment**, and click **Next >**.
1. On page Specify RD Connection Broker server, under **Server Pool**, click **VN2-SRV1.ad.adatum.com**, click the arrow button between the lists, and click **Next >**.
1. On page Specify RD Web Access server, under **Server Pool**, click **PM-SRV3.ad.adatum.com**, click the arrow button between the lists, and click **Next >**.
1. On page Specify RD Session Host servers, under **Server Pool**, click **VN1-SRV8.ad.adatum.com**, hold down the CTRL key, and click **VN1-SRV9.ad.adatum.com** and **VN1-SRV10.ad.adatum.com**. Click the arrow button between the lists and click **Next >**.
1. On page Confirm selections, verify your selections, click to activate **Restart the destination server automatically if required**, and click **Deploy**.

    Wait for the deployment to complete. This will take a few minutes.

1. On page View progress, click **Close**.

### Task 2: Install the certificate for the connection broker

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, click **TASKS**, **Edit Deployment Properties**.
1. In Deployment Properties, click the page **Certificates**.
1. On page Certificates, click **RD Connection Broker - Enable Single Sign On** and click **Select existing certificate...**.
1. In Select Existing Certificate, click **Choose a different certificate** and click **Browse...**.
1. In Open, open the file **c:\\certs\\rdcb.pfx**
1. In Select Existing Certificate, under **Password**, type the password you assigned to the PFX file. Click to enable **Allow the certificate to be added to the Trusted Root Certification Authorities certificate store on the destination computer** and click **OK**.
1. In Deployment Properties, click **Apply**.

    Wait for the changes to be applied. For the Role Service RD Connection Broker - Enable Single Sign On, the Level column should be Trusted now.

1. Click **RD Connection Broker - Publishing** and click **Select existing certificate...**.

    Repeat steps 6 - 9.

1. In Deployment Properties, click **OK**.

### Task 3: Install the certificate for RD Web

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT OVERVIEW, click **TASKS**, **Edit Deployment Properties**.
1. In Deployment Properties, click the page **Certificates**.
1. On page Certificates, click **RD Web Access** and click **Select existing certificate...**.
1. In Select Existing Certificate, click **Choose a different certificate** and click **Browse...**.
1. In Open, open the file **c:\\certs\\rdweb.pfx**
1. In Select Existing Certificate, under **Password**, type the password you assigned to the PFX file. Click to enable **Allow the certificate to be added to the Trusted Root Certification Authorities certificate store on the destination computer** and click **OK**.
1. In Deployment Properties, click **Apply**.

    Wait for the changes to be applied. For the Role Service RD Web Access, the Level column should be Trusted now.

1. In Deployment Properties, click **OK**.

### Task 4: Install RD Licensing

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, under DEPLOYMENT SERVERS, click **TASKS**, **Add RD Licensing Servers**.
1. In Add RD Licensing Servers, on page Server selection, click **VN2-SRV1.ad.adatum.com**, click the arrow button between the lists, and click **Next >**.
1. On page Confirm selections, click **Add**.

### Task 5: Create a collection

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, in the left pane, click **Collections**.
1. In Collections, under COLLECTIONS, click **Tasks**, **Create Session Collection...**
1. In the Create Collection wizard, click **Next >**.
1. On page Collection Name, under **Name**, type **Standard desktop** and click **Next >**.
1. On page RD Session Host, click **VN1-SRV.ad.adatum.com** and click the arrow button between the lists. Repeat this for **VN1-SRV9.ad.adatum.com** and **VN1-SRV10.ad.adatum.com**. Click **Next >**.
1. On page User Groups, ensure, under User Groups AD\Domain Users is listed. Click **Next >**.
1. On page User Profile Disks, click to deactivate **Enable user profile disks**. Click **Next >**.
1. On page Confirmation, confirm your selections and click **Create**.

    Wait for the collection to be created successfully.

1. On page Progress, click **Close**.

### Task 6: Configure session collection settings

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, in the left pane, click **Standard desktop**.
1. In Standard desktop, under Properties, click **TASKS**, **Edit Properties...**
1. In Standard desktop Properties, click the page Session.
1. On the page Session, beside **End a disconnected session**, click 3 hours. Beside Idle session limit, click **5 Minutes**. Click **OK**.

## Exercise 2: Verify the functionality of the Remote Desktop Services deployment

1. [Connect to Remote Desktop Services using RD Web and the connection broker](#task-1-connect-to-remote-desktop-services-using-rd-web-and-the-connection-broker) with AD\Ada
1. [Inspect the RDP file](#task-2-inspect-rdp-file)
1. [Verify load balancing between session hosts](#task-3-verify-load-balancing-between-session-hosts) by connecting with the users AD\Boyd and AD\Claire
1. [Verify reconnection to the same host](#task-4-verify-reconnection)
1. [Log off remote users](#task-5-log-off-remote-users)

### Task 1: Connect to Remote Desktop Services using RD Web and the connection broker

Perform these steps on CL1.

1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to <https://PM-SRV3.ad.adatum.com/RDWeb>.
1. On page Work Resources, sign in as **AD\Ada**.
1. On page Work Resources, under RemoteApp and Desktops, click **Standard desktop**.
1. Under Downloads, click **Keep**.
1. Under cpub-Standard_desktop-Standard_desktop-CMSRdsh.rdp, click **Open file**.
1. In Remote Desktop connection security warning, click **Connect**.
1. In Windows Security, click **More choices** and **Use a different account**. Sign in as **AD\Ada**.

    Wait for the connection to complete.

1. In the connection bar, click the icon *Connection information* ([figure 1]).
1. In Remote Desktop Connection, click **Show details**.

    Beside Remote computer, either VN1-SRV8.ad.adatum.com, VN1-SRV9.ad.adatum.com, or VN1-SRV10.ad.adatum.com should be shown.

1. Click **OK**.
1. Open some application such as Paint or Notepad.
1. In the connection bar, click the icon *Close*.

### Task 2: Inspect RDP file

Perform these steps on CL1.

1. Open **File Explorer**.
1. In File Explorer, navigate to **Downloads**.
1. In Downloads, in the context-menu of **cpub-Standard_desktop-Standard_desktop-CmsRdsh**, click **Open with**, **Choose another app**.
1. In Select an app to open this .rdp file, click **Notepad** or **Editor** and **Just once**.
1. In Notepad, inspect the file. Especially, look out for the following lines, which designate the connection broker and the collection:

    ````text
    workspace id:s:VN2-SRV1.ad.adatum.com
    use redirection server name:i:1
    loadbalanceinfo:s:tsv://MS Terminal Services Plugin.1.Standard_desktop
    ````

### Task 3: Verify load balancing between session hosts

Perform these steps on CL1.

1. Open **File Explorer**.
1. In File Explorer, navigate to **Downloads**.
1. In Downloads, double-click **cpub-Standard_desktop-Standard_desktop-CmsRdsh**.
1. In Remote Desktop connection security warning, click **Connect**.
1. In Windows Security, click **More choices** and **Use a different account**. Sign in as **AD\Boyd**.

    Wait for the connection to complete.

1. Open some application such as Paint or Notepad.
1. In the connection bar, click the icon *Close*.
1. Repeat steps 3 - 7, but sign in as **AD\Claire**.
1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, click **Collections**.

    Under CONNECTIONS, verify that you see three connections from Ada, Boyd, and Claire. Each should be connected to a different session host.

### Task 4: Verify reconnection

Perform these steps on CL1.

1. Open **File Explorer**.
1. In File Explorer, navigate to **Downloads**.
1. In Downloads, double-click **cpub-Standard_desktop-Standard_desktop-CmsRdsh**.
1. In Remote Desktop connection security warning, click **Connect**.
1. In Windows Security, sign in as **AD\Claire**.
1. The application you opened before should still be open.
1. In the connection bar, click the icon *Close*.

### Task 5: Log off remote users

Perform these steps on CL1.

1. Open **Server Manager**.
1. In Server Manager, click **Remote Desktop Services**.
1. In Remote Desktop Services > Overview, click **Collections**.
1. Under CONNECTIONS, in the context-menu of each connection, click **Log off**.

[figure 1]: /images/Remote-Desktop-Connection-Bar.png