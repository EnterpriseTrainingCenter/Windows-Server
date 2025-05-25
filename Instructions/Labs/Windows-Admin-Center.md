# Lab: Windows Admin Center

<!-- Required time: 75 minutes -->

## Required VMs

* VN1-SRV1
* VN1-SRV2
* VN1-SRV4
* VN1-SRV5
* CL1
* CL2

## Setup

1. On **CL1**, sign in as **ad\Administrator**.
1. Open **Terminal**.
1. Set permissions on the Web Server certificate template.

    ````powershell
    C:\LabResources\Solutions\Set-CertTemplatePermissions.ps1 `
        -Template 'WebServer' -ComputerName 'VN1-SRV4'
    ````

1. On **CL2**, sign in as **ad\Pia**.
1. On **VN1-SRV4**, sign in as **ad\Administrator**.
1. In SConfig, enter **15**.

You need sign-in credentials for an active Azure Subscription in which you have the permissions to create resources. Moreover, you need to have the Global Administrator role in Microsoft Entra ID. Ask your instructor for help, if you are unsure.

## Introduction

Adatum wants to use Windows Admin Center for server management. After installing Windows Admin Center, Adatum wants to add all computers efficiently. Moreover, Adatum wants to integrate Windows Admin Center with Azure. Furthermore, Adatum wants to restrict access to Windows Admin Center and wants some users in IT to manage servers through Windows Admin Center without granting adding them to the local Administrators group.

## Exercises

1. [Installing Windows Admin Center](#exercise-1-installing-windows-admin-center)
1. [Configuring Windows Admin Center](#exercise-2-configuring-windows-admin-center)
1. [Securing Windows Admin Center](#exercise-3-securing-windows-admin-center)

## Exercise 1: Installing Windows Admin Center

1. [Install the Remote Server Administration DNS Server Tools](#task-1-install-the-remote-server-administration-dns-server-tools) on CL1
1. [Download Windows Admin Center](#task-2-download-windows-admin-center)
1. [Request a certificate](#task-3-request-a-certificate) on VN1-SRV4 using the web server template
1. [Install Windows Admin Center](#task-4-install-windows-admin-center)
1. [Add a DNS host record for Windows Admin Center](#task-5-add-a-dns-host-record-for-windows-admin-center)
1. [Verify Windows Admin Center loads](#task-6-verify-windows-admin-center-loads)

    > Are there any connections added by default?

### Task 1: Install the Remote Server Administration DNS Server Tools

#### Desktop experience

Perform these steps on CL1.

1. Open **Settings**.
1. In Settings, click **System**.
1. In System, click **Optional features**.
1. In Optional features, click the button **View features**.
1. In Add an optional feature, in the text field **Find an available optional feature**, type **RSAT**.
1. Activate the check box beside **RSAT: DNS Server Tools**.
1. Click **Next**.
1. Click **Install**.
1. If required, restart the computer.

You do not need to wait for the completion of the installation

#### PowerShell

Perform these steps on CL1.

1. In the context menu of **Start**, click **Terminal (Admin)**.
1. Add the windows capabilities **RSAT: Server DNS Server tools**.

    ````powershell
    Get-WindowsCapability -Online -Name 'Rsat.Dns.Tools*' |
    Add-WindowsCapability -Online
    ````

You do not need to wait for the completion of the installation.

### Task 2: Download Windows Admin Center

#### Desktop experience

Perform these steps on CL1.

1. Open Microsoft Edge and navigate to <https://aka.ms/WACDownload>.
1. Open **Terminal**.
1. Copy the setup file to **C:\LabResources** on **VN1-SRV4**.

    ````powershell
    $pSSession = New-PSSession -ComputerName VN1-SRV4
    Copy-Item `
        -Path ~\Downloads\WindowsAdminCenter*.exe `
        -Destination C:\LabResources\WindowsAdminCenter.exe `
        -ToSession $pSSession
    Remove-PSSession -Session $pSSession
    ````

#### PowerShell

Perform these steps on CL1.

1. Open **Terminal**.
1. On **VN1-SRV4**, download Windows Admin Center from **https://aka.ms/WACDownload** and save it as **C:\LabResource\WindowsAdminCenter.exe**.

    ````powershell
    Invoke-Command -ComputerName VN1-SRV4 -ScriptBlock {
        Start-BitsTransfer `
            -Source 'https://aka.ms/WACDownload' `
            -Destination 'C:\LabResources\WindowsAdminCenter.exe'
    }
    ````

### Task 3: Request a certificate

Perform this task on VN1-SRV4.

1. Store the hostname and FQDN of VN1-SRV4 in variables.

    ````powershell
    $hostName = 'admincenter'
    $fQDN = "$hostName.ad.adatum.com"
    ````

1. Request a certificate for **VN1-SRV4** using the template **WebServer**. Make sure, the certificate is valid for the FQDN as well as the hostname only.

    ````powershell
    $certificate = (
        Get-Certificate `
            -Template 'WebServer' `
            -SubjectName "CN=$fQDN" `
            -DnsName $fQDN `
            -CertStoreLocation 'Cert:\LocalMachine\My'
        ).Certificate
    ````

### Task 4: Install Windows Admin Center

#### Desktop experience

Perform this task on VN1-SRV4.

1. Launch the installer.

    ````powershell
    C:\LabResources\WindowsAdminCenter.exe
    ````

1. In Windows Admin Center (v2) installer, on page Welcome to the Microsoft Admin Center setup wizard, click **Next**.
1. On page License Terms and Privacy Statement, click **I accept these terms and understand the privacy statement** and click **Next**.
1. On page Select installation mode, click **Custom setup** and click **Next**.
1. On page Network access, ensure **Remote access. Use Machine name or FQDN to access Windows Admin Center on other devices.** is selected and click **Next**.
1. On page Login Authentication/Authorization Selection, ensure **HTML Form Login** is selected and cick **Next**.
1. On page Port numbers, under **External Port**, ensure **443** is filled in and click **Next**.
1. On page Select TLS certificate, click **Use the pre-installed TLS certificate** and click **Next**.
1. Switch to **C:\Windows\system32\cmd.exe**.
1. Get the certificate. If you left everything open and the variable ````$certificate```` contains a value from the previous task, you may skip this step.

    ````powershell
    $now = Get-Date
    $certificate = `
        Get-ChildItem 'Cert:\LocalMachine\My' | 
        Where-Object { 
            $PSItem.Subject -eq 'CN=admincenter.ad.adatum.com' `
            -and $now -gt $PSItem.NotBefore `
            -and $now -lt $PSItem.NotAfter `
        } | 
        Sort-Object NotAfter -Descending | Select-Object -First 1
    ````

1. Copy the thumbprint of the requested certificate to the clipboard.

    ````powershell
    $certificate.Thumbprint
    Set-Clipboard -Value $certificate.Thumbprint
    ````

1. Switch to **Windows Admin Center (v2) Installer**.
1. On page TLS certificate thumbprint, under **Select Thumbprint of TLS certificate**, either press CTRL + V to paste the thumbprint from the clipboard or select the thumbprint you found out in the previous steps from the drop-down. Verify that in the text box below certificate details appear, where **Subject** is **CN=admincenter.ad.adatum.com** and **DnsNameList** contains **admincenter.ad.adatum.com**. Click **Next**.
1. On page Fully qualified domain name, under **FQDN**, type **admincenter.ad.adatum.com** and click **Next**.
1. On page Trusted Hosts, ensure **Allow access to any computer** is selected and click **Next**.
1. On page WinRM over HTTPS, ensure **HTTP. Default communication mechanism** is selected and click **Next**.
1. On page Automatic updates, verify that **Install updates automatically (recommended) is selected** and click **Next**.
1. On page Send diagnostic data to Microsoft, select your preferred option and click **Next**.
1. On page Ready to install, verify all options and click **Install**.

    Wait for the installation to complete. This should take less than a minute.

1. On page Completing the Windows Admin Center (v2) Setup Wizard, click to clear **Start Windows Admin Center: https://admincenter.ad.adatum.com:443** and click **Finish**.
1. In C:\Windows\system32\cmd.exe, start the service **windowsadmincenter**

    ````powershell
    Start-Service windowsadmincenter
    ````

#### PowerShell

Perform this task on VN1-SRV4.

1. Get the certificate. If you left everything open and the variable ````$certificate```` contains a value from the previous task, you may skip this step.

    ````powershell
    $now = Get-Date
    $certificate = `
        Get-ChildItem 'Cert:\LocalMachine\My' | 
        Where-Object { 
            $PSItem.Subject -eq 'CN=admincenter.ad.adatum.com' `
            -and $now -gt $PSItem.NotBefore `
            -and $now -lt $PSItem.NotAfter `
        } | 
        Sort-Object NotAfter -Descending | Select-Object -First 1
    ````

1. Install Windows Admin Center.

    ````powershell
    Start-Process `
        -FilePath 'C:\LabResources\WindowsAdminCenter.exe' `
        -ArgumentList '/VERYSILENT' `
        -Wait
    ````

    Wait for the installation to complete. This should take about a minute.

1. Import the Windows Admin Center Configuration module.

    ````powershell
    Import-Module `
        'C:\Program Files\WindowsAdminCenter\PowerShellModules\Microsoft.WindowsAdminCenter.Configuration\Microsoft.WindowsAdminCenter.Configuration.psd1'
    ````

1. Configure Windows Admin Center to use the certificate.

    ````powershell
    Remove-WACSelfSignedCertificate
    Set-WACCertificateSubjectName `
        -SubjectName $certificate.Subject `
        -Thumbprint $certificate.thumbprint `
        -Target All
    Set-WACCertificateAcl -SubjectName $certificate.Subject
    ````

1. Set the FQDN for the endpoint to **admincenter.ad.adatum.com**.

    ````powershell
    Set-WACEndpointFqdn -EndpointFqdn 'admincenter.ad.adatum.com'
    ````

1. Start the WAC service.

    `````powershell
    Start-WACService
    ````

### Task 5: Add a DNS host record for Windows Admin Center

#### Desktop Experience

Perform this task on CL1.

1. Open **DNS**.
1. In Connet to DNS Server, click **The following computer**, type **vn1-srv1.ad.adatum.com** below and click **OK**.
1. Expand **vn1-srv1.ad.adatum.com**, **Forward Lookup Zones**, and click **ad.adatum.com**.
1. In the context-menu of **adatum.com**, click **New Host (A or AAAA)...**
1. In New Host, under **Name (uses parent domain name if blank)**, type **admincenter**. Under IP address, type **10.1.1.32**. Click **Add Host**.
1. In the message box The host record admincenter.ad.adatum.com was successfully created, click **OK**.
1. In **New Host**, click **Done**.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**
1. On **VN1-SRV1**, in zone **ad.adatum.com**, create an A record with the name **admincenter** and the IPv4 address **10.1.1.32**.

    ````powershell
    Add-DnsServerResourceRecordA `
        -ComputerName VN1-SRV1 `
        -ZoneName ad.adatum.com `
        -Name admincenter `
        -IPv4Address 10.1.1.32
    ````

### Task 6: Verify Windows Admin Center loads

Perform this task on CL1.

1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to **https://admincenter.ad.adatum.com**.
1. On page Sign in to Windows Admin Center, sign in as **ad\Administrator**.

    Windows Admin Center should load.

    > The gateway **VN1-SRV4** is already added as connection.

## Exercise 2: Configuring Windows Admin Center

1. [Create shared connections from a CSV file](#task-1-create-shared-connections-from-a-csv-file) to all servers and clients in Active Directory

    > Why are you prompted for credentials when clicking on one of the imported connections?

1. [Manage extensions](#task-2-manage-extensions): ensure automatic update is enabled and install the Active Directory extension
1. [Register Windows Admin Center with Azure](#task-3-register-windows-admin-center-with-azure)
1. [Validate access by users](#task-4-validate-access-by-users)

    > Can Pia access Windows Admin Center and see all shared connections?

    > Can Pia get administrative access to a server through Windows Admin Center?

### Task 1: Create shared connections from a CSV file

Perform this task on CL1.

1. Open **Terminal**.
1. Create a CSV file with all server computers.

    ````powershell
    $path = '~\Documents\computers.csv'
    Get-ADComputer -Filter { Name -like 'VN*-*' -or Name -like 'PM-*' } |
    Select-Object `
        @{ name = 'name'; expression = { $PSItem.DNSHostName } }, `
        @{
            name = 'type'
            expression = { 'msft.sme.connection-type.server' }
        }, `
        @{ name = 'tags'; expression = {} }, `
        @{ name = 'groupId'; expression = { 'global' } } |
    Export-Csv -Path $path -NoTypeInformation -Force
    ````

1. Append all client computers to the CSV file.

    ````powershell
    Get-ADComputer -Filter { Name -like 'CL*' } |
    Select-Object `
        @{ name = 'name'; expression = { $PSItem.DNSHostName } }, `
        @{ 
            name = 'type'
            expression = { 'msft.sme.connection-type.windows-client' }
        }, `
        @{ name = 'tags'; expression = {} }, `
        @{ name = 'groupId'; expression = { 'global' } } |
    Export-Csv -Path $path -Append
    ````

    If you want, you may take a look at the CSV file in your Documents folder.

1. Create a remote PowerShell session to **VN1-SRV4**.

    ````powershell
    $pSSession = New-PSSession -ComputerName VN1-SRV4
    ````

1. Copy the PowerShell modules for Windows Admin Center to CL1.

    ````powershell
    Copy-Item `
        -FromSession $pSSession `
        -Path "$env:ProgramFiles\WindowsAdminCenter\PowerShellModules\*" `
        -Destination '~\Documents\Windows PowerShell\Modules\' `
        -Recurse
    ````

1. Import the Connection Tools module.

    ````powershell
    Import-Module `
        '~\Documents\Windows PowerShell\Modules\Microsoft.WindowsAdminCenter.ConnectionTools\Microsoft.WindowsAdminCenter.ConnectionTools.psd1'
    ````

1. Store the credentials for **ad\Administrator** in a variable.

    ````powershell
    $credential = Get-Credential
    ````

1. In Windows PowerShell Credential Request, enter the credentials of **ad\Administrator**.
1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to <https://admincenter.ad.adatum.com>.
1. On page Sign in to Windows Admin Center, sign in as **ad\Administrator**.
1. Click *Settings*.
1. In Settings, under **Gateway**, click **Access**.
1. On page Gateway access, click to activate **Reveal Access key**. Below, beside the access key, click **Copy**.
1. Switch back to **Terminal**.
1. Save the access key to a variable.

    ````powershell
    # Replace the string with the text from your clipboard
    $accessKey = Get-Clipboard -Format Text -TextFormatType Text
    ````

1. Import connections from the CSV file.

    ````powershell
    Import-WACConnection `
        -FileName $path `
        -Endpoint 'https://admincenter.ad.adatum.com' `
        -Credentials $credential `
        -AccessKey $accessKey
    ````

1. Switch to **Microsoft Edge**.
1. In Microsoft Edge, click **Windows Admin Center**.

    You should see connections to all servers and clients in Active Directory.

1. Click *Settings*.
1. In Settings, click **Shared Connections**.

    All imported connections are shared connections and are visible for all users.

1. Click **Windows Admin Center** to return to the connections page.

### Task 2: Manage extensions

Perform this task on CL1.

1. Open **Microsoft Edge** and navigate to <https://admincenter.ad.adatum.com>.
1. Click *Settings*.
1. In Settings, click **Extensions**.
1. In Extensions, ensure the switch **Automatically update extension** is enabled.
1. On tab Available Extensions, **GPUs** and click **Install**.

    Wait for Windows Admin Center to reload.

You may repeat the last step for other extensions at your choice.

### Task 3: Register Windows Admin Center with Azure

Perform this task on CL1.

1. Open **Microsoft Edge** and navigate to <https://admincenter>.
1. In Windows Admin Center, click *Settings*.
1. In Settings, ensure **Account** is selected.
1. In Account, click **Register with Azure**.
1. Under Register with Azure, click **Register**.
1. In the pane Get started with Azure in Windows Admin Center, under **Select an Azure cloud**, ensure **Azure Global** is selected.
1. Under **Copy this code**, click **Copy** and click **Enter the code**.

    In Microsoft Edge, a new tab opens.

1. Under **Enter code**, paste the copied code and click **Next**.
1. Sign in to Microsoft Azure.
1. Under **Are you trying to sign in to Windows Admin Center**, click **Continue**.
1. If you see the message You have signed in to the Windows Admin Center application on your device. You may now close this window, close the tab.
1. In **Windows Admin Center**, on the pane **Get started with Azure in Windows Admin Center**, under **Azure Active Directory (tenant) ID**, ensure the correct ID is selected.

    If you are unsure about the correct ID, perform these steps:

    1. Open a new tab.
    1. Navigate to <https://portal.azure.com> and sign in if necessary.
    1. On the top-right, click your user avatar and click **Switch directory**.
    1. If your Directory is not Current, beside your Directory name, click **Switch**.
    1. In the search box at the top, type **Microsoft Entra ID** and click **Microsoft Entra ID**.
    1. In Microsoft Entra ID, on the page **Overview**, take a note of **Tenant ID**.

1. Under **Azure Active Directory application**, ensure **Create new** is selected and click **Connect**.

    Wait for the message **Now connected to Microsoft Entra ID** to appear. This can take a few minutes.

1. Click **Sign in**.
1. In the dialog Permissions requested, click **Accept**.

### Task 4: Validate access by users

Perform this task on CL2.

1. Open **Microsoft Edge** and navigate to <https://admincenter.ad.adatum.com>.
1. Sign in with the credentials of **ad\Pia**.

    > Pia can access Windows Admin Center and sees all connections.

1. Click **vn1-srv5.ad.adatum.com**.

    > The pane Specify your credentials opens, because Pia does not have administrative permissions on this server.

## Exercise 3: Securing Windows Admin Center

1. [Create groups in Active Directory](#task-1-create-groups-in-active-directory): Create an organizational unit named Entitling groups and, within that organizational unit, the domain-local groups Windows Admin Center users and Windows Admin Center administrators.
1. [Restrict access to Windows Admin Center](#task-2-restrict-access-to-windows-admin-center) with local Administrators and the domain group Windows Admin Center administrators as Gateway administratory and the domain group Windows Admin Center users as Gateway users only
1. [Verify access by unauthorized user](#task-3-verify-access-by-unauthorized-user)

    > Can Pia access Windows Admin Center?

1. [Verify access by authorized user](#task-4-verify-access-by-authorized-user)

    > Can Ida access Widnows Admin Center?

    > Can Ida connect to VN1-SRV5 using Windows Admin Center?

1. [Apply role-based access control](#task-5-apply-role-based-access-control) to server VN1-SRV5 allowing members of the domain group IT to administer the server
1. [Verify role-based access control](#task-6-verify-role-based-access-control)

    > Can Ida connect to VN1-SRV5 using Windows Admin Center?

    > Can Ida stop and start services on VN1-SRV5 using Windows Admin Center?

    > Can Ida stop and start services on VN1-SRV5 using PowerShell?

### Task 1: Create groups in Active Directory

#### Active Directory Users and Computer

Perform this task on CL1.

1. From the desktop, open **Active Directory Users and Computers**.
1. In Active Directory Users and Computer, expand **ad.adatum.com**.
1. In the context-menu of **ad.adatum.com**, click **New**, **Organizational Unit**.
1. In New Object - Organizational Unit, in **Name**, enter **Entitling groups** and click **OK**.
1. In Active Directory Users and Computers, in the left pane, click **Entitling Groups**.
1. In the context-menu of Entitling Groups, click **New**, **Group**.
1. In New Object - Group, in **Group name**, type **Windows Admin Center users**. **Group scope** should be **Domain local** and **Group type** should be **Security**. Click **OK**.
1. Double-click the group **Windows Admin Center users**.
1. In Windows Admin Center users Properties, click the tab **Members**.
1. On the tab Members, click **Add...**.
1. In Select Groups, Contacts, Computers, Service Accounts, or Groups, in **Enter the object names to select**, type **IT** and click **OK**.
1. In Windows Admin Center users Properties, on the tab **Members**, click **OK**.
1. In the context-menu of Entitling Groups, click **New**, **Group**.
1. In New Object - Group, in **Group name**, type **Windows Admin Center administrators**. **Group scope** should be **Domain local** and **Group type** should be **Security**. Click **OK**.

#### Active Directory Administrative Center

Perform this task on CL1.

1. Open **Active Directory Administrative Center**.
1. In the context-menu of **ad (local)**, click **New**, **Organizational Unit**.
1. In Create Organizational Unit, in **Name**, type **Entitling groups** and click **OK**.
1. In Active Directory Administrative Center, double-click **Entitling groups**.
1. In the pane **Tasks**, click **New**, **Group**.
1. In Create Group, in **Group name**, type **Windows Admin Center users**.
1. Under **Group scope**, click **Domain local**.
1. On the left, click **Members**.
1. Under Members, click **Add...**.
1. In Select Groups, Contacts, Computers, Service Accounts, or Groups, in **Enter the object names to select**, type **IT** and click **OK**.
1. In Create Group: Windows Admin Center users, click **OK**.
1. In Active Directory Administrative Center, under Entitling Groups, in the pane **Tasks**, click **New**, **Group**.
1. In Create Group, in **Group name**, type **Windows Admin Center administrators**. Under **Group scope**, click **Domain local**. Click **OK**.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**.
1. Create the organizational unit **Entitling groups** at the domain level.

    ````powershell
    $aDorganizationalUnit = New-ADOrganizationalUnit `
        -Path 'DC=ad, DC=adatum, DC=com' `
        -Name 'Entitling groups' `
        -PassThru
    ````

1. In the new organizational unit, create the group **Windows Admin Center users** and add the group **IT** as member.

    ````powershell
    New-ADGroup `
        -Name 'Windows Admin Center users' `
        -Path $aDorganizationalUnit.DistinguishedName `
        -GroupScope DomainLocal `
        -PassThru | 
    Add-ADGroupMember -Members 'IT'
    ````

1. In the new organizational unit, create the group **Windows Admin Center administrators**.

    ````powershell
    New-ADGroup `
        -Name 'Windows Admin Center administrators' `
        -Path $aDorganizationalUnit.DistinguishedName `
        -GroupScope DomainLocal
    ````

### Task 2: Restrict access to Windows Admin Center

Perform this task on CL1.

1. Using Microsoft edge, navigate to <https://admincenter.ad.adatum.com>.
1. Click *Settings*.
1. In Settings, click **Access**.
1. Under Gateway Access, under **Allowed Groups**, click **Add**.
1. In the pane Add an allowed group, under **Name**, type **ad\Windows Admin Center users**. Under **Role**, ensure **Gateway users** is selected. Under **Type**, ensure **Gateway users security group** is selected. Click **Save**.

    Note: You can ignore the error message regarding the invalid group name format.

1. Under Gateway Access, under **Allowed Groups**, click **Add**.
1. In the pane Add an allowed group, under **Name**, type **ad\Windows Admin Center administrators**. Under **Role**, click **Gateway administrators**. Under **Type**, ensure **Gateway users security group** is selected. Click **Save**.
1. Under Gateway Access, under **Allowed Groups** click **BUILTIN\Users** and click **Delete**.
1. In the message box Delete, click **Yes**.

### Task 3: Verify access by unauthorized user

Perform this task on CL2.

1. Open **Microsoft Edge** and navigate to <https://admincenter>.

    > Pia cannot access Windows Admin Center anymore.

1. Sign out.

### Task 4: Verify access by authorized user

Perform this task on CL2.

1. Sign in as **ad\Ida**.
1. Open **Microsoft Edge** and navigate to <https://admincenter>.

    > Ida can access Windows Admin Center and sees all connections.

1. Click **vn1-srv5.ad.adatum.com**.

    > The pane Specify your credentials opens, because Ida does not have administrative permissions on this server.

### Task 5: Apply role-based access control

Perform this task on CL1.

1. Open **Microsoft Edge** and navigate to <https://admincenter>.
1. In Windows Admin Center, click **vn1-srv5.ad.adatum.com**.
1. Connected to vn1-srv5.ad.adatum.com, under **Tools**, click **Firewall**.
1. Under Firewall, click the tab **Incoming rules**.
1. On the tab Incoming rules, click **File and Printer Sharing (SMB-in)** and click **Enable**.
1. In the left pane, click **Settings**.
1. In Settings, click **Role-based Access control**.
1. Under Role-based access control, click **Apply**.
1. In message box Restart the WinRM service, click **Yes**.

    Wait a few minutes, refresh the page, until the status of **Role-based access control** changes to **Applied**. It can take up to 10 minutes until this happens.

1. Under **Tools**, click **Local users & groups**.
1. Under Local users and groups, click the tab **Groups**.
1. On the tab Groups, click **Windows Admin Center Administrators**.
1. In the bottom pane, Details - Windows Admin Center Administrators, click **Add user**.
1. In Add a user to the Windows Admin Center Administrators group, under **Username**, type **ad\IT** and click **Submit**.
1. In the left pane, click **Overview**.
1. Under Overview, click **Restart**.

### Task 6: Verify role-based access control

Perform this task on CL2. You should still be signed in with ad\Ida.

1. Open **Microsoft Edge** and navigate to <https://admincenter>.
1. Click **vn1-srv5.ad.adatum.com**.

    > Ida can connect to the server, because she is member of the Windows Admin Center administrators group on that server.

    Note: If a Specify your credentials pane appears at any time, enter the credentials of **ad\Ida**.

1. Under **Tools**, click **Services**.
1. Under Services, click **W32Time** and click **Stop**.

    > Ida can stop the service.

1. Click **Start**.
