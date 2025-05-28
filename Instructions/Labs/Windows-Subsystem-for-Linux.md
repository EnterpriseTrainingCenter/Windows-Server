# Lab: Windows Subsystem for Linux

## Required VMs

* A domain controller (VN1-SRV5 or VN1-SRV1)
* VN1-SRV9

## Introduction

Your developers maintain a server application that consists of components running under Windows and Linux. For easier development, you want to provide them with a machine that can run all components on a single system. Therefore, you want to evaluate Windows Subsystem for Linux.

First, you will install WSL with a distribution. Then, you want to find out how networking works and how to access files in the Linux distribution from Windows.

At the end of your evaluation, you want to uninstall the Linux distribution and WSL.

## Exercises

1. [Install Windows Subsystem for Linux](#exercise-1-install-windows-subsystem-for-linux)
1. [Work with Windows Subsystem for Linux](#exercise-2-work-with-windows-subsystem-for-linux)
1. [Uninstall Windows Subsystem for Linux](#exercise-3-uninstall-windows-subsystem-for-linux)

## Exercise 1: Install Windows Subsystem for Linux

1. [Configure nested virtualization](#task-1-configure-nested-virtualization) for VN1-SRV9
1. [Install Windows Subsystem for Linux](#task-2-install-windows-subsystem-for-linux) without a distribution
1. [Install and configure a distribution](#task-3-install-and-configure-a-distribution)

### Task 1: Configure nested virtualization

Perform this task on the host.

1. Open **Windows PowerShell (Admin)**.
1. In Windows PowerShell (Admin), for **WIN-VN1-SRV9**, shut down the virtual machine, expose the virtualization extensions to the virtual machine, enable MAC address spoofing, disable dynamic memory and set the startup memory to **3 GB**, and start the virtual machine again.

    ````powershell
    $vMName = 'WIN-VN1-SRV9'
    Stop-VM -VMName $vMName
    Set-VMProcessor -VMName $vMName -ExposeVirtualizationExtensions $true
    
    Get-VMNetworkAdapter -VMName $vMName |
    Set-VMNetworkAdapter -MacAddressSpoofing On

    Set-VM -VMName $vMName -StaticMemory -MemoryStartupBytes 3GB
    Start-VM -VMName $vMName
    ````

### Task 2: Install Windows Subsystem for Linux

Perform this task on VN1-SRV9.

1. Sign in as **ad\Administrator**.
1. Open **Terminal**.
1. Install Windows Subsystem for Linux without a distribution.

    ````powershell
    wsl --install --no-distribution
    ````

1. Restart the computer.

    ````powershell
    Restart-Computer
    ````

### Task 3: Install and configure a distribution

Perform this task on VN1-SRV9.

1. Sign in as **ad\Administrator**.
1. Open **Terminal**.
1. List the available distributions.

    ````powershell
    wsl --list --online
    ````

1. Install the latest version of Ubuntu. If you are more familiar with another distribution, feel free to install your favorite distribution.

    ````powershell
    wsl --install --distribution Ubuntu
    ````

    Wait for the download and installation to complete. This will take a few minutes.

1. List installed Linux distributions.

    ````powershell
    wsl --list --verbose
    ````

1. Launch Ubuntu.

    ````powershell
    wsl --distribution Ubuntu
    ````

1. At the prompt Create a default Unix user account, type a name for your account, e.g. your first name, and take a note.
1. At the prompts New password and Retype new password, type a secure password and take a note.

If time allows, you can install additional distributions. This will take less time than the first one.

1. Log out of Linux.

    ````bash
    logout
    ````

1. Close **Terminal**.

## Exercise 2: Work with Windows Subsystem for Linux

1. [Find out the IP addresses](#task-1-find-out-the-ip-addresses) of the Linux distribution from Windows and of the Windows Host from Linux
1. [Access files in Linux](#task-2-access-files-in-linux) home directory from Windows
1. [Update the Linux distribution](#task-3-update-the-linux-distribution)
1. [Install a graphical Linux application](#task-4-install-a-graphical-linux-application), e.g. quadrapassel
1. [Shutdown the Linux distribution](#task-5-shut-down-the-linux-distribution)

### Task 1: Find out the IP addresses

Perform this task on VN1-SRV9.

1. Open **Terminal**.
1. In Terminal, run the command ````hostname -I```in the Linux distribution.

    ````powershell
    wsl --distribution Ubuntu hostname -I
    ````

    The displayed IP address is the IP address of the Linux distribution.

1. In Terminal, click the down chevron and click **Ubuntu**.
1. On the tab Ubuntu, find out the IP address of the Windows host.

    ````bash
    ip route show | grep -i default | awk '{ print $3}'
    ````

    The displayed IP address is the IP address of the Windows host.

### Task 2: Access files in Linux

Perform this task on VN1-SRV9.

1. Open **Terminal**.
1. In Terminal, click the down chevron and click **Ubuntu**.
1. In Ubuntu, change to the home directory.

    ````bash
    cd ~
    ````

1. Create a file in your home directory

    ````bash
    touch testfile.txt
    ````

1. Open **File Explorer**.
1. In File Explorer, expand **Linux**, **Ubuntu**, **home** and click the directory of your user.
1. In the context-menu of **testfile.txt**, click **Edit**.
1. In Notepad, type some text and, on the menu, click **File**, **Save**.
1. Close **Notepad**.
1. In **Terminal**, on the tab Ubuntu, display the content of **testfile.txt**.

    ````bash
    cat testfile.txt
    ````

### Task 3: Update the Linux distribution

Perform this task on VN1-SRV9.

1. Open **Terminal**.
1. In Terminal, click the down chevron and click **Ubuntu**.
1. In Ubuntu, fetch the latest package information from the repositories.

    ````bash
    sudo apt-get update
    ````

1. At the prompt \[sudo\] password, enter your password for the Linux distribution.
1. Upgrade all packages.

    ````bash
    sudo apt-get upgrade
    ````

1. Confirm any prompts.

This may take a few minutes.

### Task 4: Install a graphical Linux application

Perform this task on VN1-SRV9.

1. Open **Terminal**.
1. In Terminal, click the down chevron and click **Ubuntu**.
1. Install quadrapassel, which is a clone of the Tetris game.

    ````bash
    sudo apt-get install quadrapassel
    ````

1. If a prompt \[sudo\] password appears, enter your password for the Linux distribution.
1. At the prompt Do you want to continue?, enter **y**.
1. In the Windows start menu, find the app **Quadrapassel (Ubuntu)**, open it and have some fun!

### Task 5: Shut down the Linux distribution

Perform this task on VN1-SRV9.

1. Open **Terminal**.
1. List running distributions.

    ````powershell
    wsl --list --running
    ````

1. If at least one distribution was listed in the previous step, shut it down.

    ````powershell
    wsl --shutdown
    ````

1. Verify that the distribution was shut down.

    ````powershell
    wsl --list --running
    ````

    There are not running distributions.

## Exercise 3: Uninstall Windows Subsystem for Linux

1. [Uninstall a distribution](#task-1-uninstall-a-distribution)
1. [Uninstall WSL](#task-2-uninstall-wsl)

### Task 1: Uninstall a distribution

Perform this task on VN1-SRV9.

1. Open **Terminal**.
1. In Terminal list the installed distributions.

    ````powershell
    wsl --list
    ````

1. Uninstall the Linux distribution

    ````powershell
    wsl --unregister Ubuntu
    ````

1. In Terminal list the installed distributions again.

    ````powershell
    wsl --list
    ````

    The distribution you uninstalled should not be listed anymore.

### Task 2: Uninstall WSL

Perform this task on VN1-SRV9.

1. Open **Terminal**.
1. Uninstall wsl.

    ````powershell
    wsl --uninstall
    ````
