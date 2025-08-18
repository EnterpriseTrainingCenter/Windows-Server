# Adding a registry value

1. Open a terminal
1. Add the registry value.

    ````powershell
    $computerName = '' # Insert the name of the computer to add the key to
    $path = '' # Insert the registry key path
    $name = '' # Insert the name of the registry value
    $type = 'DWORD' # Change the type of the registry value, if required
    $value = $null # Change the value here

    Invoke-Command -Computername $computerName -ScriptBlock {
        New-Item $path -Force
        Set-ItemProperty -Path $path -Name $path -Value $value -Type $type
    }
    ````
