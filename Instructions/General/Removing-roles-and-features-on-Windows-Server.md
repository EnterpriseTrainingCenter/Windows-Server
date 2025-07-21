# Removing roles and features on Windows Server

## Desktop experience

1. Open **Server Manager**.
1. If necessary, add the server to install the role or feature on to Server Manager.

    [Adding servers to Server Manager](./Adding-servers-to-Server-Manager.md)

1. In Server Manager, in the menu, click **Manage**, **Remove Roles and Features**.
1. In Remove Roles and Features Wizard, on page Before You Begin, click **Next >**.
1. On page Server Selection, click the server to install the feature on and click **Next >**.
1. On page Server Roles, deactivate the checkboxes beside the roles to uninstall.
1. If the dialog **Remove features that are required for ...?** appears, click **Remove Features**.
1. On page **Server Roles**, click **Next >**.
1. On page Features, deactivate the checkboxes beside the features to uninstall.
1. If the dialog **Remove features that are required for ...?** appears, click **Remove Features**.
1. On page **Features** click **Next >**.
1. On page **Confirmation**, activate the checkbox **Restart the destination server automatically if required** and click **Remove**.
1. On page **Results**, click **Close**.

## Windows Admin Center

1. Navigate to **Windows Admin Center**.
1. If necessary, add the server to install the role or feature on to Server Manager.

    [Adding servers to Windows Admin Center](./Adding-servers-to-Windows-Admin-Center.md)

1. On the Windows Admin Center page, click the server to install the features on.
1. On the server page, unter Tools, click **Roles & features**.
1. Under Roles and features, click the role or features to uninstall and click **Uninstall**.
1. In the pane Uninstall Role and Features, activate the checkbox **Reboot the server automatically if required**, and click **Yes**.

## PowerShell

1. Open a terminal.
1. Install the windows feature.

    * Installing roles or feature on a single server

        ```powershell
        <#
            Between the quotes, insert the name of the server to install the 
            feature on
        #>
        $computername = ''

        <#
            Between the quotes, insert the name of the feature to install.
            Multiple features can be installed by providing a comma-separated
            list.
        #>
        $name = ''
        Remove-WindowsFeature `
            -Computername $computername `
            -Name $name `
            -Restart
        ```

    * Installing roles and features on multiple servers in parallel

        ```powershell
        <#
            Between the quotes, insert the names of the servers separated by 
            commas to install the feature on
        #>
        $computername = ''

        <#
            Between the quotes, insert the name of the feature to install.
            Multiple features can be installed by providing a comma-separated
            list.
        #>
        $name = ''
        Invoke-Command -Computername $computername -ScriptBlock {
            Uninstall-WindowsFeature `
                -Name $using:name `
                -Restart

        }
        ```

## References

[Add or remove roles and features in Windows Server](https://learn.microsoft.com/en-us/windows-server/administration/server-manager/add-remove-roles-features)

[Manage Servers with Windows Admin Center](https://learn.microsoft.com/en-us/windows-server/manage/windows-admin-center/use/manage-servers)
