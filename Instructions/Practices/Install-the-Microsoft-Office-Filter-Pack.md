# Practice: Install the Microsoft Office Filter Pack

## Required VMs

* VN1-SRV1
* VN1-SRV10
* CL1

## Task

Download and install the Microsoft Office 2010 Filter Packs on VN1-SRV10.

## Instructions

Perform these steps on CL1.

1. Logon as **ad\Administrator**.
1. Using **Microsoft Edge**, navigate to <https://www.microsoft.com/en-US/download/details.aspx?id=17062>
1. On the page Download Microsoft Office 2010 Filter Packs, click **Download**.
1. Activate the checkbox **FilterPack64bit.exe** and click **Next**.
1. Copy the file **FilterPack64bit.exe** to **\\\\VN1-SRV10\\IT**.
1. Open **Terminal**.
1. Install the **Microsoft Office Filter Pack** on **VN1-SRV10**.

    ````powershell
    Invoke-Command -ComputerName VN1-SRV10 -ScriptBlock {
        Unblock-File -Path D:\Shares\IT\FilterPack64bit.exe 
        Start-Process `
            -FilePath D:\Shares\IT\FilterPack64bit.exe `
            -ArgumentList '/extract:c:\FilterPack', '/quiet' `
            -Wait
        Start-Process `
            -FilePath msiexec.exe `
            -ArgumentList '/i C:\filterpack\FilterPack.msi', '/q' `
            -Wait
    }
    ````

    The installation should complete in a few seconds. If it does not complete, perform the following troubleshooting steps:

    1. On VN1-SRV10, sign in as **Administrator**.
    1. Open **Terminal**.
    1. In Terminal, extract the Microsoft Office Filter Pack.

        ````shell
        D:\Shares\IT\FilterPack64bit.exe /extract:c:\FilterPack /quiet
        `````

    1. Install the Microsoft Office Filter Pack.

        ````shell
        msiexec.exe /i C:\FilterPack\FilterPack.msi /qb
        ````
