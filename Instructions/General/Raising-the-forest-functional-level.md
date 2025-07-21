# Raising the forest functional level

## Desktop experience

1. Open **Active Directory Administrative Center**.
1. In Active Directory Administrative Center, in the context-menu of the forest root domain, click **Raise the forest functional level...**
1. In Raise forest function level, click **OK**.
1. In the message box This change affects the entire forest. After you raise the forest functional level, it is possible that you may not be able to reverse it., click **OK**
1. In Raise Forest Functional Level, click **OK**.

## PowerShell

1. Open a terminal.
1. Set the forest mode to Windows Server 2025.

    ````powershell
    # Between the quotes, insert the FQDN name of the forest root domain
    $identity = ''

    Set-ADForestMode -Identity $identity -ForestMode Windows2025Forest
    ````

1. At the prompt **Performing the operation "Set" on target "CN=Partitions,CN=Configuration, ...**, enter **y**.

1. Check the forest mode.

    ````powershell
    Get-ADForest
    ````

    > The value for ForestMode should be Windows2025Forest.
