# Adding a registry value

1. Open a terminal
1. Configure the parameters.

    ````powershell
    $path = '' # Insert the registry key path
    $name = '' # Insert the name of the registry value
    $type = 'DWORD' # Change the type of the registry value, if required
    $value = $null # Change the value here
    ````

1. Add the registry value.

    * Local

    ````powershell
    New-Item $path -Force
    Set-ItemProperty -Path $path -Name $name -Value $value -Type $type
    ````

    * Remote

    ````powershell
    $computerName = '' # Insert the name of the computer to add the key to

    Invoke-Command -Computername $computerName -ScriptBlock {
        New-Item $path -Force
        Set-ItemProperty `
            -Path $using:path `
            -Name $using:name `
            -Value $using:value `
            -Type $using:type
    }
    ````
