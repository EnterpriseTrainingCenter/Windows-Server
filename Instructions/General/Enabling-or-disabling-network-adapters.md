# Enabling or disabling network adapters

## Desktop experience

1. Open **Settings**.
1. In Settings, click **Network & internet**.
1. In Network & Internet, click **Advanced network settings**.
1. In Advanced network settings, under **Network adapters**, beside the network adapter to configure, click either **Disable** or **Enable**.

## PowerShell

1. In the context menu of **Start**, click **Terminal**.
1. Create a CIM session to the server.

    ````powershell
    $computerName = '' # Between the quotes, insert the server name
    $cimSession = New-CimSession -ComputerName $computerName
    ````

    * Disable a network adapter

        ````powershell
        $name = '' # Between the quotes, insert the network adapter name/alias
        Disable-NetAdapter -Name $name -CimSession $cimSession
        ````

    * Enable a network adapter

        ````powershell
        $name = '' # Between the quotes, insert the network adapter name/alias
        Enable-NetAdapter -Name $name -CimSession $cimSession
        ````

1. Remove CIM session.

````powershell
Remove-CimSession $cimSession
````
