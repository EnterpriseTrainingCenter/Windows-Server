# Enabling the Database 32k pages optional feature

1. Open a terminal.
1. Enable the Database 32k pages optional feature.

    ````powershell
    $server = '' # The FQDN of a domain controller
    $target = '' # The FQDN of the domain
    Enable-ADOptionalFeature `
        -Identity 'Database 32k pages feature' `
        -Scope 'ForestOrConfigurationSet' `
        -Server $server `
        -Target $target
    ````

1. At the prompt Confirm, enter **y**.
