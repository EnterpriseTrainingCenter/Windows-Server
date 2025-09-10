# Lab: Managing hybrid servers using Azure Arc

## Required VMs

* VN1-SRV1
* VN1-SRV8

## Setup

Your instructor will tell you which tenant, subscription, and resource group to use.

You need to complete the practices before starting with the lab.

1. [Create a Log Analytics Workspace](/Instructions/Practices/Create-a-Log-Analytics-Workspace.md)
1. [Add server to Azure Arc](/Instructions/Practices/Add-server-to-Azure-Arc.md)

## Introduction

To increase manageability and security of servers, Adatum wants to add on-premises servers as Azure resources using Azure Arc. Policies should be implemented to monitor configuration glitches. Data should be collected from the connected servers for further analysis in the Azure Portal. Moreover, Adatum wants to manage the on-premises server using Windows Admin Center without an on-premises Windows Admin Center installation. Finally, Adatum wants to manage updates for servers using the Azure Portal and ensure, the servers are up-to-date.

## Known issues

In some cases, the permissions to create policies must be assigned in the Azure subscription. the role **Resource Policy Contributor** must be assigned to the student's account. It can take 5 - 15 minutes until the change is applied. See <https://learn.microsoft.com/en-us/answers/questions/8713/what-is-the-min-iam-role-required-to-create-azure>.

## Exercises

1. [Working with policies](#exercise-1-working-with-policies)
1. [Using Windows Admin Center in the Azure Portal](#exercise-2-using-windows-admin-center-in-the-azure-portal)
1. [Monitor a hybrid machine with VM insights](#exercise-3-monitor-a-hybrid-machine-with-vm-insights)
1. [Tracking changes](#exercise-4-tracking-changes)
1. [Azure update management](#exercise-5-azure-update-management)

## Exercise 1: Working with policies

1. [Assign recommended policies](#task-1-assign-recommended-policies) to VN1-SRV8
1. [Create a policy assignment to identify non-compliant resources](#task-2-create-a-policy-assignment-to-identify-non-compliant-resources)
1. [Monitor compliance](#task-3-monitor-compliance)

    > What is the state of the policy Audit Windows VMs with a pending reboot and why?

    > What is the state of the policy Audit Windows machines that contain certificate expiring within the specified number of days and why?

    > What is the state of the policy Windows machines should have Log Analytics agent installed on Azure Arc and why?

### Task 1: Assign recommended policies

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, in Overview, click the tab **Recommendations**.
1. Click the tab **Capabilities**.
1. On the tab Capabilities, click **Policies**.
1. In the pane Assign recommended policies, activate **Audit Windows VMs with a pending reboot** and **Audit Windows machines that contain certificates expiring with the specified number of days** and click **Assign Policies**.

### Task 2: Create a policy assignment to identify non-compliant resources

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **Policy** and click it.
1. In Policy, under **Authoring**, click **Assignments**.
1. In Policy | Assignments, click **Assign policy**.
1. In Assign policy, on tab Basics, under **Scope**, click the ellipsis.
1. In the pane Scope, click the **Subscription**, **Resource Group**, and click **Select**.
1. In Assign policy, under **Basics**, **Policy definition**, click the ellipsis.
1. In the pane Available Definitions, in search, type **Log Analytics extension should be installed on your Windows Azure Arc machines**. Click **\[Preview\]: Log Analytics extension should be installed on your Windows Azure Arc machines** and click **Add**.
1. Click **Review + Create**.
1. On tab Review + Create, click **Create**.

### Task 3: Monitor compliance

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **Policy** and click it.
1. In **Policy**, click **Compliance**.

    > The policy Audit Windows VMs with a pending reboot will have the state Non-Compliant with a resource compliance of 0 out of 1, because VN1-SRV8 should not have a pending reboot.

    > The policy Audit Windows machines that contain certificate expiring within the specified number of days will have the state Non-Compliant with a resource compliance of 0 out of 1, because VN1-SRV8 should not have expiring certificates.

    > The policy \[Preview\]: Log Analytics extension should be installed on your Windows Azure Arc machines will have the state Non-Compliant with a resource compliance of 0 out of 1, because VN1-SRV8 does not have an agent installed yet. You will fix that in an upcoming exercise.

    You may want to click one or the other of the policy to review details.

## Exercise 2: Using Windows Admin Center in the Azure Portal

1. [Install Windows Admin Center in the Azure portal](#task-1-install-windows-admin-center-in-the-azure-portal) for VN1-SRV5
1. [Assign user to the role Windows Admin Center Administrator login](#task-2-assign-user-to-the-role-windows-admin-center-administrator-login)
1. [Validate Windows Admin Center in the Azure portal](#task-3-validate-windows-admin-center-in-the-azure-portal)

    > Can you establish a Remote Desktop connection?
    
    > Can you establish a remote PowerShell connection?

    > How does the connection between the client and the server work?

### Task 1: Install Windows Admin Center in the Azure portal

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV5** and click it.
1. In VN1-SRV5, under **Licenses**, click **Windows Server**.
1. In VN1-SRV5 | Windows Server, under **Azure Benefits**, click to activate **By checking this box, you attest that your Windows Server licenses have active Software Assurance or your Windows Server licenses are active subscription licenses.** Click **Confirm**.
1. In VN1-SRV5, under **Settings**, click **Windows Admin Center (preview)**.
1. In VN1-SRV5 | Windows Admin Center (preview), click **Set up**.
1. In the pane Windows Admin Center, take a note of the **Listening port**, e.g., 6516 and click **Install**.

    The deployment will take a few minutes. You may continue with the lab. The deployment has to complete before you can use Windows Admin Center.

### Task 2: Assign user to the role Windows Admin Center Administrator login

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV5** and click it.
1. In VN1-SRV5, click **Access control (IAM)**.
1. In VN1-SRV5 | Access control (IAM), click **Add**, **Add role assignment**.
1. In Add role assignment, on tab Role, click **Windows Admin Center Administrator login** and click **Next**.
1. On tab Members, ensure **User, group, or service principal** is selected and click **+ Select members**.
1. In the pane Select members, search and click your Azure AD user account and click **Select**.
1. In **Add role assignment**, click **Review + assign**.
1. On tab Review + assign, click **Review + assign**.

### Task 3: Validate Windows Admin Center in the Azure portal

Before continuing with this task, ensure the deployment of Windows Admin Center in the portal has finished. You may continue with the lab and return to this task later.

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV5** and click it.
1. In VN1-SRV5, under **Settings**, click **Windows Admin Center (preview)**.
1. In VN1-SRV5 | Windows Admin Center (preview), click **Connect**.
1. In Windows Admin Center, unter **Tools**, click **Settings**.
1. In Settings, click **Remote Desktop**.
1. In Settings | Remote Desktop, click **Allow remote connections to this computer** and click **Save**.
1. Under **Tools**, click **Remote Desktop**.
1. In Remote Desktop, type the credentials of **ad\Administrator**, activate **Automatically connect with the certificate presented by this machine** and click **Connect**.

    > A Remote Desktop connection should be established successfully.

    > No direct connection between the computer connected to Windows Admin Center and the target computer is necessary.

1. In SConfig, enter **12**.
1. At the prompt Are You sure you want to log off, enter **y**.
1. Under **Tools**, click **PowerShell**.
1. In PowerShell, enter the credentials for **ad\Administrator**.

    > A remote PowerShell connection should be established successfully.

    > No direct connection between the computer connected to Windows Admin Center and the target computer is necessary.

1. Query computer info.

    ````powershell
    Get-ComputerInfo
    ````

    Confirm, that you see the information of VN1-SRV5.

1. Exit from the remote PowerShell session.

    ````powershell
    Exit-PSSession
    ````

1. Under **Tools**, click **Roles & features**.
1. In Roles and Features, click **Windows Server Update Services**. Deactivate the checkbox beside **SQL Server Connectivity**. Click **Install**.
1. In the pane Install roles and Features, click **Yes**.

## Exercise 3: Monitor a hybrid machine with VM insights

1. [Enable VM insights](#task-1-enable-vm-insights) for VN1-SRV8
1. [View data collected](#task-2-view-data-collected)

### Task 1: Enable VM insights

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, from the left-pane under the **Monitoring** section, click **Insights**.
1. In VN1-SRV8 | Insights, click **Enable**.
1. On the pane Azure Monitor, click **Enable**.
1. On the pane Monitoring configuration, beside **Subscription**, click the subscription you used for this lab. Beside **Data collection rule**, click **Create New**.
1. Under Create new rule, beside **Data collection rule name**, type your name or initials followed by **-Adatum-Log-Analytics-Workspace**. Activate the checkbox **Enable processes and dependencies (Map)**. Beside **Subscription**, ensure the subscription used for this lab is selected. Beside **Log Analytics workspaces**, click **Adatum-Log-Analytics-Workspace**. Click **Create**.
1. On the pane **Monitoring configuration**, click **Configure**.

    Wait for the deployment to complete. This process takes 5 - 10 minutes.

### Task 2: View data collected

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, from the left-pane under the **Monitoring** section, click **Insights**.
1. In VN1-SRV8 | Insights, click the tab **Performance**.

    You should see performance data. If not, wait a few minutes and click **Refresh**.

1. Click the tab **Map**.

    If the map cannot be displayed yet, continue with the lab and try later.

1. Click on VN1-SRV8 and review the information. Click on other elements in the map and review the information.
1. At the top, click **View Workbooks**, **Performance** and review the analysis.
1. In the breadcrumb navigation at the top, click **VN1-SRV8 | Insights**.
1. In VN1-SRV8 | Insights, at the top, click **View Workbooks**, **Connections Overview** and review the information.

## Exercise 4: Tracking changes

1. [Enable change tracking](#task-1-enable-change-tracking) for VN1-SRV8
1. [Validate change tracking](#task-2-validate-change-tracking)

### Task 1: Enable change tracking

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, expand **Operations** and click **Change tracking**.
1. In VN1-SRV8 | Change Tracking, click **Open Change and Inventory Center**.
1. In Change Tracking and Inventory Center | Machines, activate the checkbox beside **VN1-SRV8** and click **Enable Change Tracking & Inventory**.
1. In the dialog Enable Change Tracking now for 1 selected machines, click **Yes**.
1. In Enable Change Tracking, click **Enable**.

    The deployment may take a long time. You cannot continue with task 2 until the deployment has finished. Consider proceeding with the next Exercise and revisiting the next task later.

### Task 2: Validate change tracking

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **Change tracking and Inventory Center** and click it.
1. In Change tracking and Inventory Center, under **Manage**, click **Change tracking**.

    You will not see any changes to the machines, because we just enabled change tracking.

1. Click **Settings**.
1. In Workspace Configuration, click the tab **Windows Services**.
1. On the tab Windows Services, under **Collection frequency**, drag the slider to the left to **10 sec**.
1. In the breadcrumb navigation at the top, click **VN1-SRV8 | Change tracking**.
1. Under **Operations** section, click **Inventory**.

    The tabs Software, Files, Windows Registry, and Windows Services will show no data, because no changes were detected recently

You might want to revisit this task at the end of the lab to see changes.

## Exercise 5: Azure update management

1. [Using Update management center, check for updates](#task-1-using-update-management-center-check-for-updates) on VN1-SRV8
1. [Enable periodic assessment](#task-2-enable-periodic-assessment) on VN1-SRV8
1. [Install updates](#task-3-install-updates) on VN1-SRV8
1. [Review the update status of server](#task-4-review-the-update-status-of-server) VN1-SRV8

### Task 1: Using Update management center, check for updates

Perform this task on the host computer.

1. Open **Microsoft Edge**.
1. Navigate to <https://portal.azure.com> and sign in to Azure, if necessary.
1. In Microsoft Azure, in **Search resource, service, and docs (G+/)**, type **Azure Update Manager** and click it.
1. In Azure Update Manager, click **Get started**.
1. In Azure Update Manager | Get started, under **On-demand assessment and updates**, click **Check for updates**.
1. Under Select resources and check for updates, activate the checkbox left to **VN1-SRV8** and click **Check for updates**.

    If you do not see VN1-SRV8, ensure that the filter **Subscription** shows the correct subscription.

    Wait for the assessment to complete. You will be notified in the *Notifications* icon. This will take some minutes.

### Task 2: Enable periodic assessment

Perform this task on the host computer.

1. Open **Microsoft Edge**.
1. Navigate to <https://portal.azure.com> and sign in to Azure, if necessary.
1. In Microsoft Azure, in **Search resource, service, and docs (G+/)**, type **Azure Update Manager** and click it.
1. In Azure Update Manager, click **Overview**.

    Review the data on the page.

1. Click **Settings** and then **Update settings**.
1. In Change update settings, click **Add machine**.
1. In Select resources, activate the checkbox left to **VN1-SRV8** and click **Add**.
1. In **Change update settings**, under **Windows (1)**, in the top row, in column **Periodic assessment**, click **Enable**. Click **Save**.

    You might want to review the options in columns **Hotpatch** and **Patch orchestration**. However, these options are available for native Azure VMs only.

### Task 3: Install updates

Perform this task on the host computer.

1. Open **Microsoft Edge**.
1. Navigate to <https://portal.azure.com> and sign in to Azure, if necessary.
1. In Microsoft Azure, in **Search resource, service, and docs (G+/)**, type **Azure Update Manager** and click it.
1. In Azure Update Manager, under **Resources**, click **Machines**.
1. Under Azure Update Manager | Machines, activate the checkbox **Select all**, click **One-time update** and click **Install Now**.
1. In Install one-time updates, on tab Machines, ensure **VN1-SRV8** was added, and click **Next**.
1. On tab Updates, review the Windows updates to install and click **Next**.
1. On tab Properties, beside **Reboot option**, click **Reboot of required**. Beside **Maintenance windows (in minutes)**, type **60**. Click **Next**.
1. On tab Review + install, click **Install**.

### Task 4: Review the update status of server

Perform this task on the host computer.

1. Open **Microsoft Edge**.
1. Navigate to <https://portal.azure.com> and sign in to Azure, if necessary.
1. In Microsoft Azure, in **Search resource, service, and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, under **Operations**, click **Updates**.

    Review the data on the tab **Recommendeds updates**.

1. Click the tab **History** and review the data.
