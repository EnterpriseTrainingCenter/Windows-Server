# Adding servers to Windows Admin Center

1. Navigate to **Windows Admin Center**.
1. On the page Windows Admin Center, click the button **+ Add**.
1. On the pane Add or create resources, under **Servers**, click **Add**.

    Use any of the three options:

    * Adding Servers using the DNS name or IP address

        1. Click the tab **Add one**.
        1. On the tab Add one Under **Server name**, type the name or IP address of the server. When the message **Found ...** appears, click the button **Add**.

    * Adding Servers from a CSV file

        The csv file must the columns:

        name, type, tags, groupId

        * **name** is the name of the server
        * **type** must be ```msft.sme.connection-type.server```
        * **tags** may be empty
        * **groupId** must be **global**

        1. Click the tab **Import a list**.
        1. On the tab Import a list, click the button **Select a file** to select the file.
        1. After the list of servers appears, click **Add**.

    * Adding Servers from Active Directory

        1. Click the tab **Search Active Directory**.
        1. On the tab Search Active Directory, in Enter search name, wildcard is supported, type the name of the server to search for. You may use the asterisk or question mark as wildcards for any part of the name. Click the button **Search**.
        1. In the list of servers found, activate the checkbox beside the servers to add.
        1. Click **Add**.

## References

[Manage Servers with Windows Admin Center](https://learn.microsoft.com/en-us/windows-server/manage/windows-admin-center/use/manage-servers)