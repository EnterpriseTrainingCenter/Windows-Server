# Changing TCP/IP settings on Windows Server

## Desktop experience

This can be performed locally only.

1. Open **Server Manager**.
1. In Server Manager, click **Local Server**.
1. Under Local Server, right to any network interface , click the IP address.
1. In Network Connections, in the context-menu of the network connection to configure, click **Properties**.
1. In Properties, click **Internet Protocol Version 4 (TCP/IPv4)** or **Internet Protocol Version 6 (TCP/IPv6)** and click **Properties**.
1. In Internet Protocol Version 4 (TCP/IPv4) Properties, either click

    * **Obtain the IP address automatically** or
    * **use the following IP address** and type **IP address** or **IPv6 address**, **Subnet mask** or **Subnet prefix length** and **Default gateway**.

1. Either click

    * **Obtain DNS server address automatically** or
    * **Use the following DNS server addresses** and provide the addresses for the **Prefered DNS server** and the **Alternate DNS server**.

1. Optional, to add additional IP addresses:
        1. Click **Advanced**.
        1. In Advanced TCP/IP Settings, on the tab IP settings, under IP addresses, click **Add...**
        1. In TCP/IP Address, type **IP address** or **IPv6 address** and **Subnet mask** or **Subnet prefix length** of the additional IP address and click **Add**.
        1. In **Advanced TCP/IP Settings**, click **OK**.

1. In **Internet Protocol Version 4 (TCP/IPv4) Properties** or **Internet Protocol Version 6 (TCP/IPv6) Properties**, click **OK**.
1. In **Properties**, click **OK**.

## SConfig

1. If not already running, run SConfig.

    ````shell
    SConfig
    ````

1. In sconfig, enter **8** for Network settings.
1. In Network settings, the number of the network adapter to configure.

    * To change the IP address, subnet mask, and default gateway:

        1. Enter **1** for Set network adapter address.
        1. Enter either **D** for DHCP or **S** for Static.
        1. For the static IP address, enter the IP address, subnet mask, and the default gateway.
        1. Press ENTER to continue.

    * To change the DNS server address:

        1. Enter **2** for Set DNS servers.
        1. Enter the new preferred DNS server and the alternate DNS server

## Windows Admin Center

1. Navigate to Windows Admin Center.
1. On the Windows Admin Center page, click the server to configure.
1. On the server page, under Tools, click **Networks**.
1. Under Networks, click the network adapter to configure and click **Settings**.
1. Click the tab IPv4 or IPv6, either select **Obtain an IP address automatically** or **Use the following IP address**.
1. If you chose Use the following IP address, type the **IP Address**, **Prefix Length** and **Default Gateway**.
1. Click either **Obtain DNS server address automatically** or **Use the following DNS server addresses**.
1. If you chose Use the following DNS server addresses, type the **Preferred DNS Server** and the **Alternate DNS Server**.
1. Click **Close**.

## PowerShell

1. In the context menu of **Start**, click **Terminal**.
1. Create a CIM session to the server.

    ````powershell
    $computerName = '' # Between the quotes, insert the server name
    $cimSession = New-CimSession -ComputerName $computerName
    ````

1. Find the network interface.

    ````powershell
    Get-NetIPConfiguration -CimSession $cimSession
    ````

1. Save the interface alias to a variable.

    ```powershell
    $interfaceAlias = '' # Between the quotes insert the interface alias
    ```

    * Add an IP address:

        ````powershell
        $iPAddress = '' # Between the quotes insert the IP address
        $prefixLength = 24 # Change this if required.
        New-NetIPAddress `
            -InterfaceAlias $interfaceAlias `
            -IPAddress $ipAddress `
            -PrefixLength $prefixLength `
            -CimSession $cimSession
        ````

    * Set the DNS server addresses.

        ````powershell
        $serverAddresses = '' # Insert an array of DNS servers here
        Set-DnsClientServerAddress `
            -InterfaceAlias $interfaceAlias `
            -ServerAddresses $serverAddresses `
            -CimSession $cimSession
        ````

    * Remove an IP address

        1. Remove any old CIM session.

            ````powershell
            Remove-CimSession $cimSession
            ````

        1. Remove any A records with the name of the old server from the DNS server.

            [Managing resource records](./Managing-resource-records.md)

        1. Clear the DNS client cache.

            [Managing the DNS client cache](./Managing-the-DNS-client-cache.md)

        1. Create a CIM session to the server.

            ````powershell
            $cimSession = New-CimSession -ComputerName $computerName
            ````

        1. Remove IP addresses:

            ````powershell
            $iPAddress = '' # The old IP address to remove
            Remove-NetIPAddress `
                -InterfaceAlias $interfaceAlias `
                -IPAddress $iPAddress `
                -CimSession $cimSession `
                -Confirm:$false
            ````

    * Remove a default gateway

        ```powershell
        $nextHop = '' # Provide the IP address of the old default gateway
        Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -NextHop $nextHop
        ```

1. Remove the CIM session.

    ````powershell
    Remove-CimSession $cimSession
    ````

## References

[How to change the IP address of a network adapter](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/change-ip-address-network-adapter)

[Configure a Server Core installation of Windows Server and Azure Local with the Server Configuration tool (SConfig)](https://learn.microsoft.com/en-us/windows-server/administration/server-core/server-core-sconfig)

[Get-NetIPConfiguration](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netipconfiguration)

[New-NetIPAddress](https://learn.microsoft.com/en-us/powershell/module/nettcpip/New-NetIPAddress)

[Set-DnsClientServerAddress](https://learn.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress)

[Remove-NetIPAddress](https://learn.microsoft.com/en-us/powershell/module/nettcpip/remove-netipaddress)

[Remove-NetRoute](https://learn.microsoft.com/en-us/powershell/module/nettcpip/remove-netroute)