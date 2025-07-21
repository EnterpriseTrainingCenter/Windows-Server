# Transferring flexible single master operation roles

## Desktop experience

### RID master, PDC emulator, Infrastructure master

1. Open **Active Directory Users and Computers**.
1. In Active Directory Users and Computers, in the context-menu of the domain, click **Change Domain Controller...**.
1. In Change Directory Server, click the target server for the FSMO transfer and click **OK**.
1. In the context-menu of the domain, click **Operations Masters...**
1. In Operations Masters, click the tab for the flexible single master operation role to transfer (either **RID**, **PDC**, or **Infrastructure**).
1. Click **Change...**
1. In the message box **Are you sure you want to transfer the operations master role?**, click **Yes**.
1. In the message box **The operations master role was successfully transferred.**, click **OK**.
1. In **Operations Masters**, click **Close**.

### Domain Naming master

1. Open **Active Directory Domains and Trusts**.
1. In Active Directory Domains and Trusts, in the context-menu of **Active Directory Domains and Trusts**, click **Change Active Directory Domain Controller...**
1. In Change Directory Server, click the target server for the FSMO transfer and click **OK**.
1. In the context-menu of **Active Directory Domains and Trusts**, click **Operations Master...**
1. In Operations Master, click **Change...**
1. In the message box **Are you sure you want to transfer the operations master role to a different computer?**, click **Yes**.
1. In the message box **The operations master role was successfully transferred.**, click **OK**.
1. In **Operations Master**, click **Close**.

### Schema master

1. Open a terminal.
1. Register the Schema Management snap-in.

    ````shell
    regsvr32.exe C:\Windows\System32\schmmgmt.dll
    ````

1. In the message box **DllRegisterServer in C:\Windows\System32\schmmgmt.dll succeeded.**, click **OK**.
1. Open an empty MMC.

    ````shell
    mmc.exe
    ````

1. In Console1 - [Console Root], in the menu, click **File**, **Add /Remove Snap-In...**
1. In Add or Remove Snap-Ins, click **Active Directory Schema**, click **Add >**, and click **OK**.
1. In the context-menu of **Active Directory Schema**, click **Change Active Directory Domain Controller...**
1. In Change Directory Server, click the target server for the FSMO transfer and click **OK**.
1. In the message box **Active Directory Schema snap-in is not connected to the schema operations master. You will not be able to perform any changes. Schema modifications can only be made on the schema FSMO holder.**, click **OK**.
1. In the context-menu of **Active Directory Schema**, click **Operations Master...**
1. In Operations Master, click **Change**.
1. In the message box **Are you sure you want to change the Operations Master?**, click **Yes**.
1. In the message box **Operations Master successfully transferred.**, click **OK**.
1. In **Operations Master**, click **Close**.

## PowerShell

1. Open a terminal.
1. Move the flexible single master operation roles.

    ```powershell
    # Between the quotes, insert the target server for the transfer
    $identity = ''
    
    <#
        Between the quotes, insert either RIDMaster, InfrastructureMaster,
        PDCEmulator, DomainNamingMaster, or SchemaMaster

        You may also transfer multiple roles at once by providing an
        array of roles, e.g.,
        
        $operationMasterRole = @(
            'RIDMaster'
            'InfrastructureMaster'
            'PDCEmulator'
            'DomainNamingMaster'
            'SchemaMaster'
        )
    #>
    $operationMasterRole = ''
    Move-ADDirectoryServerOperationMasterRole `
        -Identity $identity -OperationMasterRole $operationMasterRole
    ```

## References

[How to view and transfer FSMO roles](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/view-transfer-fsmo-roles)

[Move-ADDirectoryServerOperationMasterRole](https://learn.microsoft.com/en-us/powershell/module/activedirectory/move-addirectoryserveroperationmasterrole?view=windowsserver2025-ps)