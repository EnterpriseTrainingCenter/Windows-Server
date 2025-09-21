# Restarting a Server

## Desktop experience

1. Open **Server Manager** on your local machine.
1. In the left-hand menu, select **All Servers**.
1. Right-click the target server from the list.
1. Select **Restart Server**.
1. Confirm the restart when prompted.

## Windows Admin Center

1. Navigate to Windows Admin Center.
1. If necessary, add the server to be restarted to Windows Admin Center.

    [Adding servers to Windows Admin Center](./Adding-servers-to-Windows-Admin-Center.md)

1. In Windows Admin Center, click the server to be restarted.
1. In the left-hand menu, select **Overview**.
1. Click the **Restart** button at the top-right corner.
1. Confirm the restart when prompted.

## PowerShell

1. Open a terminal.
1. Run the following command to restart the remote server:

    ```powershell
    $computerName = '' # Between the quotes, insert the target server name
    Restart-Computer -ComputerName $computerName -Force
    ```
