# Lab: Managing hybrid servers using Azure Arc

## Required VMs

* VN1-SRV1
* VN1-SRV8

## Setup

Your instructor will tell you which tenant, subscription, and resource group to use.

You need to complete the practices befor starting with the lab.

1. [Create a Log Analytics Workspace](/Instructions/Practices/Create-a-Log-Analytics-Workspace.md)
1. [Create an Automation account](/Instructions/Practices/Create-an-Automation-account.md)
1. [Add server to Azure Arc](/Instructions/Practices/Add-server-to-Azure-Arc.md)

## Introduction

To increase manageability and security of servers, Adatum wants to add on-premises servers as Azure resources using Azure Arc. Policies should be implemented to monitor configuration glitches. Data should be collected from the connected servers for further analysis in the Azure Portal. Moreover, Adatum wants to manage the on-premises server using Windows Admin Center without an on-premises Windows Admin Center installation. Finally, Adatum wants to manage updates for servers using the Azure Portal and ensure, the servers are up-to-date.

## Known issues

In some cases, the permissions to create policies must be assigned in the Azure subscription. the role **Resource Policy Contributor** must be assigned to the student's account. It can take 5 - 15 minutes until the change is applied. See <https://learn.microsoft.com/en-us/answers/questions/8713/what-is-the-min-iam-role-required-to-create-azure>.

## Exercises

1. [Working with policies](#exercise-1-working-with-policies)
1. [Monitor a hybrid machine with VM insights](#exercise-2-monitor-a-hybrid-machine-with-vm-insights)
1. [Tracking changes](#exercise-3-tracking-changes)
1. [Azure update management](#exercise-4-azure-update-management)

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

## Exercise 2: Monitor a hybrid machine with VM insights

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
1. Under Create new rule, beside **Data collection rule name**, type your name or initials followed by **-Adatum-Log-Analytics-Workspace**. Activate the checkbox **Enable processes and dependencies (Map)**. Beside **Subscription**, ensure the subsription used for this lab is selected. Beside **Log Analytics workspaces**, click **Adatum-Log-Analytics-Workspace**. Click **Create**.
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

## Exercise 3: Tracking changes

1. [Enable change tracking](#task-1-enable-change-tracking) for VN1-SRV8
1. [Validate change tracking](#task-2-validate-change-tracking)

### Task 1: Enable change tracking

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, expand **Operations** and click **Change tracking**.
1. In VN1-SRV8 | Change Tracking and Inventory, under **Log analytics workspace**, ensure that your workspace is selected. Click **Enable**.

    Wait for the deployment to complete. This takes less than 5 minutes.

### Task 2: Validate change tracking

Perform this task on the host computer.

1. Open **Microsoft Edge** and navigate to <https://portal.azure.com>
1. Sign in to Azure.
1. In **Search resources, services and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, under **Operations**, click **Change tracking**.

    You will not see any changes to the machines, because we just enabled change tracking.

1. Click **Edit Settings**.
1. In Workspace Configuration, click the tab **Windows Services**.
1. On the tab Windows Services, under **Collection frequency**, drag the slider to the left to **10 sec**.
1. In the breadcrumb navigation at the top, click **VN1-SRV8 | Change tracking**.
1. Under **Operations** section, click **Inventory**.

    The tabs Software, Files, Windows Registry, and Windows Services will show no data, because no changes were detected recently

You might want to revisit this task at the end of the lab to see changes.

## Exercise 4: Azure update management

1. [Using Update management center, check for updates](#task-1-using-update-management-center-check-for-updates) on VN1-SRV8
1. [Enable periodic assessement](#task-2-enable-periodic-assessement) on VN1-SRV8
1. [Install updates](#task-3-install-updates) on VN1-SRV8
1. [Create a maintenance plan](#task-4-create-a-maintenance-plan) for VN1-SRV8 to automatically install all updates of all classifications daily at 7:00 PM
1. [Assign a policy](#task-5-assign-a-policy) to assign the maintenance plan to all machines added the the resource group WinFAD in the future

### Task 1: Using Update management center, check for updates

Perform this task on the host computer.

1. Open **Microsoft Edge**.
1. Navigate to <https://portal.azure.com> and sign in to Azure, if necessary.
1. In Microsoft Azure, in **Search resource, service, and docs (G+/)**, type **Azure Update Manager** and click it.
1. In Azure Update Manager, click **Get started**.
1. In Azure Update Manager | Get started, under **On-demand assessment and updates**, click **Check for updates**.
1. Under Select resources and check for updates, activate the checkbox left to **VN1-SRV8** and click **Check for updates**.

    If you do not see VN1-SRV8, ensure that the filter **Subscription** shows the correct subscription.

    Wait for the assessment to complete. You will be notified in the *Notications* icon. This will take some minutes.

### Task 2: Enable periodic assessement

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

    You might want to review the options in columns **Hotpatch** and **Patch orchetration**. However, these options are available for native Azure VMs only.

### Task 3: Install updates

Perform this task on the host computer.

1. Open **Microsoft Edge**.
1. Navigate to <https://portal.azure.com> and sign in to Azure, if necessary.
1. In Microsoft Azure, in **Search resource, service, and docs (G+/)**, type **Azure Update Manager** and click it.
1. In Azure Update Manager, under **Manage**, click **Machines**.
1. Under Azure Update Manager | Machines, activate the checkbox **Select all**, click **One-time update** and click **Install Now**.
1. In Install one-time updates, on tab Machines, ensure **VN1-SRV8** was added, and click **Next**.
1. On tab Updates, review the Windows updates to install and click **Next**.
1. On tab Properties, beside **Reboot option**, click **Reboot of required**. Beside **Maintenance windows (in minutes)**, type **60**. Click **Next**.
1. On tab Review + install, click **Install**.


### Task 6: Review the update status of server

Perform this task on the host computer.

1. Open **Microsoft Edge**.
1. Navigate to <https://portal.azure.com> and sign in to Azure, if necessary.
1. In Microsoft Azure, in **Search resource, service, and docs (G+/)**, type **VN1-SRV8** and click it.
1. In VN1-SRV8, under **Operations**, click **Updates**.

    Review the data on the tab **Recommende updates**.

1. Click the tab **History** and review the data.
