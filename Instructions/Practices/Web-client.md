# Lab: Providing the Remote Desktop Web Client

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

You must have completed the lab [Configure external access to Remote Desktop Services](Configure-external-access-to-Remote-Desktop-Services.md).

## Introduction

To simplify connections to Remote Desktop Services from various operating systems, you want to provide the modern Web Client to your users.

## Exercises

1. [Set up the Remote Desktop Web Client](#exercise-1-set-up-the-remote-desktop-web-client)
2. [Validate the Remote Desktop Web Client](#exercise-2-validate-the-remote-desktop-web-client)

## Exercise 1: Set up the Remote Desktop Web Client

### Task 1: Copy the RD Connection Broker Publishing certificate to the RD Web servers

Perform these steps on CL1.

1. Open **Terminal**.
1. Get certificate information about the RD Connection Broker - Publishing certificate and save it in a variable.

    ````powershell
    $rDCertificate = Get-RDCertificate -Role RDPublishing -ConnectionBroker VN2-SRV1.ad.adatum.com
    ````

1. Create a remote PowerShell session to **VN2-SRV1**.

    ````powershell
    $pSSession = New-PSSession VN2-SRV2
    ````

1. Export the RD Connection Broker - Publishing certificate into a CER file on VN2-SRV1.

    ````powershell
    Invoke-Command -Session $pSSession {
        $cert = Get-ChildItem `
            -Path "Cert:\LocalMachine\My\$(($using:rdCertificate).Thumbprint)"
        New-Item -Path c:\Certs -ItemType Directory
        Export-Certificate `
            -Type CERT -FilePath c:\Certs\rdcb.cer -Cert $cert -Force
    }
    ````

1. Copy the certificate file to CL1.

    ````powershell
    Copy-Item `
        -FromSession $pSSession -Path c:\Certs\rdcb.cer -Destination c:\Certs
    ````

1. Remove the remote PowerShell session to VN2-SRV1.

    ````powershell
    Remove-PSSession $pSSession
    ````

1. Create a remote PowerShell session to **PM-SRV3** and **PM-SRV4**.

    ````powershell
    $pSSession = New-PSSession PM-SRV3, PM-SRV4
    ````

1. Create a directory **C:\Certs** in the remote PowerShell sessions.

    ````powershell
    Invoke-Command -Session $pSSession { 
        New-Item -Path C:\Certs -ItemType Directory
    }

1. Copy the certificate file to the remote PowerShell session.

    ````powershell
    $pSSession | ForEach-Object { 
        Copy-Item `
            -Path C:\certs\rdcb.cer -ToSession $PSItem -Destination C:\Certs
    }
    ````

1. Remove the remote PowerShell session.

    ````powershell
    Remove-PSSession $pSSession
    ````

### Task 2: Publish the Remote Desktop web client

Perform these steps on CL1.

1. Open **Terminal**.

1. Enter the remote PowerShell session to PM-SRV3.

    ````powershell
    Enter-PSSession PM-SRV3
    ````

1. Update the PowerShellGet module.

    ````powershell
    Install-Module -Name PowerShellGet -MinimumVersion 2.0.0 -Force
    ````

1. Unload the PowerShellGet module.

    ````powershell
    Remove-Module -Name PowerShellGet
    ````

1. Install the Remote Desktop web client management PowerShell module.

    ````powershell
    Install-Module -Name RDWebClientManagement -AcceptLicense -Force
    ````

1. Download the latest version of the Remote Desktop web client.

    ````powershell
    Install-RDWebClientPackage
    ````

1. Import the certificate from the connection broker.

    ````powershell
    Import-RDWebClientBrokerCert C:\Certs\rdcb.cer
    ````

1. Publish the Remote Desktop web client.

    ````powershell
    Publish-RDWebClientPackage -Type Production -Latest
    ````

1. Suppress telemetry.

    ````powershell
    Set-RDWebClientDeploymentSetting -Name SuppressTelemetry -Value $true
    ````

1. Exit the remote PowerShell session.

    ````powershell
    Exit-PSSession
    ````

If you have additonal RD Web Access servers in your deployment, e.g., **PM-SRV4**, repeat from step 2 replacing **PM-SRV3**.

## Exercise 2: Validate the Remote Desktop Web Client

[Connect using the Remote Desktop Web Client](#task-connect-using-the-remote-desktop-web-client)

### Task: Connect using the Remote Desktop Web Client

Perform these steps on CL1.

1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to <https://remote.adatum.com/RDWeb/webclient/>.
1. Sign in as **AD\Ada**.
1. Under Work Resources, click **Standard Desktop**.
1. In Access local resources, explore the settings and click **Allow**.
1. In the Remote Desktop Web Client navigation bar ([figure 1]), click the icon *Upload new file*.
1. In Open, from the local disk of CL1, select a file to upload, e.g., **c:\Certs.rdcb.cer**, and click **Open**.
1. In the remote connection, open **File Explorer**.
1. In File Explorer, expand **This PC**, **Remote Desktop Virtual Drive on RDWebClient** and click **Uploads**.

    You should see the file just uploaded.

1. Copy a file to the **Downloads** folder, e.g., **C:\Bootstrap\Bootstrap-*.txt**.
1. In the dialog Are you sure, you want to download 1 file(s)?, click **Confirm**.

    The file should be downloaded to the Downloads folder on CL1.

1. Explore the other icons in the connection bar.

[figure 1]: /images/Remote-Desktop-Web-Client-navigation-bar.png