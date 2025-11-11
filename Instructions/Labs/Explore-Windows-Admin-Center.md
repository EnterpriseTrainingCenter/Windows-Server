# Lab: Explore Windows Admin Center

## Required VMs

* VN1-SRV1
* VN1-SRV2
* VN1-SRV3
* VN1-SRV4
* VN1-SRV5
* VN1-SRV6
* VN1-SRV7
* VN1-SRV8
* VN1-SRV9
* VN1-SRV10
* VN1-SRV11
* VN1-SRV12
* VN1-SRV13
* VN2-SRV1
* VN2-SRV2
* VN3-SRV1
* PM-SRV1
* PM-SRV2
* PM-SRV3
* PM-SRV4
* CL1
* CL2

## Setup

On **CL1**, logon as **ad\Administrator**.

If you skipped the practice [Install Windows Admin Center using a script](../Practices/Install-Windows-Admin-Center-using-a-script.md), on VN1-SRV4, run ````C:\LabResources\Solutions\Install-AdminCenter.ps1````.

## Introduction

After you installed Windows Admin Center, you want to find out, what you can do with it. For this purpose, you create connections to all servers and clients and explore the available administration features. Moreover, you browse through the the available extensions and try to install one.

## Exercises

1. [Connect](#exercise-1-connect)
1. [Manage connections](#exercise-2-manage-connections)
1. [Explore the available administration features](#exercise-3-explore-the-available-administration-features)
1. [Use tags](#exercise-4-use-tags)

## Exercise 1: Connect

[Using Microsoft Edge, navigate to https://admincenter.ad.adatum.com](#task-using-microsoft-edge-navigate-to-httpsadmincenteradadatumcom).

    > Why do you need to enter username and password?

### Task: Using Microsoft Edge, navigate to https://admincenter.ad.adatum.com

Perform this task on CL1.

1. In Microsoft Edge, navigate to https://admincenter.ad.adatum.com.
1. On page Sign in- Windows Admin Center, sign in with **ad\Administrator**.

## Exercise 2: Manage connections

[In Windows Admin Center, add connections](#task-in-windows-admin-center-add-connections) to VN1-SRV1, VN1-SRV5, VN1-SRV6, VN1-SRV2, CL1, and CL2.

### Task: In Windows Admin Center, add connections

Perform this task on CL1.

1. In Windows Admin Center, on the connections page, click **Add**.
1. In the panel **Add or create resources**, under **Server**, click **Add**.
1. On the tab **Add one**, in **Server name**, enter **VN3-SRV1**.
1. After VN3-SRV1 was found, click **Add**.
1. Click **Add**.
1. In the panel **Add or create resources**, under **Windows PCs**, click **Add**.
1. Click the tab **Search Active Directory**.
1. Enter **CL1** and click **Search**.
1. Activate the checkbox left to **CL1.ad.adatum.com** and click **Add**.
1. In the panel **Add or create resources**, under **Windows PCs**, click **Add**.
1. Click the tab **Search Active Directory**.
1. Enter **CL2** and click **Search**.
1. Activate the checkbox left to **CL2.ad.adatum.com** and click **Add**.
1. In the panel **Add or create resources**, under **Server**, click **Add**.
1. Click the tab **Search Active Directory**.
1. Enter **VN1-\*** and click **Search**.
1. Activate the checkbox left to the column header **Name** to select all servers and click **Add**.

## Exercise 3: Explore the available administration features

1. [Explore networks, updates, and the settings for power configuration and Remote Desktop](#task-1-explore-networks-updates-and-the-settings-for-power-configuration-and-remote-desktop) on VN1-SRV1
2. [Find installed apps and running processes](#task-2-find-installed-apps-and-running-processes) on VN1-SRV4
3. [Explore the registry, the scheduled tasks and the security](#task-3-explore-the-registry-the-scheduled-tasks-and-the-security) of VN1-SRV6
4. [Explore apps, features, devices](#task-4-explore-apps-features-devices) on CL2

### Task 1: Explore networks, updates, and the settings for power configuration and Remote Desktop

Perform this task on CL1.

1. In Windows Admin Center, on the connections page, click **VN1-SRV1.ad.adatum.com**. Explore the information on in the Overview tool.
1. In the Tools pane, click **Networks** and explore the available features.
1. In the Tools pane, click **Updates** and explore the available features.
1. In the Tools pane, click **Settings**.
1. In Settings, click **Power configuration** and explore the available features. 
1. In Settings, click **Remote Desktop** and explore the available features.

### Task 2: Find installed apps and running processes

Perform this task on CL1.

1. In Windows Admin Center, click **Windows Admin Center** in the top-left corner to return to the connections page.
1. On the connections page, click **VN1-SRV4.ad.adatum.com**. Explore the information on in the Overview tool.
1. In the Tools pane, click **Installed apps** and explore the available features.
1. In the Tools pane, click **Processes** and explore the available features.

### Task 3: Explore the registry, the scheduled tasks and the security

Perform this task on CL1.

1. In Windows Admin Center, click **Windows Admin Center** in the top-left corner to return to the connections page.
1. On the connections page, click **VN1-SRV6.ad.adatum.com**. Explore the information on in the Overview tool.
1. In the Tools pane, click **Registry** and explore the available features.
1. In the Tools pane, click **Scheduled tasks** and explore the available features.
1. In the Tools pane, click **Security** and explore the available features.

### Task 4: Explore apps, features, devices

Perform this task on CL1.

1. In Windows Admin Center, click **Windows Admin Center** in the top-left corner to return to the connections page.
1. On the connections page, click **CL2.ad.adatum.com**. Explore the information on in the Overview tool.
1. In the Tools pane, click **Apps & features** and explore the available features.
1. In the Tools pane, click **Devices** and explore the available features.

## Exercise 4: Use tags

1. [Add tags to the connections according to table below](#task-1-add-tags-to-the-connections).

    | Name                   | Tags                                                                  |
    |------------------------|-----------------------------------------------------------------------|
    | VN1-SRV1.ad.adatum.com  | core, dc, gc, domain naming, schema, primary, infrastructure, rid |
    | VN1-SRV2.ad.adatum.com  | desktop, pki                                                         |
    | VN1-SRV4.ad.adatum.com  | core, windows admin center                                           |
    | VN1-SRV5.ad.adatum.com  | core                                                                 |
    | VN1-SRV10.ad.adatum.com | desktop, file                                                        |
    | cl2.ad.adatum.com       | win11, office                                                        |

    > What is the most efficient way to add the tags manually?

    > Are tags case-sensitive?

1. [Filter the connection list to only show connections with the tag **core**](#task-2-filter-the-connection-list).

    > Which connections are displayed?

### Task 1: Add tags to the connections

Perform this task on CL1.

1. In Windows Admin Center, on the connections page, activate the checkbox left to **VN1-SRV5.ad.adatum.com**.
1. Click **Edit Tags**.
1. In Available tags, click **Add tags**, enter **core** and press ENTER.
1. Click **Save**.
1. Deactivate the checkbox left to **VN1-SRV5.ad.adatum.com**.
1. Activate the checkbox left to **VN1-SRV4.ad.adatum.com**.
1. Click **Edit Tags**.
1. In Available tags, activate **core**.

    > You can reuse tags.

1. Click **Add tags**, enter **Windows Admin Center** (with capitals) and press ENTER.

    > Tags can contain spaces. Moreover, the tags are normalized to lower case.

1. Click **Save**.
1. Dectivate the checkbox left to **VN1-SRV4.ad.adatum.com**.
1. Activate the checkboxes left to **VN1-SRV2.ad.adatum.com**, and **VN1-SRV10.ad.adatum.com**.
1. Click **Edit Tags**.
1. In Available tags, click **Add tags**, enter **desktop** and press ENTER.
1. Click **Save**.

    > You can add tags to multiple connections in a single operation.

1. Activate and deactivate the checkbox left to the column header **Name** to clear all selections.
1. Activate the checkbox left to **cl2.ad.adatum.com**.
1. Click **Add tags**, enter **win11, office** and press ENTER.

    > You can create multiple tags in a single operation by separating them with a comma.

1. Click **Save**.
1. Repeat the appropriate steps to add the remaining tags to the connections according to the table below.

    | Name                    | Tags                                                              |
    |-------------------------|-------------------------------------------------------------------|
    | VN1-SRV1.ad.adatum.com  | core, dc, gc, domain naming, schema, primary, infrastructure, rid |
    | VN1-SRV2.ad.adatum.com  | pki                                                               |
    | VN1-SRV10.ad.adatum.com | file                                                              |

### Task 2: Filter the connection list

Perform this task on CL1.

1. In Windows Admin Center, on the connections page, click the icon *Filter*.
1. In Filter connections, activate the checkbox left to **core** and click **Save**.

    > Only the connections **VN1-SRV1.ad.adatum.com**, **VN1-SRV4.ad.adatum.com**, and **VN1-SRV5.ad.adatum.com** should be displayed.

1. Click the icon *Filter* again.
1. In Filter connections, click **Clear filter** and click **Save**.
