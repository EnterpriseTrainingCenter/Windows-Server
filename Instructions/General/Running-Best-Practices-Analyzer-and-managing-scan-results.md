# Running Best Practices Analyzer scans and managing scan results

## Desktop experience

1. Open **Server Manager**.
1. If necessary, add the server to analyze to Server Manager.

    [Adding servers to Server manager](./Adding-servers-to-Server-Manager.md)

1. In Server Manager:

    * To analyze all roles of a server, click **All Servers**.
    * To analyze a specific role on a server, in the side bar, click the role to analyze.
1. In SERVERS, click the server to analyze.
1. Under BEST PRACTICES ANALYZER (you may have to scroll down), click **Tasks**, **Start BPA Scan**.
1. In Select Servers, select all servers to scan and click **Start Scan**.

## PowerShell

1. Open a terminal.
1. Configure the parameters:

    ```powershell
    <#
        $computerName is the name of the server
    #>
    $computerName = ''
    ```

1. Get supported BPA models on a remote computer:

    ```powershell
    Invoke-Command -ComputerName $computerName -ScriptBlock { Get-BpaModel }
    ```

1. Run BPA models on a remote computer:

    Run all BPA models:

    ```powershell
    Invoke-Command -ComputerName $computerName -ScriptBlock { 
        Get-BpaModel | Invoke-BpaModel
    }
    ````

    Run a specific model

    ```powershell
    # $bpaModelId must be set to the ID of a specific model
    $bpaModelId = ''
    Invoke-Command -ComputerName $computerName -ScriptBlock { 
        Invoke-BpaModel -Id $bpaModelId
    }
    ````

1. Get the BPA results

    ```powershell
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        Get-BpaResult -Id $bpaModelId
    }
    ```

## References

[Run Best Practices Analyzer Scans and Manage Scan Results](https://learn.microsoft.com/en-us/windows-server/administration/server-manager/run-best-practices-analyzer-scans-and-manage-scan-results)