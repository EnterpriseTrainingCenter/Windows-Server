# Configuring the network profile type

## Desktop experience

1. Open **Settings**.
1. In Settings, click **Network & Internet**.
1. In Network & Internet, click **Ethernet**.
1. For the desired network connection, select either **Public network (recommended)** or **Private network**.

## PowerShell

1. In the context menu of **Start**, click **Terminal**.
1. Create a CIM session to the server.

    ````powershell
    $computerName = '' # Between the quotes, insert the server name
    $cimSession = New-CimSession -ComputerName $computerName
    ````

1. Set the network connection profile.

    ````powershell
    $interfaceAlias = '' # Insert the name of the network interface
    $networkCategory = 'Private' # Replace with Public, if required

    Set-NetConnectionProfile `
        -InterfaceAlias $interfaceAlias -NetworkCategory $networkCategory
    ````

1. Remove CIM session.

````powershell
Remove-CimSession $cimSession
````

## References

[Essential Network Settings and Tasks in Windows](https://support.microsoft.com/en-us/windows/essential-network-settings-and-tasks-in-windows-f21a9bbc-c582-55cd-35e0-73431160a1b9)

[Set-NetConnectionProfile](https://learn.microsoft.com/en-us/powershell/module/netconnection/set-netconnectionprofile?view=windowsserver2025-ps)