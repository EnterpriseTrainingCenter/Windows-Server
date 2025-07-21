# Managing
 shares

## Desktop experience

1. Open **Server Manager**.
1. In Server manager, click **File and Storage Services**.
1. In File and Storage Services, click **Shares**

## Windows Admin Center

## Windows Admin Center

1. Navigate to Windows Admin Center.
1. If necessary, add the server to Windows Admin Center.

    [Adding servers to Windows Admin Center](./Adding-servers-to-Windows-Admin-Center.md)

1. In Windows Admin Center, click the server.
1. In the server page, unter Tools, click **Files & file sharing**.
1. Click the tab **File shares**.

## PowerShell

1. Open Terminal.
1. Configure the computername.

    ```powershell
    $computerName = '' # Between the quotes, insert the server name
    ````

List the shares on the remote computer:

```powershell
Invoke-Command -ComputerName $computerName { Get-SmbShare }
```

## References

[Get-SmbShare](https://learn.microsoft.com/en-us/powershell/module/smbshare/get-smbshare)
