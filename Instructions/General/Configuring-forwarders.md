# Configuring forwarders

## Desktop experience

1. Open **DNS**.
1. If necessary, connect to the DNS server.

    [Connecting the DNS console to server](./Connecting-the-DNS-console-to-a-server.md)

1. In **DNS Manager**, click the server name.
1. In the server node, double-click **Forwarders**.
1. In the server Properties, on tab Forwarders, click **Edit...**

    * To delete a forwarder, click the forwarder and click **Delete**
    * To add a forwarder, in  **\<Click here to add an IP Address or DNS Name\>**, enter the name or IP address of the forwarder.

1. Click **OK**.
1. In the server Properties, click **OK**.

## PowerShell

1. Open a terminal.
1. Configure the forwarders:

    ```powershell
    <#
        $computerName is the name of the DNS server
        $ipAddress is an array of IP addresses representing the forwarders
    #>
    $computerName = ''
    $iPAddress = '', ''

    Set-DnsServerForwarder -IPAddress $iPAddress  -ComputerName $computerName
    ```

## References

[Quickstart: Install and configure DNS server on Windows Server](https://learn.microsoft.com/en-us/windows-server/networking/dns/quickstart-install-configure-dns-server)