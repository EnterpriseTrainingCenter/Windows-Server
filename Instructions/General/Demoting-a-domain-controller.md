# Demoting a domain controller

*Note*: Demoting a domain controller works locally on the server itself only.

## Desktop experience

1. Open **Server Manager**.
1. In Server Manager, on the menu, click **Manage**, **Remove Roles and Features**.
1. In Remove Roles and Features Wizard, on page Before You Begin, click **Next >**.
1. On page Server Selection, click the domain controller to demote and click **Next >**.
1. On page Remove server roles, deactivate **Active Directory Domain Services**.
1. In dialog Remove features that require Active Directory Domain Services, click **Remove Features**.
1. In dialog Validation Results, click **Demote this domain controller**.
1. In Active Directory Domain Services Configuration Wizard, on page Credentials, click **Change...**.
1. In the dialog Credentials for deployment operation, if necessary, enter the credentials for a Domain Administrator and click **OK**.
1. On page **Credentials**, click **Next >**.
1. On page Warnings, activate **Proceed with removal** and click **Next >**.
1. On page Removal Options, deactivate **Remove DNS delegation** and click **Next >**.
1. On page New Administrator Password, in **Password** and **Confirm password**, type a secure password, and take a note.
1. On page Review Options, click **Demote**.
1. On page Results, click **Close**.

### Troubleshooting

If you receive any error message, in step 9, activate the check box **Force the removal of the domain controller**.

If this still fails, shut down the server and do not start it again.

Additionally, you must remove the orphaned domain controller objects from Active Directory.

[Removing an orphaned domain controller from Active Directory](./Removing-an-orphaned-domain-controller-from-Active-Directory.md)

## PowerShell

1. Open a terminal.
1. At the prompt Local Administrator password enter a secure password and take a note.
1. Demote the domain controller.

    ````powershell
    Uninstall-ADDSDomainController
    ````

1. At the prompt LocalAdministratorPassword and Confirm LocalAdministratorPassword enter a secure password and take a note.

    Wait for the process to finish. The value of the property **Status** should be **Success**.

### Troubleshooting

If you receive any error message, append the parameter ```-DemoteOperationMasterRole -ForceRemoval``` to the cmdlet ```Uninstall-ADDSDomainController```. The command should read:

```powershell
Uninstall-ADDSDomainController `
    -LocalAdministratorPassword $localAdministratorPassword `
    -DemoteOperationMasterRole `
    -ForceRemoval `
    -Force
```

If this still fails, shut down the server and do not start it again.

Additionally, you must remove the orphaned domain controller objects from Active Directory.

[Removing an orphaned domain controller from Active Directory](./Removing-an-orphaned-domain-controller-from-Active-Directory.md)

## References

[Demote domain controllers and domains](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/demoting-domain-controllers-and-domains--level-200-)

[Uninstall-ADDSDomainController](https://learn.microsoft.com/en-us/powershell/module/addsdeployment/uninstall-addsdomaincontroller)
