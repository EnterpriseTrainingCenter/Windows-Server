# Lab: Managing local administrator passwords

## Required VMs

* VN1-SRV1
* CL1
* CL2

## Setup

1. On **CL1**, sign in as **ad\Administrator**.
1. On **CL2**, sign in as **Administrator**.

## Exercises

1. [Implement Local Administrator Password Solution](#exercise-1-implement-local-administrator-password-solution)
1. [Use Local Administrator Password Solution](#exercise-2-use-local-administrator-password-solution)

## Exercise 1: Implement Local Administrator Password Solution

1. [Prepare Active Directory for LAPS](#task-1-prepare-active-directory-for-laps)
1. [Configure the policy for LAPS](#task-2-configure-the-policy-for-laps) and apply it to the domain. The Policy should configure the following settings:

    * Backup passwords to Active Directory
    * Enable the default administrator account and randomize its name
    * Configure password complexity to use large Letters, small letters, number, and specials with improved readability
    * Configure the password lenth with 14 characters
    * Configure the password age for 30 days
    * Do not allow password expiration time longer than required by policy
    * Enable password encyption
    * Enable password encryption
    * Configure the post-authentication actions to reset the password, logoff the managed account, and terminate any remaining processes after 8 hours

### Task 1: Prepare Active Directory for LAPS

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, extend the Active Directory schema.

    ````powershell
    Update-LapsADSchema
    ````

1. At the prompt The 'ms-LAPS-Password' schema attribute needs to be added to the AD schema, enter **a**.
1. Grant the managed device password update permission.

    ````powershell
    Set-LapsADComputerSelfPermission -Identity Devices
    ````

1. Query Extend Rights permission.

    ````powershell
    Find-LapsADExtendedRights -Identity Devices
    ````

    The property ExtendRightHolders should contain NT AUTHORITY\SYSTEM and AD\Domain Admins only.

### Task 2: Configure the policy for LAPS

Perform this task on CL1.

1. Open **Group Policy Management**.
1. In Group Policy Management, expand **Forest: ad.adatum.com**, **Domains**, **ad.adatum.com**, and click **Group Policy Objects**.
1. In the context-menu of **Group Policy Objects**, click **New**.
1. In New GPO, under **Name**, type **Custom Computer LAPS**.
1. In the context-menu of **Custom Computer LAPS**, click **Edit**.
1. In Group Policy Management Editor, expand **Computer Configuration**, **Policies**, **Administrative Templates**, **System** and click **LAPS**.
1. Under LAPS, double-click **Configure password backup directory**.
1. In Configure password backup directory, click **Enabled**. Beside **Backup directory**, click **Active Directory**. Click **OK**.
1. In **Group Policy Management Editor**, under **LAPS**, double-click **Configure automatic account management**.
1. In Configure automatic account management, click **Enabled**. Under **Specify the target account to manage**, click **Manage the build-in admin account**. Click to enable **Enable the managed account** and **Randomize the name of the managed account**. Click **OK**.
1. In **Group Policy Management Editor**, under **LAPS**, double-click **Password Settings**.
1. In Password Settings, click **Enabled**. Under **Password Complexity**, click **Large Letters + small letters + number + specials (improved readability)**. Beside **Password Length**, ensure **14** is filled in. Beside **Password Age (Days)**, ensure **30** is filled in. Click **OK**.
1. In **Group Policy Management Editor**, under **LAPS**, double-click **Do not allow password expiration time longer than required by policy**.
1. In Do not allow password expiration time longer than required by policy, click **Enabled** and click **OK**.
1. In **Group Policy Management Editor**, under **LAPS**, double-click **Enable password encryption**.
1. In Enable password encryption, click **Enabled** and click **OK**.

    By default, only Domain Admins can decrypt passwords. If you want to allow another group or user to decrypt passwords, you should configure the **Configure authorized password decryptors** setting. For this lab, leave it to the default.

1. In **Group Policy Management Editor**, under **LAPS**, double-click **Enable password backup for DSRM accounts**.
1. In Enable password backup for DSRM accounts, click **Enabled** and click **OK**.
1. In **Group Policy Management Editor**, under **LAPS**, double-click **Post-authentication actions**.
1. In Post-authentication actions, click **Enabled**. Beside **Grace period (hours)**, type **8**. Under **Actions**, click **Reset the password, logoff the managed account, and terminate any remaining processes**. Click **OK**.
1. Close **Group Policy Management Editor**.
1. In **Group Policy Management**, in the context-menu of **ad.adatum.com**, click **Link an Existing GPO...**
1. In Select GPO, click **Custom Computer LAPS** and click **OK**.

## Exercise 2: Use Local Administrator Password Solution

1. [Ensure configuration of LAPS](#task-1-ensure-configuration-of-laps) on CL2
1. [Retrieve local administrator password](#task-2-retrieve-local-administrator-password) for CL2
1. [Sign in using the local administrator](#task-3-sign-in-using-the-local-administrator) on CL2
1. [Rotate the local administrator password](#task-4-rotate-the-local-administrator-password) for CL2
1. [Verify password rotation](#task-5-verify-password-rotation) on CL2
1. [Reset the password locally](#task-6-reset-the-password-locally) on CL2

### Task 1: Ensure configuration of LAPS

Perform this task on CL2.

1. Open **Terminal** or **Windows PowerShell**.
1. In Terminal, force the update of group policies.

    ````powershell
    gpupdate.exe /force
    ````

1. Open **Event Viewer**.
1. In Event Viewer, expand **Applications and Services Logs**, **Microsoft**, **Windows**, **LAPS** and click **Operational**. Look for the latest event with the **Event Id** **10021**. The event text should read as follows:

    ````text
    The current LAPS policy is configured as follows:
 
    Policy source: GPO
    Backup directory: Active Directory
    Local administrator account name: 
    Password age in days: 30
    Password complexity: 5
    Password length: 14
    Password expiration protection enabled: 1
    Password encryption enabled: 1
    Password encryption target principal: 
    Password encrypted history size: 0
    Backup DSRM password on domain controllers: 1
    Post authentication grace period (hours): 8
    Post authentication actions: 0xB
    Automatic account management enabled: 1
    Automatic account management: Target: BuiltInAdminAccount
    Automatic account management: Name or name prefix: 
    Automatic account management: Account enabled: 1
    Automatic account management: Randomize name: 1
    ````

    If the settings differ, switch to **Terminal** and invoke the LAPS policy processing.

    ````powershell
    Invoke-LapsPolicyProcessing
    ````

    If the sttings still differ, go back to [Task 2: Configure the policy for LAPS](#task-2-configure-the-policy-for-laps).

    Look for the latest event with the **Event Id** **10009**. The event text should read as follows:

    ````text
    LAPS is configured to backup passwords to Active Directory.
    ````

    Look for the latest event with the **Event Id** **10018**. The event text should read as follows:

    ````text
    LAPS successfully updated Active Directory with the new password.
    ````

    Look for the latest event with the **Event Id** **10020**. The event text should read as follows (the account name and RID will be different):

    ````text
    LAPS successfully updated the local admin account with the new password.
 
    Account name: WLapsAdmin214842
    Account RID: 0x1F4
    ````

1. Sign out from CL2.

### Task 2: Retrieve local administrator password

#### Active Directory Users and Computers

Perform this task on CL1.

1. Open **Active Directory Users and Computers**.
1. In Active Directory Users and Computers, in the context-menu of **ad.adatum.com**, click **Find...**
1. In Find Users, Contacts, and Groups, beside **Find**, click **Computers**. Beside **Computer name**, type **CL2**. Click **Find Now**.
1. Double-click **CL2**.
1. In CL2 properties, click the tab **LAPS**.
1. On the tab LAPS, click **Show password**.

    Take a note of the **LAPS local admin account name** and **LAPS local admin account password** properties. You will need them in the next task.

#### Active Directory Administrative Center

Perform this task on CL1.

1. Open **Active Directory Administrative Center**.
1. In Active Directory Administrative Center, click **Global Search**.
1. In Global Search, in **Search**, type CL2 and click **Search**.
1. Double-click **CL2**.
1. In CL2, click the page **Extensions**.
1. Under Extensions, click the tab **LAPS**.
1. On the tab LAPS, click **Show password**.

    Take a note of the **LAPS local admin account name** and **LAPS local admin account password** properties. You will need them in the next task.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, retrieve the password for CL2 from Windows Server Active Directory.

    ````powershell
    Get-LapsADPassword -Identity CL2 -AsPlainText
    ````

    Take a note of the **Account** and **Password** properties. You will need them in the next task.

### Task 3: Sign in using the local administrator

Perform this task on CL2.

1. Sign in with the account and password, you noted in the previous task.

### Task 4: Rotate the local administrator password

#### Active Directory Users and Computers

Perform this task on CL1.

1. Open **Active Directory Users and Computers**.
1. In Active Directory Users and Computers, in the context-menu of **ad.adatum.com**, click **Find...**
1. In Find Users, Contacts, and Groups, beside **Find**, click **Computers**. Beside **Computer name**, type **CL2**. Click **Find Now**.
1. Double-click **CL2**.
1. In CL2 properties, click the tab **LAPS**.
1. On the tab LAPS, click **Expire now**.

#### Active Directory Administrative Center

Perform this task on CL1.

1. Open **Active Directory Administrative Center**.
1. In Active Directory Administrative Center, click **Global Search**.
1. In Global Search, in **Search**, type CL2 and click **Search**.
1. Double-click **CL2**.
1. In CL2, click the page **Extensions**.
1. Under Extensions, click the tab **LAPS**.
1. On the tab LAPS, click **Expire now**.

#### PowerShell

Perform this task on CL1.

1. Open **Terminal**.
1. In Terminal, set the password expiration time for CL2.

    ````powershell
    Set-LapsADPasswordExpirationTime -Identity CL2
    ````

    In real world, the password will change within the next 60 minutes. You will speed up the process in the next task.

### Task 5: Verify password rotation

Perform this task on CL2.

1. Open **Terminal** or **Windows PowerShell**.
1. In Terminal, invoke LAPS policy processing.

    ````powershell
    Invoke-LapsPolicyProcessing
    ````

1. Open **Event Viewer**.
1. In Event Viewer, expand **Applications and Services Logs**, **Microsoft**, **Windows**, **LAPS** and click **Operational**. Look for the latest event with the **Event Id** **10018**. The event text should read as follows:

    ````text
    LAPS successfully updated Active Directory with the new password.
    ````

    Look for the latest event with the **Event Id** **10020**. The event text should read as follows (the account name and RID will be different):

    ````text
    LAPS successfully updated the local admin account with the new password.
 
    Account name: WLapsAdmin285281
    Account RID: 0x1F4
    ````

### Task 6: Reset the password locally

Perform this task on CL2.

1. Open **Terminal** or **Windows PowerShell**.
1. In Terminal, invoke LAPS policy processing.

    ````powershell
    Reset-LapsPassword
    ````

1. Open **Event Viewer**.
1. In Event Viewer, expand **Applications and Services Logs**, **Microsoft**, **Windows**, **LAPS** and click **Operational**. Look for the latest event with the **Event Id** **10018**. The event text should read as follows:

    ````text
    LAPS successfully updated Active Directory with the new password.
    ````

    Look for the latest event with the **Event Id** **10020**. The event text should read as follows (the account name and RID will be different):

    ````text
    LAPS successfully updated the local admin account with the new password.
 
    Account name: WLapsAdmin399075
    Account RID: 0x1F4
    ````
