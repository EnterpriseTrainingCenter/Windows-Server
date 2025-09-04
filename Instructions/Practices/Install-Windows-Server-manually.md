# Practice: Install Windows Server manually

## Task

Run ````C:\LabResources\New-VM.ps1 -Name VN1-SRV21```` to create a new VM and install Windows Server Datacenter Edition on it.

## Instructions

Perform these steps on the host.

1. Run **Windows PowerShell** as Administrator.
1. In Windows PowerShell, execute

    ````powershell
    C:\LabResources\New-VM.ps1 -Name VN1-SRV21
    ````

1. Open **Hyper-V-Manager**
1. In Hyper-V Manager, double-click **WIN-VN1-SRV21** to open the console.
1. In WIN-VN1-SRV21 on ... - Virtual Machine Connection, in the menu, click **Media**, **DVD Drive**, **Insert Disk...**
1. In Open, open **C:\\Labs\\ISOs\\2025_x64_EN_Eval.iso**.
1. In **WIN-VN1-SRV21 on ... - Virtual Machine Connection**, click **Start**.
1. On the message Press any key to boot from CD or DVD, press any key within a few seconds. If fail to do so, and the VM tries to start PXE over IPv4, on the menu, click **Action**, **Reset...**.
1. In Windows Server Setup, on page Select language settings, configure **Time and currency format**  as you wish and click **Next**.
1. On page Select keyboard settings, configure the **Keyboard or input method** as you wich and click **Next**.
1. On page Select setup option, ensure **Install Windows Server** is selected, click **I agree everything will be deleted including files, apps, and settings** and click **Next**.
1. On page Select image, click **Windows Server 2025 Datacenter Evaluation** and click **Next**.
1. On page Applicable notices and license terms, click **Accept**.
1. On page Select location to install Windows Server, explore the options and click **Next**.
1. On page Ready to install, click **Install**.

Do not wait for the installation to finish.
