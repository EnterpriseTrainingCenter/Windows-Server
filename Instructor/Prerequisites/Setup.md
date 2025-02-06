# Course Prerequisites

For some practices and labs, access to an Azure Subscription and Entra ID tenant is required. The instructor or the training center must configure the Azure subscription. From a bird's view, the following tasks have to be finished before the course.

1. [Create Entra ID tenants](#create-entra-id-tenants)
1. [Prepare Entra ID users](#prepare-entra-id-users)
1. [Accept the invitations (optional)](#accept-the-invitations-optional)

The [Appendix](#appendix) contains a sample table to track all relevant data for the users.

After each course, the [Entra ID tenants must be deleted](#delete-entra-id-tenants), if possible. In rare cases, students might have removed your permissions to delete the tenant. In this case, the tenant can remain.

## Create Entra ID tenants

For each student, an invidiual Entra ID tenant must be created. The tenants cannot be reused for several courses.

1. Using a web browser, navigate to <https://portal.azure.com>.
1. Search for and click **Microsoft Entra ID**.
1. In Overview, click the button **Manage tentants**.
1. In Manage tenants, click the button **Create**.
1. In Create a tenant, on page Basics, under **Tenant type**, ensure **Microsoft Entra ID** is selected and click **Next: Configuration >**.
1. On page Configuration, beside **Organization name**, type a name of your choice, e.g., Course tenant 1. Beside **Initial domain name**, type a name of your choice. Leave the text box. Make sure, a green check mark is displayed beside the initial domain name. If not, enter a different name. Beside **Location**, click a location of your choice. Click **Review + Create**.
1. On page Review + create, take a note of Initial domain name and click **Create**.
1. In Help us prove you're not a robot, type the captcha and click **Submit**.

    You do not have to wait for the tenant creation to complete at this point.

1. On the breadcrumb navigation, click **Manage tenants**.

Repeat from step 4 for additional tenants. New tenants will appear after a few minutes.

## Prepare Entra ID users

Each student must have an individual user account in an Entra ID tenant. You can re-use the user accounts for several courses. In this case, you must reset the passwords for each user before the course. The users must be invited as guest users to the tenants you created and added to the global administrator role.

For your convenience, the script **Setup-Azure.ps1** is provided together with a sample CSV file users.csv. Furthermore, steps for manual setup are provided.

* [Prepare users using the script](#prepare-users-using-the-script)
* [Manually prepare users](#manually-prepare-users)

### Prepare users using the script

1. Edit the file **users.csv** and put it in the same directory as the script. As a minimum requirement, the columns **UserName**, **DisplayName**, and **Domain** must be filled in. Domain is the domain name of the Entra ID tenant for the user.
1. Run the script **Setup-Azure.ps1** from a PowerShell session.
1. Sign in with a user account you used to create the Entra ID tenants and with the permission to manage users and grant permissions to the script.
1. Select the domain to create the users in.
1. When prompted, sign in to Azure. No special permissions are required.
1. Sign in with a user account you used to create the Entra ID tenants and with the permission to manage users and grant permissions to the script. This will be required for each user tenant.

The script does the following:

1. If the user does not exist, it creates the user. If the user exists, the display name is adjusted, the password is reset and MFA is reset.
1. The user is invited to the Entra ID tenant for the user.
1. The user is added to the Global Administrator role in the Entra ID tenant for the user.

As a result, user principal names, passwords and invitation redeem URLs are written to the CSV. This can be distributed to the student.

### Manually prepare users

1. [Create users](#task-1-create-users)
1. [Reset the password and MFA for users](#task-2-reset-the-password-for-users)
1. [Invite users to the Entra ID tenants and add them to the global administrator role](#task-3-invite-users-to-the-entra-id-tenants-and-add-them-to-the-global-administrator-role)

#### Task 1: Create users

1. Using a web browser, navigate to <https://portal.azure.com>.
1. Search for and click **Subscriptions**.
1. Click the subscription, you want the students to use.

    In the subscription panel, note the Directory.

1. In the top bar, click *Settings*.
1. In Portal settings, ensure **Directories + Subscriptions** is selected. Click the tab **All directories**. If the directory noted before, is not Current, click **Switch** beside the correct directory.
1. Search for and click **Microsoft Entra ID**.
1. In Overview, expand **Manage** and click **Users**.
1. In All users, click **New user**, **Create new user**.
1. Create a new user with a user principal name, a display name and a password of your choice. Make sure **Account enabled** is activated.

Repeat steps 8 and 9 for each student in the course.

#### Task 2: Reset the password for users

This is only necessary for re-used identities.

1. Using a web browser, navigate to <https://portal.azure.com>.
1. Search for and click **Subscriptions**.
1. Click the subscription, you want the students to use.

    In the subscription panel, note the Directory.

1. In the top bar, click *Settings*.
1. In Portal settings, ensure **Directories + Subscriptions** is selected. If the directory noted before, is not Current, click **Switch** beside the correct directory.
1. Search for and click **Microsoft Entra ID**.
1. In Overview, expand **Manage** and click **Users**.
1. Click one of the users for the students.
1. In the user panel, click **Reset password**.
1. In the Reset password panel, click **Reset password**.

    Save the generated password.

1. On the left, click **Authentication methods**.
1. In Authentication methods, click **Require re-register multifactor authentication**.
1. In Require re-register multifactor authentication, click **OK**.
1. On the breadcrumb navigation, click **Users**.

Repeat from step 8 for each student user.

#### Task 3: Invite users to the Entra ID tenants and add them to the global administrator role

1. Using a web browser, navigate to <https://portal.azure.com>.
1. In the top bar, click *Settings*.
1. In Portal settings, ensure **Directories + Subscriptions** is selected. Click the tab **All Directories**. Beside one of the student directories, click **Switch**.
1. Search for and click **Microsoft Entra ID**.
1. In Overview, expand **Manage** and click **Users**.
1. In Users, click **New user** and **Invite external user**.
1. In Invite external user, on the tab Basics, beside **Email**, type the user principal name of one of the student users. Click the tab **Assignments**.
1. On the tab **Assignments**, click **Add role**.
1. In the panel Directory roles, search and select the role **Global Administrator** and click **Select**.
1. In Invite external user, click **Review + invite**.
1. On the tab Review + invite, save the **Invite redirect URL** and click **Invite**.
1. On the breadcrumb navigation, click **Manage tenants**.

Repeat from step 2 for each tenant.

## Accept the invitations (optional)

The following steps are optional, if you do not want to distribute the invite URLs to the students. For each student account, do the following:

1. Using a web browser in private or guest mode, navigate to the Invite redirect URL.
1. Sign in with the student user.
1. Click **Accept**.
1. Close the web browser.

Repeat these steps for each student account.

## Delete Entra ID tenants

1. Run the script **Clear-EntraTenants.ps1** from a PowerShell session.
1. Sign in to Azure. No special permissions are requried.
1. Sign in with a user account you used to create the Entra ID tenants and with the permission to manage users and grant permissions to the script. This will be required for each user tenant.
1. Using a web browser, navigate to <https://portal.azure.com>.
1. In the top bar, click *Settings*.
1. Search for and click **Microsoft Entra ID**.
1. In Overview, click **Manage tenants**.
1. Activate the check box on the left of one of the student tenants. Click **Delete**.

    You might be prompted to sign in again.

1. On Delete tenant, complete all steps still listed. You can return to this page using the breadcrumb navigation. When you completed all steps, click **Refresh**.
1. Click **Delete**.
1. On the top-right, click your user avatar and click **Switch directory**.
1. On Directories + subscriptions, click the tab **All Directories**.
1. Beside the next student tenant directory, click **Switch**.

    You might be prompted to sign in again.

Repeat from step 9 for each student tenant.

## Appendix

### Template for tracking users and Entra ID tenants

| User principal name                 | Password | Entra ID tenant               | Invite redirect URL                                                                 |
| ----------------------------------- | -------- | ----------------------------- | ----------------------------------------------------------------------------------- |
| courseuser@students.onmicrosoft.com | Abcd1234 | coursetenant1.onmicrosoft.com | https://myapplications.microsoft.com/?tenantid=f625b819-b068-49d6-a3b8-410d7848cd8d |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
|                                     |          |                               |                                                                                     |
