# Practice: Create an exportable web server certificate template

## Required VMs

* VN1-SRV1
* VN1-SRV2

## Task

Duplicate the web server certificate template with the display name Web Server explorable and the name WebServerexportable. For the new template, make the private key exportable, grant the computer CL1 Enroll permissions and make the template evailable on the enterprise root certification authority.

## Instructions

Perform these steps on VN1-SRV2.

1. Sign in as **AD\Administrator**.
1. Open **Certification Authority**.
1. In certsrv - \[Certification Authority (Local)\], expand **WORKGROUP-...-CA** and click on **Certificate Templates**.
1. In the context-menu of **Certificate Templates**, click **Manage**.
1. In Certificate Templates Console, in the context-menu of **Web Server**, click **Duplicate Template**.
1. In Properties of New Template, the tab **General**.
1. On the tab General, under **Template display name**, type **Web Server exportable**. Ensure that the **Template name** is **WebServerexportable**. Click the tab **Request Handling**.
1. On the tab Request Handling, click to activate **Allow private key to be exported**. Click the tab **Security**.
1. On the tab Security, click **Add...**.
1. In Select Users, Computers, Service Accounts, or Groups, click **Object Types...**.
1. In Object Types, click to activate **Computers** and click **OK**.
1. In Select Users, Computers, Service Accounts, or Groups, under **Enter the object names to select**, type **CL1** click **Check Names**.

    The CL1 should be underlined now.

1. Click **OK**.
1. In Properties of New Template, click **CL1$** and, under Permissions for CL1$, in the column **Allow**, click to activate **Enroll**. Click **OK**.
1. Close **Certificate Template Console**.
1. In certsrv - \[Certification Authority (Local)\], in the context-menu of **Certificate Templates**, click **New**, **Certificate Template to Issue**.
1. In Enable Certificate Templates, click **Web Server exportable** and click **OK**.
