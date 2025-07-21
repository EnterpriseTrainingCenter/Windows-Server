# Changing TCP/IP settings on Windows 11

## Desktop experience

1. Open **Settings**.
1. In Settings, in the left pane, click **Network & internet**.
1. In Network & internet, click the network connection type, e.g. **Ethernet**.
1. Expand the network connection to configure.

    * To change the IP address, mask or gateway:

        1. Beside **IP assignment**, click **Edit**.
        1. In Edit IP settings, at the top, either choose **Automatic (DHCP)** or **Manual**.
        1. If you chose manual, configure **IP address**, **Subnet mask** or **Subnet prefix length**, **Gateway**, **Preferred DNS**, and **DNS over HTTPS** for IPv4 and IPv6.
        1. Click **Save**.

    * To change the DNS settings:

        1. Beside **DNS server assignment**, click **Edit**.
        1. In Edit DNS settings, at the top, either choose **Automatic (DHCP)** or **Manual**.
        1. If you chose manual, configure **Preferred DNS**, **Alternate DNS**, and **DNS over HTTPS** for IPv4 and IPv6.
        1. Click **Save**.

## PowerShell

1. Open a terminal.
1. Set the DNS client server address.

    ````powershell

    $interfaceAlias = 'Ethernet' # Change this if required
    $serverAddresses = '' # Provide a comma separated list of DNS servers

    Set-DnsClientServerAddress `
        -InterfaceAlias $interfaceAlias -ServerAddresses $serverAddresses
    ````

## References

[Essential Network Settings and Tasks in Windows](https://support.microsoft.com/en-us/windows/essential-network-settings-and-tasks-in-windows-f21a9bbc-c582-55cd-35e0-73431160a1b9)

[Set-DnsClientServerAddress](https://learn.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress)
