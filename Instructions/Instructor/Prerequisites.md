# Course Prerequisites

For some practices and labs, access to an Azure Subscription and Entra ID tenant is required. The instructor or the training center must configure the Azure subscription using the following instructions.

## Entra ID users

Each student must have an individual user account in an Entra ID tenant. You can re-use the user accounts for several courses. In this case, you must reset the passwords for each user before the course.

* [Create users](#task-create-users)
* [Reset the password for users](#task-reset-the-password-for-users-optional)

### Task: Create users

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

### Task: Reset the password for users (optional)

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

1. On the left, click **Authentication methodes**.
1. In Authentication methods, click **Require re-register multifactor authentication**.
1. In Require re-register multifactor authentication, click **OK**.
1. On the breadcrumb navigation, click **Users**.

Repeat from step 8 for each student user.

## Entra ID tenants

For each student, an invidiual Entra ID tenant must be created. The student user must be added as guest with the role global administrator. The tenants can be reused for several courses.

1. [Create an Entra ID tenant](#task-1-create-an-entra-id-tenant)
1. [Add user as global administrator](#task-2-add-user-as-global-administrator)

### Task 1: Create an Entra ID tenant

1. Using a web browser, navigate to <https://portal.azure.com>.
1. Search for and click **Microsoft Entra ID**.
1. In Overview, click the button **Manage tentants**.
1. In Manage tenants, click the button **Create**.
1. In Create a tenant, on page Basics, under **Tenant type**, ensure **Microsoft Entra ID** is selected and click **Next: Configuration >**.
1. On page Configuration, beside **Organization name**, type a name of your choice, e.g., Course tenant 1. Beside **Initial domain name**, type a name of your choice. Leave the text box. Make sure, a green check mark is displayed beside the initial domain name. If not, enter a different name. Beside **Location**, click a location of your choice. Click **Review + Create**.
1. On page Review + create, take a note of Initial domain name and click **Create**.
1. In Help us prove you're not a robot, type the captcha and click **Submit**.
1. On the breadcrumb navigation, click **Manage tenants**.

Repeat from step 4 for additional tenants. New tenants will appear after a few minutes.

### Task 2: Add user as global administrator

1. Using a web browser, navigate to <https://portal.azure.com>.
1. In the top bar, click *Settings*.
1. In Portal settings, ensure **Directories + Subscriptions** is selected. Click the tab **All Directories**. Beside one of the student directories, click **Switch**.
1. Search for and click **Microsoft Entra ID**.
1. In Overview, expand **Manage** and click **Users**.
1. In Users, click **New user** and **Invite external user**.
1. In Invite external user, on the tab Basics, beside **Email**, type the user principal name of one of the student users. Click the tab **Assignments**.
1. On the tab **Assignments**, click **Add role**.
1. In the panel Directory roles, search and select the role **Global Administrator** and click **Selecte**.
1. In Invite external user, click **Review + invite**.
1. On the tab Review + invite, save the **Invite redirect URL** and click **Invite**.
1. On the breadcrumb navigation, click **Manage tenants**.

Repeat from step 2 for each tenant.

The following steps are optional, if you do not want to distribute the invite URLs to the students.

1. Using a web browser in private or guest mode, navigate to the Invite redirect URL.
1. Sign in with the student user.
1. Click **Accept**.

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
