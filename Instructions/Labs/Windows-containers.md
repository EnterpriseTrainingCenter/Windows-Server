# Windows containers

## Required VMs

* VN1-SRV1
* VN1-SRV4
* VN2-SRV2
* CL1

## Setup

On **CL1**, sign in as **ad\Administrator**.

## Introduction

## Exercises

1. [Run the first container](#exercise-1-run-the-first-container)
1. [Containerize a sample app](#exercise-2-containerize-a-sample-app)

## Exercise 1: Run the first container

1. [Configure nested virtualization](#task-1-configure-nested-virtualization) for the VM WIN-VN2-SRV2
1. [Download and install Docker CE](#task-2-download-and-install-docker-ce) on VN2-SRV2
1. [Pull the Nano server base image](#task-3-pull-the-nano-server-base-image)
1. [Run the Nano server image in a container](#task-4-run-the-nano-server-image-in-a-container) with the user ContainerAdministrator and create a simple text file in it
1. [Create a new container image](#task-5-create-a-new-container-image) from the container you created with the name helloworld and run a new container from the image, emitting the content of the text file you created

### Task 1: Configure nested virtualization

Perform this task on the host.

1. Open **Windows PowerShell (Admin)**.
1. In Windows PowerShell (Admin), for **WIN-VN2-SRV2**, shut down the virtual machine, expose the virtualtion extensions to the virtual machine, enable MAC address spoofing, disable dynamic memory and set the startup memory to **4 GB**, and start the virtual machine again.

    ````powershell
    $vMName = 'WIN-VN2-SRV2'
    Stop-VM -VMName $vMName
    Set-VMProcessor -VMName $vMName -ExposeVirtualizationExtensions $true
    Get-VMNetworkAdapter -VMName $vMName |
    Set-VMNetworkAdapter -MacAddressSpoofing On
    Set-VM -VMName $vMName -StaticMemory -MemoryStartupBytes 4GB
    Start-VM -VMName $vMName
    ````

### Task 2: Download and install Docker CE

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, connect a remote PowerShell session to VN2-SRV2.

    ````powershell
    Enter-PSSession VN2-SRV2
    `````

1. On VN2-SRV2, download and install Docker CE from Github.

    ````powershell
    Set-Location ~\Downloads
    Invoke-WebRequest `
        -Uri 'https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1' `
        -OutFile install-docker-ce.ps1 `
        -UseBasicParsing
    .\install-docker-ce.ps1
    ````

    Wait for the instalation to finish. This will take less than a minute.

1. Exit the remote PowerShell session.

    ````powershell
    Exit-PSSession
    ````

1. Restart VN2-SRV2.

    ````powershell
    Restart-Computer -ComputerName VN2-SRV2 -Protocol WSMan
    ````

### Task 3: Pull the Nano server base image

Perform this task on VN2-SRV2.

1. Sign in as **ad\Administrator**.

    The PowerShell script should start automatically. After a few seconds, the script should complete.

1. Open **Terminal**.
1. In Terminal, download and install the base image for Nano server.

    ````powershell
    docker pull mcr.microsoft.com/windows/nanoserver:ltsc2022
    ````

1. Query your local docker image repository.

    ````powershell
    docker images
    `````

    You should see the image of microsoft/nanoserver.

### Task 4: Run the Nano server image in a container

Perform this task on VN2-SRV2.

1. Sign in as **ad\Administrator**.
1. Open **Terminal**.
1. In Terminal, start a container with an interactive session from the nanoserver image.

    ````powershell
    docker run --interactive --tty --user ContainerAdministrator mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd.exe
    ````

    This command starts a new container using the Nano server image. The -i or --interactive option tells Docker to keep STDIN open even if not attached. The -t or --tty option tells Docker to allocate a pseudo-TTY. Within the container, cmd.exe is executed.

    Now, your are in a cmd.exe session within the container.

1. In the container, create a simple text file **Hello.txt** in **C:\\Users\\ContainerUser** and exit from the container.

    ````shell
    cd Users\ContainerUser
    echo "Hello World!" > Hello.txt
    exit
    `````

### Task 5: Create a new container image

Perform this task on VN2-SRV2.

1. Open **Terminal**.
1. In Terminal, get the container ID for the container you just existed.

    ````powershell
    docker ps --all
    ````

    Take a note of the CONTAINER ID of your container.

1. Create a new **heloworld** image that includes the changes in the first container you ran. Replace the first parameter with the container ID noted in the previous step.

    ````powershell
    docker commit bb91a76b8023 helloworld
    ````

1. List the image in your local repository.

    ````powershell
    docker images
    ````

    You should see the helloworld image in addition to the Nano server image.

1. Run the new container, type the content of **C:\\Users\\ContainerUser\\Hello.txt** and remove the container.

    ````powershell
    docker run --rm helloworld cmd.exe /s /c type C:\Users\ContrainerUser\Hello.txt
    ````

    You should see the content of Hello.txt.

## Exercise 2: Containerize a sample app

1. [Install Git](#task-1-install-git) on VN2-SRV2
1. [Install Visual Studio Code](#task-2-install-visual-studio-code) on VN2-SRV2
1. [Clone the app repository](#task-3-clone-the-app-repository) <https://github.com/MicrosoftDocs/Virtualization-Documentation.git>
1. [Build and run the app](#task-4-build-and-run-the-app): To build the app, you must change the base image for the build environment to mcr.microsoft.com/dotnet/sdk:6.0.406-nanoserver-ltsc2022. Run the container in Hyper-V isolation mode and map port 80 of the container to port 5000 on the host.

### Task 1: Install Git

Perform this task on VN2-SRV2.

1. Run **Terminal**.
1. In Terminal, install **Git** using winget.

    ````powershell
    winget install Git.Git --accept-source-agreements
    ````

    Wait for the installation to complete. This takes a minute or two.

### Task 2: Install Visual Studio Code

Perform this task on VN2-SRV2.

1. Open **Terminal**.
1. In Terminal, install **Visual Studio Code** using winget.

    ````powershell
    winget install Microsoft.VisualStudioCode --accept-source-agreements
    ````

    Wait for the installation to complete. This takes a minute or two.

1. Open **Visual Studio Code**.
1. In Visual Studio Code, close the tab **Walkthrough: Setup VS Code**.
1. On the left-hand side click the icon *Extensions*.
1. In EXTENSIONS, in **Search Extensions in Marketplace**, type **Docker** and click Docker.

    Make sure, the extension looks similar to [figure 1].

1. In the extension screen of Docker, click **Install**.

### Task 3: Clone the app repository

Perform this task on VN2-SRV2.

1. Open **Visual Studio Code**.
1. In Visual Studio Code, on the menu, click **View**, **Command Palette...** or press CTRL + SHIFT + P.
1. In the command palette, search for and click **Git: Clone**.
1. In Provide repository URL or pick a repository source, enter **https://github.com/MicrosoftDocs/Virtualization-Documentation.git**.
1. In Choose a folder to clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git into, navigate to **C:\\LabResources** and click **Select as Repository Destination**.

    Wait for the cloning to finish. This takes a few seconds.

1. In Would you like to open the cloned repository, click **Open**.
1. In Do you trust the authors of the files in the folder, click **Yes, I trust the authors**

### Task 4: Build and run the app

Peform this task on VN2-SRV2.

1. Open **Visual Studio Code**.
1. In Visual Studio Code, if the repository **VIRTUALIZATION-DOCUMENTATION** is not open, on the menu, click **File**, **Open Folder...**

    In Open Folder, navigate to **C:\\LabResources\Virtualization-Documentation** and click **Select Folder**.

1. In Explorer view, click **windows-container-samples**, **asp-net-getting-started** and **dockerfile**.
1. Change the first line to base the container on the following image.

    ````text
    FROM mcr.microsoft.com/dotnet/sdk:6.0.406-nanoserver-ltsc2022 AS build-env
    ````

    Take a look at the file content. You can find a line-by-line explanation under <https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/building-sample-app#write-the-dockerfile>

1. On the menu, clic **View**, **Terminal**.
1. In the TERMINAL pane, navigate to the directory, where the dockerfile resides.

    ````powershell
    Set-Location .\windows-container-samples\asp-net-getting-started\
    `````

1. Build the container from the dockerfile.

    ````powershell
    docker build -t my-asp-app .
    ````

    Wait for the build to complete. This takes a minute or two.

1. Run the container detached in hyper-v isolation mode, map port **5000** on the host to port **80** in the container and give the container the convenient name **myapp**.

    ````powershell
    docker run -d -p 5000:80 --isolaton hyperv --name myapp my-asp-app
    ````

1. Open **Microsoft Edge**.
1. In Microsoft Edge, navigate to <http://localhost:5000>.

    You should see a sample web site.

[figure 1]: /images/Docker-VSCode-extension.png