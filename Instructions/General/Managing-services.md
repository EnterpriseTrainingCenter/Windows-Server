# Managing services

## Desktop experience

1. Open **Services**.
1. Double-click the service to manage.

## PowerShell

### Restarting a service

````powershell
$computerName = '' # Insert the name of the computer the service runs on
$name = '' # Insert the name of the service
Invoke-Command -ComputerName $computerName -ScriptBlock {
    Restart-Service $name
}
````