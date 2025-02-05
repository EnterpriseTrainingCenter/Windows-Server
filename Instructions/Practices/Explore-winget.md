# Practice: Explore Winget

## Required VMs

* VN1-SRV1
* VN1-SRV9

## Task

You want to develop a server application on VN1-SRV9. For this purpose, install the store version of PowerShell, the latest version of Git and version 1.96.3 of Microsoft Visual Studio Code on the server. Verify the install, by listing all installed packages. Export all installed packages to a JSON file for later use on another computer.

Later, you decide to update Visual Studio Code to the latest version. Moreover, you want to update all other packages on the server.

Finally, you want to inspect the log files of winget.

## Instructions

Perform these steps on VN1-SRV9.

1. Sign in as **.\Administrator**.
1. Run **Terminal** as Administrator.
1. Update the sources for winget and list 

    ````powershell
    winget source update
    ````

1. List the package sources of winget.

    ````powershell
    winget source list
    ````

1. Find the package for PowerShell.

    ````powershell
    winget search --name 'powershell' --accept-source-agreements
    ````

1. Copy the **Id** of **PowerShell** with the **msstore** as **Source** to the clipboard.
1. Install PowerShell from the msstore source.

    ````powershell
    winget install --id 9MZ1SNWT0N5D --accept-source-agreements --accept-package-agreements
    ````

    *Important*: The parameter for --id should be the the ID you copied in the previous step.

    > The version from the store will be updated automatically in the future.

1. Find the package for Git.

    ````powershell
    winget search --name 'Git' --exact --accept-source-agreements
    ````

    *Important:* When using the --exact parameter, the name is case-sensitive.

1. Get information about the Git package.

    ````powershell
    winget show --id Git.Git
    ````

1. Install Git from the winget source.

    ````powershell
    winget install --id Git.Git --accept-source-agreements --accept-package-agreements
    ````

1. Find the package for Visual Studio Code.

    ````powershell
    winget search --name 'Visual Studio Code' --accept-source-agreements
    ````

1. List available versions of Visual Studio Code.

    ````powershell
    winget show --id Microsoft.VisualStudioCode --versions
    ````

1. Install version 1.96.3 of Visual Studio Code from the winget source.

    ````powershell
    winget install --id Microsoft.VisualStudioCode --version 1.96.3 --accept-source-agreements --accept-package-agreements
    ````

1. List all installed packages.

    ````powershell
    winget list
    ````

1. Export the list of packages to a JSON file.

    ````powershell
    winget export c:\packages.json
    ````

    You might inspect the exported file. You could install all the packages on another computer by running ````winget import packages.json --accept-package-agreements --accept-source-agreements````.

1. List packages with available updates.

    ````powershell
    winget upgrade
    ````

    > Among others, Microsoft Visual Studio Code (User) should be listed, because we did not install the latest version.

1. Update Visual Studio Code.

    ````powershell
    winget upgrade --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements
    ````

1. Update all packages.

    ````powershell
    winget upgrade --all --accept-source-agreements --accept-package-agreements
    ````

1. View the location of log files.

    ````powershell
    winget --info
    ````

    To view the full path, you might have to extend the width of the Terminal window.

1. Open **File Explorer** and navigate to the path of the log files.
1. Open one of the log files in **Visual Studo Code** and inspect it.

If time allows, restart **Terminal** and verify, that **PowerShell** as well as **Git Bash** are available as command line interpreters.
