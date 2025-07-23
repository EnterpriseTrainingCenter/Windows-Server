# Managing resource records

## Desktop experience

1. Open **DNS**.
1. If necessary, connect to the DNS server.

    [Connecting the DNS console to a server](./Connecting-the-DNS-console-to-a-server.md)

1. Expand the server node, **Forward Lookup Zones** and click the zone to manage.

    * To update a resource record:

        1. Double-click the record.
        1. Update the record as required and click **OK**.

    * To remove a resource records:

        1. In the context menu of the resource record click **Delete**.
        1. In the dialog Do you want to delete the record ... from the server, click **Yes**.

## Windows Admin Center

1. Navigate to Windows Admin Center.
1. If necessary, install the extension **DNS**.

    [Installing extensions in Windows Admin Center](./Installing-extensions-in-Windows-Admin-Center.md)

1. If necessary, add the DNS server to Windows Admin Center.

    [Adding servers to Windows Admin Center](./Adding-servers-to-Windows-Admin-Center.md)

1. In Windows Admin Center, click the server acting as DNS server.
1. In the server page, unter Tools, click **DNS**. If you do not see DNS there, go to step 2.
1. If you see a message The DNS PowerShell tools (RSAT) are not installed, click **Install**.

    Wait for the installation to complete. The page will automatically reload.

1. In DNS, click the zone to manage.

    * Update a resource record:

        1. In the Records pane, click the resource record to update.
        1. Click **Edit**.
        1. Update the record as required and click **Save**.

    * To delete a resource record:

        1. In the Records pane, click the resource record to delete.
        1. Click **Delete**.
        1. In the dialog Delete DNS record, click **Yes**.

## PowerShell

1. Open a terminal.
1. Configure the parameters:

    ```powershell
    <#
        $computerName is the name of the DNS server
        $zoneName is the name of the zone to manage
    #>
    $computerName = ''
    $zoneName = ''
    ```

    * List all resource records in a zone:

        ```powershell
        Get-DnsServerResourceRecord `
            -ZoneName $zoneName `
            -ComputerName $computerName
        ```

    * Update a resource record

        ```powershell
        $rRType = '' # The resource record type, e.g. 'A'
        $name = '' # The resource record name

        $oldDnsServerResourceRecord = Get-DnsServerResourceRecord `
            -ZoneName $zoneName `
            -RRType $rRType `
            -Name $name `
            -ComputerName $computerName

        $newDnsServerResourceRecord = `
            [ciminstance]::new($oldDnsServerResourceRecord)
        ```

        * Update the IPv4 address of a Host (A) record

            ```powershell
            $ipV4Address = '' # The new IP address for the record
            $newDnsServerResourceRecord.RecordData.IPv4Address = $iPv4Address
            Set-DnsServerResourceRecord `
                -ZoneName $zoneName `
                -OldInputObject $oldDnsServerResourceRecord `
                -NewInputObject $newDnsServerResourceRecord `
                -ComputerName $computerName
            ```

    * Delete a resource record:

        ```powershell
        $rRType = '' # The resource record type, e.g. 'A'
        $name = '' # The resource record name
        $recordData = $null # Optional: The record data, e.g. the IP address

        Remove-DnsServerResourceRecord `
            -ZoneName $zoneName `
            -RRType $rRType `
            -Name $name `
            -ComputerName $computerName
        ```

## References

[Manage resource records](https://learn.microsoft.com/en-us/windows-server/networking/dns/manage-resource-records)