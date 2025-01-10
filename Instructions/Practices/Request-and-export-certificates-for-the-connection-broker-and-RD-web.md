# Practice: Request and export certificates for the connection broker and RD web

## Required VMs

* VN1-SRV1
* VN1-SRV2
* CL1

## Setup

You must have completed [Practice: Create an exportable web server certificate template](Create-an-exportable-web-server-certificate-template.md).

## Task

Request certificates using the template Web Server exportable with the following data and export them to PFX files.

| Subject name       | Subject alternative names |
|--------------------|---------------------------|
| rdcb.ad.adatum.com | rdcb.ad.adatum.com        |
|                    | VN2-SRV1.ad.adatum.com    |
|                    | VN2-SRV1                  |
| remote.adatum.com  | remote.adatum.com         |
|                    | PM-SRV3.ad.adatum.com     |
|                    | PM-SRV3                   |

For testing the initial deployment, we will use the computer names. The names rdcb.ad.adatum.com and remote.adatum.com will be used in the final deployment.

## Instructions

### Desktop Experience

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, run **gpupdate.exe**.
1. Run **certlm.msc**.
1. In certlm - [Certificates - Local Computer], expand **Personal** and click **Certificates**.
1. In the context-menu of Certificates, click **All Tasks**, **Request New Certificate...**.
1. In Certificate Enrollment, on page **Before You begin**, click **Next**.
1. On page **Select Certificate Enrollment Policy**, ensure **Active Directory Enrollment Policy** is selected and click **Next**.
1. On page **Request Certificates**, activate the checkbox **Web Server exportable** and click the link **More information is required to enroll for this certificate. Click here to configure settings.**.
1. In Certificate Properties, under **Subject name**, in the drop-down **Type**, click **Common name**.
1. Under **Subject name**, under **Value**, type **rdcb.ad.adatum.com** and click the top **Add >**.
1. Under **Alternative name**, in the drop-down **Type**, click **DNS**.
1. Under **Alternative name**, under **Value**, type **rdcb.ad.adatum.com** and click the bottom **Add >**.
1. Repeat the previous step for the values **VN2-SRV1.ad.adatum.com**, and **VN2-SRV1**.
1. Click **OK**.
1. On page **Request Certificates**, click **Enroll**.
1. On page **Certificate Installation Results**, click **Finish**.
1. In certlm - [Certificates - Local Computer], in the context-menu of **rdcb.ad.adatum.com**, click **All Tasks**, **Export...**.
1. In the Certificate Export Wizard, click **Next**.
1. On page Export Private Key, click **Yes, export the private key** and click **Next**.
1. On page Export file Format, click **Next**.
1. On page Security, click to active **Password**. Type a secure password and take a note.
1. On page File to Export, click **Browse...**.
1. In Save As, expand **This PC** and click **Local Disk (C:)**.
1. Click **New folder** and enter **Certs**.
1. Double-click **Certs** and beside **File name**, type **rdcb.pfx**
1. On page File to Export, click **Next**.
1. On page Completing the Certificate Export Wizard, click **Finish**.
1. In The export was successful, click **OK**.
1. In certlm - [Certificates - Local Computer], in the context-menu of **rdcb.ad.adatum.com**, **Delete**.
1. In the Certificate dialog, click **Yes**.
1. In certlm - [Certificates - Local Computer], in the context-menu of Certificates, click **All Tasks**, **Request New Certificate...**.
1. In Certificate Enrollment, on page **Before You begin**, click **Next**.
1. On page **Select Certificate Enrollment Policy**, ensure **Active Directory Enrollment Policy** is selected and click **Next**.
1. On page **Request Certificates**, activate the checkbox **Web Server exportable** and click the link **More information is required to enroll for this certificate. Click here to configure settings.**.
1. In Certificate Properties, under **Subject name**, in the drop-down **Type**, click **Common name**.
1. Under **Subject name**, under **Value**, type **remote.adatum.com** and click the top **Add >**.
1. Under **Alternative name**, in the drop-down **Type**, click **DNS**.
1. Under **Alternative name**, under **Value**, type **remote.adatum.com** and click the bottom **Add >**.
1. Repeat the previous step for the values **PM-SRV3.ad.adatum.com**, and **PM-SRV3**.
1. Click **OK**.
1. On page **Request Certificates**, click **Enroll**.
1. On page **Certificate Installation Results**, click **Finish**.
1. In certlm - [Certificates - Local Computer], in the context-menu of **remote.adatum.com**, click **All Tasks**, **Export...**.
1. In the Certificate Export Wizard, click **Next**.
1. On page Export Private Key, click **Yes, export the private key** and click **Next**.
1. On page Export file Format, click **Next**.
1. On page Security, click to active **Password**. Type a secure password and take a note.
1. On page File to Export, click **Browse...**.
1. In Save As, expand **This PC** and click **Local Disk (C:)**.
1. Click **New folder** and enter **Certs**.
1. Double-click **Certs** and beside **File name**, type **rdweb.pfx**
1. On page File to Export, click **Next**.
1. On page Completing the Certificate Export Wizard, click **Finish**.
1. In The export was successful, click **OK**.
1. In certlm - [Certificates - Local Computer], in the context-menu of **remote.adatum.com**, **Delete**.
1. In the Certificate dialog, click **Yes**.

#### PowerShell

Perform this task on VN2-SRV2.

1. Run **Windows PowerShell** as Administrator.
1. Update the group policies.

    ````powershell
    gpupdate.exe
    ````

1. Request a certificate for **rdcb.ad.adatum.com**.

    ````powershell
    $dnsName = @(
        'rdcb.ad.adatum.com'
        'VN2-SRV1.ad.adatum.com'
        'VN2-SRV1'
    )
    $enrollmentResult = Get-Certificate `
            -Template WebServerexportable `
            -SubjectName "cn=$($dnsName[0])" `
            -DnsName $dnsName `
            -CertStoreLocation 'Cert:\LocalMachine\My'
    ````

1. Create a password for the PFX file.

    ````powershell
    $password = Read-Host -AsSecureString -Prompt 'Enter the password for the PFX file'
    ````

1. At the prompt Enter the password for the PFX file, enter a secure password and take a note.

1. Export the certificate.

    ````powershell
    New-Item -Path c:\Certs -ItemType Directory
    Export-PfxCertificate `
        -Cert $enrollmentResult.Certificate `
        -Password $password `
        -FilePath c:\certs\rdcb.pfx
    ````

1. Delete the certificate from the local store.

    ````powershell
    Get-ChildItem Cert:\LocalMachine\My\ |
    Where-Object {
        $PSItem.Thumbprint -eq $enrollmentResult.Certificate.Thumbprint
    } |
    Remove-Item
    ````

1. Request a certificate for **remote.adatum.com**.

    ````powershell
    $dnsName = @(
        'remote.adatum.com'
        'PM-SRV3.ad.adatum.com'
        'PM-SRV3'
    )
    $enrollmentResult = Get-Certificate `
            -Template WebServerexportable `
            -SubjectName "cn=$($dnsName[0])" `
            -DnsName $dnsName `
            -CertStoreLocation 'Cert:\LocalMachine\My'
    ````

1. Export the certificate.

    ````powershell
    New-Item -Path c:\Certs -ItemType Directory
    Export-PfxCertificate `
        -Cert $enrollmentResult.Certificate `
        -Password $password `
        -FilePath c:\certs\rdweb.pfx
    ````

    *Note:* This PFX file will have the same password as the previous one.

1. Delete the certificate from the local store.

    ````powershell
    Get-ChildItem Cert:\LocalMachine\My\ |
    Where-Object {
        $PSItem.Thumbprint -eq $enrollmentResult.Certificate.Thumbprint
    } |
    Remove-Item
    ````
