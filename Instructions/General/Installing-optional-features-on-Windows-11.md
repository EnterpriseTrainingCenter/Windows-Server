# Installing optional features on Windows 11

## Desktop Experience

1. Open **Settings**.
1. In Settings, click **System**.
1. In System, click **Optional features**.
1. In Optional features, click **View features**.
1. In View features, if necessary, click **See available features**. In the text field **Find an available optional feature**, type the name of the optional feature to install.Activate the check box beside the feature to install. Click **Add (*n*)**.
1. If required, restart the computer.

## PowerShell

1. Open a Terminal as Administrator.
1. Optional: List available features:

    ```powershell
    Get-WindowsCapability -Online
    ```

1. Add the desired windows capability:

    ```powershell
    $name = '' # Between the quotes, insert the name of the feature
    Get-WindowsCapability -Online -Name $name |
    Add-WindowsCapability -Online
    ```

1. If required, restart the computer.

    ```powershell
    Restart-Computer
    ```

## References

[Add, remove, or hide Windows features](https://learn.microsoft.com/en-us/windows/client-management/client-tools/add-remove-hide-features?pivots=windows-11)

[Get-WindowsCapability](https://learn.microsoft.com/en-us/powershell/module/dism/get-windowscapability)

[Add-WindowsCapability](https://learn.microsoft.com/en-us/powershell/module/dism/add-windowscapability)