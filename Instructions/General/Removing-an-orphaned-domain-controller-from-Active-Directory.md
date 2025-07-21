# Removing an orphaned domain controller from Active Directory

1. Open **Terminal**.
1. Start ntdsutil.exe.

    ````shell
    ntdsutil.exe
    ````

1. Remove the domain controller by executing the following commands.

    ````shell
    Metadata cleanup
    ````

1. In metadata cleanup, change to connections.

    ````shell
    Connections
    ````

1. In connections, connect to any domain controller still operating

    ````shell
    Connect to server <FQDN of a domain controller>
    ````

1. Quit connections.

    ````shell
    Quit
    ````

1. In metadata cleanup, enter operation target selection.

    ````shell
    Select operation target
    ````

1. In select operation target, list the domains.

    ````shell
    List domains
    ````

    Take a note of the number to the left of the domain of the orphaned domain controller.

1. Select the domain. Ensure, you use the number, you noted in the previous step.

    ````shell
    Select domain <domain number>
    ````

1. List the sites.

    ````shell
    List sites
    ````

    Take a note of the number to the left of the site of the orphaned domain controller.

1. Select the site. Ensure, you use the number, you noted in the previous step.

    ````shell
    Select site <site number>
    ````

1. List the servers for the domain in the site.

    ````shell
    List servers for domain in site
    ````

    Take a note of the number to the left of the orphaned domain controller.

1. Select the server. Ensure, you use the number, you noted in the previous step.

    ````shell
    Select server <number of domain controller>
    ````

1. Quit the operation target selection.

    ````shell
    Quit
    ````

1. In metadata cleanup, remove the selected server.

    ````shell
    Remove selected server
    ````

1. In the message box Server Remove Confirmation Dialog, ensure, that you remove the correct domain controller. Click **Yes**.

1. Quit metadata cleanup.

    ````shell
    Quit
    ````

1. Quit ntdsutil.exe.

    ````shell
    Quit
    ````

1. Open **Active Directory Sites and Services**.
1. In Active Directory Sites and Services, expand **Sites**, the name of the site of the orphaned domain controller, **Servers**.
1. In the context menu of the orphaned server object, click **Delete**.
1. In the message box Are you sure you want to delete the Server named..., click **Yes**.
