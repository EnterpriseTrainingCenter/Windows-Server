# Practice: Add server to Azure Arc

## Required VMs

* VN1-SRV1
* VN1-SRV8
* CL1

## Setup

Your instructor will tell you which tenant, subscription, and resource group to use.

If you skipped the lab [Windows Admin Center](/Instructions/Labs/Windows-Admin-Center.md):

1. On VN1-SRV4, execute ````c:\LabResources\Solutions\Install-AdminCenter.ps1````.
1. Create connections in Windows Admin Center.
1. Register Windows Admin Center with Azure.

Detailed instructions can be found in the lab.

## Task

Onboard VN1-SRV8 to Azure Arc.

## Instructions

Perform this task on VN1-SRV8.

1. Sign in as **ad\Administrator**.
1. In **Server Manager**, click **Local Server**.
1. Under Local Server, under PROPERTIES, beside **Azure Arc Management**, click **Disabled**.
1. In Azure Arc Setup, on page Get started, click **Next >**.

    Wait for the Azure Connected Machine agent to install. This takes a minute or two.

1. On page Install Azure Arc, click **Configure**.
1. In Azure Arc Configuration, on page Configure Azure Arc, click **Next >**.
1. On page Sign in to Azure, under **Select an Azure cloud**, ensure **Azure Global** is selected. Click **Sign in to Azure**.
1. In Microsoft Edge, sign in zu Azure.
1. Close **Microsoft Edge**.
1. In **Azure Arc Configuration**, on page Sign in to Azure, click **Next >**.
1. On page Resource details, select **Azure Active Directory Tenant**, **Subscription**, **Resource Group**, and **Azure Region**. Under **Network Connectivity**, ensure **Public endpoint** is selected and click **Next >**.
1. On page Connecting your server, wait for the connection to be successful and click **Finish**.
