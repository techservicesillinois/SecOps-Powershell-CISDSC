Configuration CIS_Microsoft_Windows_10_Enterprise_Release_1809
{
    param
    (
        [Int32]$111Enforcepasswordhistory = 24,
        [Int32]$112MaximumPasswordAge = 60,
        [Int32]$113MinimumPasswordAge = 1,
        [Int32]$114MinimumPasswordLength = 14,
        [Int32]$121Accountlockoutduration = 15,
        [Int32]$122Accountlockoutthreshold = 10,
        [Int32]$123Resetaccountlockoutcounterafter = 15,
        [int32]$1825PasswordLength = 15,
        [int32]$1826PasswordAgeDays = 30,
        [string]$18410ScreenSaverGracePeriod = '5',
        [int32]$18413WarningLevel = 90,
        [int32]$18910212DeferFeatureUpdatesPeriodInDays = 180,
        [int32]$1892612MaxSize = 32768,
        [int32]$1892622MaxSize = 196608,
        [int32]$1892632MaxSize = 32768,
        [int32]$1892642MaxSize = 32768,
        [int32]$189593101MaxIdleTime = 900000,
        [String]$2315AccountsRenameadministratoraccount = 'CISADMIN',
        [String]$2316AccountsRenameguestaccount = 'CISGUEST',
        [int32]$2365MaximumPasswordAge = 30,
        [int32]$2373MaxDevicePasswordFailedAttempts = 10,
        [int32]$2374InactivityTimeoutSecs = 900,
        [string]$2375LegalNoticeText = 'ADD TEXT HERE',
        [string]$2376LegalNoticeCaption = 'ADD TEXT HERE',
        [string]$2377CachedLogonsCount = '4',
        [int32]$2378PasswordExpiryWarning = 14,
        [int32]$2391AutoDisconnect = 15,
        [int32]$916LogFileSize = 16384,
        [int32]$926LogFileSize = 16384,
        [int32]$938LogFileSize = 16384,
        [boolean]$BitLocker = $false,
        [string[]]$ExcludeList = @(),
        [boolean]$LevelOne = $true,
        [boolean]$LevelTwo = $false,
        [boolean]$NextGenerationWindowsSecurity = $false
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion '1.4.0.0'
    Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion '2.10.0.0'

    if($ExcludeList -notcontains '2.3.1.5' -and $PSBoundParameters.Keys -notcontains '2315AccountsRenameadministratoraccount'){
        throw 'Please add "2.3.1.5" to the ExcludeList or provide a value for "2315AccountsRenameadministratoraccount"'
    }
    if($ExcludeList -notcontains '2.3.1.6' -and $PSBoundParameters.Keys -notcontains '2316AccountsRenameguestaccount'){
        throw 'Please add "2.3.1.6" to the ExcludeList or provide a value for "2316AccountsRenameguestaccount"'
    }
    if($ExcludeList -notcontains '2.3.7.5' -and $PSBoundParameters.Keys -notcontains '2375LegalNoticeText'){
        throw 'Please add "2.3.7.5" to the ExcludeList or provide a value for "2375LegalNoticeText"'
    }
    if($ExcludeList -notcontains '2.3.7.6' -and $PSBoundParameters.Keys -notcontains '2376LegalNoticeCaption'){
        throw 'Please add "2.3.7.6" to the ExcludeList or provide a value for "2376LegalNoticeCaption"'
    }

    if($ExcludeList -notcontains '1.1.1' -and $LevelOne){
        AccountPolicy "(L1) Ensure Enforce password history is set to 24 or more password(s)"
        {
           Name = 'Enforce_password_history'
           Enforce_password_history = $111Enforcepasswordhistory
        }
    }
    if($ExcludeList -notcontains '1.1.2' -and $LevelOne){
        AccountPolicy "(L1) Ensure Maximum password age is set to 60 or fewer days but not 0"
        {
           Maximum_Password_Age = $112MaximumPasswordAge
           Name = 'Maximum_Password_Age'
        }
    }
    if($ExcludeList -notcontains '1.1.3' -and $LevelOne){
        AccountPolicy "(L1) Ensure Minimum password age is set to 1 or more day(s)"
        {
           Minimum_Password_Age = $113MinimumPasswordAge
           Name = 'Minimum_Password_Age'
        }
    }
    if($ExcludeList -notcontains '1.1.4' -and $LevelOne){
        AccountPolicy "(L1) Ensure Minimum password length is set to 14 or more character(s)"
        {
           Minimum_Password_Length = $114MinimumPasswordLength
           Name = 'Minimum_Password_Length'
        }
    }
    if($ExcludeList -notcontains '1.1.5' -and $LevelOne){
        AccountPolicy "(L1) Ensure Password must meet complexity requirements is set to Enabled"
        {
           Name = 'Password_must_meet_complexity_requirements'
           Password_must_meet_complexity_requirements = 'Enabled'
        }
    }
    if($ExcludeList -notcontains '1.1.6' -and $LevelOne){
        AccountPolicy "(L1) Ensure Store passwords using reversible encryption is set to Disabled"
        {
           Name = 'Store_passwords_using_reversible_encryption'
           Store_passwords_using_reversible_encryption = 'Disabled'
        }
    }
    if($ExcludeList -notcontains '1.2.1' -and $LevelOne){
        AccountPolicy "(L1) Ensure Account lockout duration is set to 15 or more minute(s)"
        {
           Name = 'Account_lockout_duration'
           Account_lockout_duration = $121Accountlockoutduration
        }
    }
    if($ExcludeList -notcontains '1.2.2' -and $LevelOne){
        AccountPolicy "(L1) Ensure Account lockout threshold is set to 10 or fewer invalid logon attempt(s) but not 0"
        {
           Account_lockout_threshold = $122Accountlockoutthreshold
           Name = 'Account_lockout_threshold'
        }
    }
    if($ExcludeList -notcontains '1.2.3' -and $LevelOne){
        AccountPolicy "(L1) Ensure Reset account lockout counter after is set to 15 or more minute(s)"
        {
           Reset_account_lockout_counter_after = $123Resetaccountlockoutcounterafter
           Name = 'Reset_account_lockout_counter_after'
        }
    }
    if($ExcludeList -notcontains '2.2.1' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Access Credential Manager as a trusted caller is set to No One"
        {
           Policy = 'Access_Credential_Manager_as_a_trusted_caller'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.2' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Access this computer from the network is set to Administrators Remote Desktop Users"
        {
           Policy = 'Access_this_computer_from_the_network'
           Force = $true
           Identity = @('*S-1-5-32-555','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.3' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Act as part of the operating system is set to No One"
        {
           Policy = 'Act_as_part_of_the_operating_system'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.4' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Adjust memory quotas for a process is set to Administrators LOCAL SERVICE NETWORK SERVICE"
        {
           Policy = 'Adjust_memory_quotas_for_a_process'
           Force = $true
           Identity = @('*S-1-5-20','*S-1-5-19','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.5' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Allow log on locally is set to Administrators Users"
        {
           Policy = 'Allow_log_on_locally'
           Force = $true
           Identity = @('*S-1-5-32-545','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.6' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Allow log on through Remote Desktop Services is set to Administrators Remote Desktop Users"
        {
           Policy = 'Allow_log_on_through_Remote_Desktop_Services'
           Force = $true
           Identity = @('*S-1-5-32-555','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.7' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Back up files and directories is set to Administrators"
        {
           Policy = 'Back_up_files_and_directories'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.8' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Change the system time is set to Administrators LOCAL SERVICE"
        {
           Policy = 'Change_the_system_time'
           Force = $true
           Identity = @('*S-1-5-19','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.9' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Change the time zone is set to Administrators LOCAL SERVICE Users"
        {
           Policy = 'Change_the_time_zone'
           Force = $true
           Identity = @('*S-1-5-32-545','*S-1-5-19','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.10' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Create a pagefile is set to Administrators"
        {
           Policy = 'Create_a_pagefile'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.11' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Create a token object is set to No One"
        {
           Policy = 'Create_a_token_object'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.12' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Create global objects is set to Administrators LOCAL SERVICE NETWORK SERVICE SERVICE"
        {
           Policy = 'Create_global_objects'
           Force = $true
           Identity = @('*S-1-5-6','*S-1-5-20','*S-1-5-19','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.13' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Create permanent shared objects is set to No One"
        {
           Policy = 'Create_permanent_shared_objects'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.14' -and $LevelOne){
        UserRightsAssignment "(L1) Configure Create symbolic links"
        {
           Policy = 'Create_symbolic_links'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.15' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Debug programs is set to Administrators"
        {
           Policy = 'Debug_programs'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.16' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Deny access to this computer from the network to include Guests Local account"
        {
           Policy = 'Deny_access_to_this_computer_from_the_network'
           Force = $true
           Identity = @('*S-1-5-113','*S-1-5-32-546')
        }
    }
    if($ExcludeList -notcontains '2.2.17' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Deny log on as a batch job to include Guests"
        {
           Policy = 'Deny_log_on_as_a_batch_job'
           Force = $true
           Identity = @('*S-1-5-32-546')
        }
    }
    if($ExcludeList -notcontains '2.2.18' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Deny log on as a service to include Guests"
        {
           Policy = 'Deny_log_on_as_a_service'
           Force = $true
           Identity = @('*S-1-5-32-546')
        }
    }
    if($ExcludeList -notcontains '2.2.19' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Deny log on locally to include Guests"
        {
           Policy = 'Deny_log_on_locally'
           Force = $true
           Identity = @('*S-1-5-32-546')
        }
    }
    if($ExcludeList -notcontains '2.2.20' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Deny log on through Remote Desktop Services to include Guests Local account"
        {
           Policy = 'Deny_log_on_through_Remote_Desktop_Services'
           Force = $true
           Identity = @('*S-1-5-113','*S-1-5-32-546')
        }
    }
    if($ExcludeList -notcontains '2.2.21' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Enable computer and user accounts to be trusted for delegation is set to No One"
        {
           Policy = 'Enable_computer_and_user_accounts_to_be_trusted_for_delegation'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.22' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Force shutdown from a remote system is set to Administrators"
        {
           Policy = 'Force_shutdown_from_a_remote_system'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.23' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Generate security audits is set to LOCAL SERVICE NETWORK SERVICE"
        {
           Policy = 'Generate_security_audits'
           Force = $true
           Identity = @('*S-1-5-20','*S-1-5-19')
        }
    }
    if($ExcludeList -notcontains '2.2.24' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Impersonate a client after authentication is set to Administrators LOCAL SERVICE NETWORK SERVICE SERVICE"
        {
           Policy = 'Impersonate_a_client_after_authentication'
           Force = $true
           Identity = @('*S-1-5-6','*S-1-5-20','*S-1-5-19','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.25' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Increase scheduling priority is set to Administrators Window ManagerWindow Manager Group"
        {
           Policy = 'Increase_scheduling_priority'
           Force = $true
           Identity = @('*S-1-5-90-0','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.26' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Load and unload device drivers is set to Administrators"
        {
           Policy = 'Load_and_unload_device_drivers'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.27' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Lock pages in memory is set to No One"
        {
           Policy = 'Lock_pages_in_memory'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.28' -and $LevelTwo){
        UserRightsAssignment "(L2) Ensure Log on as a batch job is set to Administrators"
        {
           Policy = 'Log_on_as_a_batch_job'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.29' -and $LevelTwo){
        UserRightsAssignment "(L2) Configure Log on as a service"
        {
           Policy = 'Log_on_as_a_service'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.30' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Manage auditing and security log is set to Administrators"
        {
           Policy = 'Manage_auditing_and_security_log'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.31' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Modify an object label is set to No One"
        {
           Policy = 'Modify_an_object_label'
           Force = $true
           Identity = @('')
        }
    }
    if($ExcludeList -notcontains '2.2.32' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Modify firmware environment values is set to Administrators"
        {
           Policy = 'Modify_firmware_environment_values'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.33' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Perform volume maintenance tasks is set to Administrators"
        {
           Policy = 'Perform_volume_maintenance_tasks'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.34' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Profile single process is set to Administrators"
        {
           Policy = 'Profile_single_process'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.35' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Profile system performance is set to Administrators NT SERVICEWdiServiceHost"
        {
           Policy = 'Profile_system_performance'
           Force = $true
           Identity = @('*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.36' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Replace a process level token is set to LOCAL SERVICE NETWORK SERVICE"
        {
           Policy = 'Replace_a_process_level_token'
           Force = $true
           Identity = @('*S-1-5-20','*S-1-5-19')
        }
    }
    if($ExcludeList -notcontains '2.2.37' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Restore files and directories is set to Administrators"
        {
           Policy = 'Restore_files_and_directories'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.38' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Shut down the system is set to Administrators Users"
        {
           Policy = 'Shut_down_the_system'
           Force = $true
           Identity = @('*S-1-5-32-545','*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.2.39' -and $LevelOne){
        UserRightsAssignment "(L1) Ensure Take ownership of files or other objects is set to Administrators"
        {
           Policy = 'Take_ownership_of_files_or_other_objects'
           Force = $true
           Identity = @('*S-1-5-32-544')
        }
    }
    if($ExcludeList -notcontains '2.3.1.1' -and $LevelOne){
        SecurityOption "(L1) Ensure Accounts Administrator account status is set to Disabled"
        {
           Accounts_Administrator_account_status = 'Disabled'
           Name = 'Accounts_Administrator_account_status'
        }
    }
    if($ExcludeList -notcontains '2.3.1.2' -and $LevelOne){
        Registry "(L1) Ensure Accounts Block Microsoft accounts is set to Users cant add or log on with Microsoft accounts"
        {
           ValueName = 'NoConnectedUser'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 3
        }
    }
    if($ExcludeList -notcontains '2.3.1.3' -and $LevelOne){
        SecurityOption "(L1) Ensure Accounts Guest account status is set to Disabled"
        {
           Name = 'Accounts_Guest_account_status'
           Accounts_Guest_account_status = 'Disabled'
        }
    }
    if($ExcludeList -notcontains '2.3.1.4' -and $LevelOne){
        Registry "(L1) Ensure Accounts Limit local account use of blank passwords to console logon only is set to Enabled"
        {
           ValueName = 'LimitBlankPasswordUse'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.1.5' -and $LevelOne){
        SecurityOption "(L1) Configure Accounts Rename administrator account"
        {
           Name = 'Accounts_Rename_administrator_account'
           Accounts_Rename_administrator_account = $2315AccountsRenameadministratoraccount
        }
    }
    if($ExcludeList -notcontains '2.3.1.6' -and $LevelOne){
        SecurityOption "(L1) Configure Accounts Rename guest account"
        {
           Accounts_Rename_guest_account = $2316AccountsRenameguestaccount
           Name = 'Accounts_Rename_guest_account'
        }
    }
    if($ExcludeList -notcontains '2.3.2.1' -and $LevelOne){
        Registry "(L1) Ensure Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings is set to Enabled"
        {
           ValueName = 'SCENoApplyLegacyAuditPolicy'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.2.2' -and $LevelOne){
        Registry "(L1) Ensure Audit Shut down system immediately if unable to log security audits is set to Disabled"
        {
           ValueName = 'CrashOnAuditFail'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.4.1' -and $LevelOne){
        Registry "(L1) Ensure Devices Allowed to format and eject removable media is set to Administrators and Interactive Users"
        {
           ValueName = 'AllocateDASD'
           ValueType = 'String'
           Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
           ValueData = "2"
        }
    }
    if($ExcludeList -notcontains '2.3.4.2' -and $LevelTwo){
        Registry "(L2) Ensure Devices Prevent users from installing printer drivers is set to Enabled"
        {
           ValueName = 'AddPrinterDrivers'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.6.1' -and $LevelOne){
        Registry "(L1) Ensure Domain member Digitally encrypt or sign secure channel data (always) is set to Enabled"
        {
           ValueName = 'RequireSignOrSeal'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.6.2' -and $LevelOne){
        Registry "(L1) Ensure Domain member Digitally encrypt secure channel data (when possible) is set to Enabled"
        {
           ValueName = 'SealSecureChannel'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.6.3' -and $LevelOne){
        Registry "(L1) Ensure Domain member Digitally sign secure channel data (when possible) is set to Enabled"
        {
           ValueName = 'SignSecureChannel'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.6.4' -and $LevelOne){
        Registry "(L1) Ensure Domain member Disable machine account password changes is set to Disabled"
        {
           ValueName = 'DisablePasswordChange'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.6.5' -and $LevelOne){
        Registry "(L1) Ensure Domain member Maximum machine account password age is set to 30 or fewer days but not 0"
        {
           ValueName = 'MaximumPasswordAge'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
           ValueData = $2365MaximumPasswordAge
        }
    }
    if($ExcludeList -notcontains '2.3.6.6' -and $LevelOne){
        Registry "(L1) Ensure Domain member Require strong (Windows 2000 or later) session key is set to Enabled"
        {
           ValueName = 'RequireStrongKey'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.7.1' -and $LevelOne){
        Registry "(L1) Ensure Interactive logon Do not require CTRLALTDEL is set to Disabled"
        {
           ValueName = 'DisableCAD'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.7.2' -and $LevelOne){
        Registry "(L1) Ensure Interactive logon Dont display last signedin is set to Enabled"
        {
           ValueName = 'DontDisplayLastUserName'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.7.3' -and $BitLocker){
        Registry "(BL) Ensure Interactive logon Machine account lockout threshold is set to 10 or fewer invalid logon attempts but not 0"
        {
           ValueName = 'MaxDevicePasswordFailedAttempts'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = $2373MaxDevicePasswordFailedAttempts
        }
    }
    if($ExcludeList -notcontains '2.3.7.4' -and $LevelOne){
        Registry "(L1) Ensure Interactive logon Machine inactivity limit is set to 900 or fewer second(s) but not 0"
        {
           ValueName = 'InactivityTimeoutSecs'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = $2374InactivityTimeoutSecs
        }
    }
    if($ExcludeList -notcontains '2.3.7.5' -and $LevelOne){
        Registry "(L1) Configure Interactive logon Message text for users attempting to log on"
        {
           ValueName = 'LegalNoticeText'
           ValueType = 'String'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = $2375LegalNoticeText
        }
    }
    if($ExcludeList -notcontains '2.3.7.6' -and $LevelOne){
        Registry "(L1) Configure Interactive logon Message title for users attempting to log on"
        {
           ValueName = 'LegalNoticeCaption'
           ValueType = 'String'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = $2376LegalNoticeCaption
        }
    }
    if($ExcludeList -notcontains '2.3.7.7' -and $LevelTwo){
        Registry "(L2) Ensure Interactive logon Number of previous logons to cache (in case domain controller is not available) is set to 4 or fewer logon(s)"
        {
           ValueName = 'CachedLogonsCount'
           ValueType = 'String'
           Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
           ValueData = $2377CachedLogonsCount
        }
    }
    if($ExcludeList -notcontains '2.3.7.8' -and $LevelOne){
        Registry "(L1) Ensure Interactive logon Prompt user to change password before expiration is set to between 5 and 14 days"
        {
           ValueName = 'PasswordExpiryWarning'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
           ValueData = $2378PasswordExpiryWarning
        }
    }
    if($ExcludeList -notcontains '2.3.7.9' -and $LevelOne){
        Registry "(L1) Ensure Interactive logon Smart card removal behavior is set to Lock Workstation or higher"
        {
           ValueName = 'ScRemoveOption'
           ValueType = 'String'
           Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
           ValueData = "1"
        }
    }
    if($ExcludeList -notcontains '2.3.8.1' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network client Digitally sign communications (always) is set to Enabled"
        {
           ValueName = 'RequireSecuritySignature'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.8.2' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network client Digitally sign communications (if server agrees) is set to Enabled"
        {
           ValueName = 'EnableSecuritySignature'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.8.3' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network client Send unencrypted password to thirdparty SMB servers is set to Disabled"
        {
           ValueName = 'EnablePlainTextPassword'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.9.1' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network server Amount of idle time required before suspending session is set to 15 or fewer minute(s)"
        {
           ValueName = 'AutoDisconnect'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = $2391AutoDisconnect
        }
    }
    if($ExcludeList -notcontains '2.3.9.2' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network server Digitally sign communications (always) is set to Enabled"
        {
           ValueName = 'RequireSecuritySignature'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.9.3' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network server Digitally sign communications (if client agrees) is set to Enabled"
        {
           ValueName = 'EnableSecuritySignature'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.9.4' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network server Disconnect clients when logon hours expire is set to Enabled"
        {
           ValueName = 'EnableForcedLogOff'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.9.5' -and $LevelOne){
        Registry "(L1) Ensure Microsoft network server Server SPN target name validation level is set to Accept if provided by client or higher"
        {
           ValueName = 'SmbServerNameHardeningLevel'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.10.1' -and $LevelOne){
        SecurityOption "(L1) Ensure Network access Allow anonymous SIDName translation is set to Disabled"
        {
           Network_access_Allow_anonymous_SID_Name_translation = 'Disabled'
           Name = 'Network_access_Allow_anonymous_SID_Name_translation'
        }
    }
    if($ExcludeList -notcontains '2.3.10.2' -and $LevelOne){
        Registry "(L1) Ensure Network access Do not allow anonymous enumeration of SAM accounts is set to Enabled"
        {
           ValueName = 'RestrictAnonymousSAM'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.10.3' -and $LevelOne){
        Registry "(L1) Ensure Network access Do not allow anonymous enumeration of SAM accounts and shares is set to Enabled"
        {
           ValueName = 'RestrictAnonymous'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.10.4' -and $LevelOne){
        Registry "(L1) Ensure Network access Do not allow storage of passwords and credentials for network authentication is set to Enabled"
        {
           ValueName = 'DisableDomainCreds'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.10.5' -and $LevelOne){
        Registry "(L1) Ensure Network access Let Everyone permissions apply to anonymous users is set to Disabled"
        {
           ValueName = 'EveryoneIncludesAnonymous'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.10.6' -and $LevelOne){
        Registry "(L1) Ensure Network access Named Pipes that can be accessed anonymously is set to None"
        {
           ValueName = 'NullSessionPipes'
           ValueType = 'MultiString'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = @('')
        }
    }
    if($ExcludeList -notcontains '2.3.10.7' -and $LevelOne){
        Registry "(L1) Ensure Network access Remotely accessible registry paths"
        {
           ValueName = 'Machine'
           ValueType = 'MultiString'
           Key = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths'
           ValueData = @('System\CurrentControlSet\Control\ProductOptions','System\CurrentControlSet\Control\Server Applications','Software\Microsoft\Windows NT\CurrentVersion')
        }
    }
    if($ExcludeList -notcontains '2.3.10.8' -and $LevelOne){
        Registry "(L1) Ensure Network access Remotely accessible registry paths and subpaths"
        {
           ValueName = 'Machine'
           ValueType = 'MultiString'
           Key = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths'
           ValueData = @('Software\Microsoft\Windows NT\CurrentVersion\Print','Software\Microsoft\Windows NT\CurrentVersion\Windows','System\CurrentControlSet\Control\Print\Printers','System\CurrentControlSet\Services\Eventlog','Software\Microsoft\OLAP Server','System\CurrentControlSet\Control\ContentIndex','System\CurrentControlSet\Control\Terminal Server','System\CurrentControlSet\Control\Terminal Server\UserConfig','System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration','Software\Microsoft\Windows NT\CurrentVersion\Perflib','System\CurrentControlSet\Services\SysmonLog')
        }
    }
    if($ExcludeList -notcontains '2.3.10.9' -and $LevelOne){
        Registry "(L1) Ensure Network access Restrict anonymous access to Named Pipes and Shares is set to Enabled"
        {
           ValueName = 'RestrictNullSessAccess'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.10.10' -and $LevelOne){
        Registry "(L1) Ensure Network access Restrict clients allowed to make remote calls to SAM is set to Administrators Remote Access Allow"
        {
           ValueName = 'RestrictRemoteSAM'
           ValueType = 'String'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = "O:BAG:BAD:(A;;RC;;;BA)"
        }
    }
    if($ExcludeList -notcontains '2.3.10.11' -and $LevelOne){
        Registry "(L1) Ensure Network access Shares that can be accessed anonymously is set to None"
        {
           ValueName = 'NullSessionShares'
           ValueType = 'MultiString'
           Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
           ValueData = @('')
        }
    }
    if($ExcludeList -notcontains '2.3.10.12' -and $LevelOne){
        Registry "(L1) Ensure Network access Sharing and security model for local accounts is set to Classic  local users authenticate as themselves"
        {
           ValueName = 'ForceGuest'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.11.1' -and $LevelOne){
        Registry "(L1) Ensure Network security Allow Local System to use computer identity for NTLM is set to Enabled"
        {
           ValueName = 'UseMachineId'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.11.2' -and $LevelOne){
        Registry "(L1) Ensure Network security Allow LocalSystem NULL session fallback is set to Disabled"
        {
           ValueName = 'allownullsessionfallback'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.11.3' -and $LevelOne){
        Registry "(L1) Ensure Network Security Allow PKU2U authentication requests to this computer to use online identities is set to Disabled"
        {
           ValueName = 'AllowOnlineID'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\pku2u'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.11.4' -and $LevelOne){
        Registry "(L1) Ensure Network security Configure encryption types allowed for Kerberos is set to AES128HMACSHA1 AES256HMACSHA1 Future encryption types"
        {
           ValueName = 'SupportedEncryptionTypes'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
           ValueData = 2147483640
        }
    }
    if($ExcludeList -notcontains '2.3.11.5' -and $LevelOne){
        Registry "(L1) Ensure Network security Do not store LAN Manager hash value on next password change is set to Enabled"
        {
           ValueName = 'NoLMHash'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.11.6' -and $LevelOne){
        SecurityOption "(L1) Ensure Network security Force logoff when logon hours expire is set to Enabled"
        {
           Name = 'Network_security_Force_logoff_when_logon_hours_expire'
           Network_security_Force_logoff_when_logon_hours_expire = 'Enabled'
        }
    }
    if($ExcludeList -notcontains '2.3.11.7' -and $LevelOne){
        Registry "(L1) Ensure Network security LAN Manager authentication level is set to Send NTLMv2 response only Refuse LM  NTLM"
        {
           ValueName = 'LmCompatibilityLevel'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
           ValueData = 5
        }
    }
    if($ExcludeList -notcontains '2.3.11.8' -and $LevelOne){
        Registry "(L1) Ensure Network security LDAP client signing requirements is set to Negotiate signing or higher"
        {
           ValueName = 'LDAPClientIntegrity'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Services\LDAP'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.11.9' -and $LevelOne){
        Registry "(L1) Ensure Network security Minimum session security for NTLM SSP based (including secure RPC) clients is set to Require NTLMv2 session security Require 128bit encryption"
        {
           ValueName = 'NTLMMinClientSec'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
           ValueData = 537395200
        }
    }
    if($ExcludeList -notcontains '2.3.11.10' -and $LevelOne){
        Registry "(L1) Ensure Network security Minimum session security for NTLM SSP based (including secure RPC) servers is set to Require NTLMv2 session security Require 128bit encryption"
        {
           ValueName = 'NTLMMinServerSec'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
           ValueData = 537395200
        }
    }
    if($ExcludeList -notcontains '2.3.14.1' -and $LevelTwo){
        Registry "(L2) Ensure System cryptography Force strong key protection for user keys stored on the computer is set to User is prompted when the key is first used or higher"
        {
           ValueName = 'ForceKeyProtection'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Cryptography'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.15.1' -and $LevelOne){
        Registry "(L1) Ensure System objects Require case insensitivity for nonWindows subsystems is set to Enabled"
        {
           ValueName = 'ObCaseInsensitive'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.15.2' -and $LevelOne){
        Registry "(L1) Ensure System objects Strengthen default permissions of internal system objects (eg Symbolic Links) is set to Enabled"
        {
           ValueName = 'ProtectionMode'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Control\Session Manager'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.17.1' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Admin Approval Mode for the Builtin Administrator account is set to Enabled"
        {
           ValueName = 'FilterAdministratorToken'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.17.2' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Behavior of the elevation prompt for administrators in Admin Approval Mode is set to Prompt for consent on the secure desktop"
        {
           ValueName = 'ConsentPromptBehaviorAdmin'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 2
        }
    }
    if($ExcludeList -notcontains '2.3.17.3' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Behavior of the elevation prompt for standard users is set to Automatically deny elevation requests"
        {
           ValueName = 'ConsentPromptBehaviorUser'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 0
        }
    }
    if($ExcludeList -notcontains '2.3.17.4' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Detect application installations and prompt for elevation is set to Enabled"
        {
           ValueName = 'EnableInstallerDetection'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.17.5' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Only elevate UIAccess applications that are installed in secure locations is set to Enabled"
        {
           ValueName = 'EnableSecureUIAPaths'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.17.6' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Run all administrators in Admin Approval Mode is set to Enabled"
        {
           ValueName = 'EnableLUA'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.17.7' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Switch to the secure desktop when prompting for elevation is set to Enabled"
        {
           ValueName = 'PromptOnSecureDesktop'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '2.3.17.8' -and $LevelOne){
        Registry "(L1) Ensure User Account Control Virtualize file and registry write failures to peruser locations is set to Enabled"
        {
           ValueName = 'EnableVirtualization'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
           ValueData = 1
        }
    }
    if($ExcludeList -notcontains '5.1' -and $LevelTwo){
        Service "(L2) Ensure Bluetooth Audio Gateway Service (BTAGService) is set to Disabled"
        {
           Name = 'BTAGService'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.2' -and $LevelTwo){
        Service "(L2) Ensure Bluetooth Support Service (bthserv) is set to Disabled"
        {
           Name = 'bthserv'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.3' -and $LevelOne){
        Service "(L1) Ensure Computer Browser (Browser) is set to Disabled or Not Installed"
        {
           Name = 'Browser'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.4' -and $LevelTwo){
        Service "(L2) Ensure Downloaded Maps Manager (MapsBroker) is set to Disabled"
        {
           Name = 'MapsBroker'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.5' -and $LevelTwo){
        Service "(L2) Ensure Geolocation Service (lfsvc) is set to Disabled"
        {
           Name = 'lfsvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.6' -and $LevelOne){
        Service "(L1) Ensure IIS Admin Service (IISADMIN) is set to Disabled or Not Installed"
        {
           Name = 'IISADMIN'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.7' -and $LevelOne){
        Service "(L1) Ensure Infrared monitor service (irmon) is set to Disabled"
        {
           Name = 'irmon'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.8' -and $LevelOne){
        Service "(L1) Ensure Internet Connection Sharing (ICS) (SharedAccess) is set to Disabled"
        {
           Name = 'SharedAccess'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.9' -and $LevelTwo){
        Service "(L2) Ensure LinkLayer Topology Discovery Mapper (lltdsvc) is set to Disabled"
        {
           Name = 'lltdsvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.10' -and $LevelOne){
        Service "(L1) Ensure LxssManager (LxssManager) is set to Disabled or Not Installed"
        {
           Name = 'LxssManager'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.11' -and $LevelOne){
        Service "(L1) Ensure Microsoft FTP Service (FTPSVC) is set to Disabled or Not Installed"
        {
           Name = 'ftpsvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.12' -and $LevelTwo){
        Service "(L2) Ensure Microsoft iSCSI Initiator Service (MSiSCSI) is set to Disabled"
        {
           Name = 'MSiSCSI'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.13' -and $LevelTwo){
        Service "(L2) Ensure Microsoft Store Install Service (InstallService) is set to Disabled"
        {
           Name = 'InstallService'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.14' -and $LevelOne){
        Service "(L1) Ensure OpenSSH SSH Server (sshd) is set to Disabled or Not Installed"
        {
           Name = 'sshd'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.15' -and $LevelTwo){
        Service "(L2) Ensure Peer Name Resolution Protocol (PNRPsvc) is set to Disabled"
        {
           Name = 'PNRPsvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.16' -and $LevelTwo){
        Service "(L2) Ensure Peer Networking Grouping (p2psvc) is set to Disabled"
        {
           Name = 'p2psvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.17' -and $LevelTwo){
        Service "(L2) Ensure Peer Networking Identity Manager (p2pimsvc) is set to Disabled"
        {
           Name = 'p2pimsvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.18' -and $LevelTwo){
        Service "(L2) Ensure PNRP Machine Name Publication Service (PNRPAutoReg) is set to Disabled"
        {
           Name = 'PNRPAutoReg'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.19' -and $LevelTwo){
        Service "(L2) Ensure Problem Reports and Solutions Control Panel Support (wercplsupport) is set to Disabled"
        {
           Name = 'wercplsupport'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.20' -and $LevelTwo){
        Service "(L2) Ensure Remote Access Auto Connection Manager (RasAuto) is set to Disabled"
        {
           Name = 'RasAuto'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.21' -and $LevelTwo){
        Service "(L2) Ensure Remote Desktop Configuration (SessionEnv) is set to Disabled"
        {
           Name = 'SessionEnv'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.22' -and $LevelTwo){
        Service "(L2) Ensure Remote Desktop Services (TermService) is set to Disabled"
        {
           Name = 'TermService'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.23' -and $LevelTwo){
        Service "(L2) Ensure Remote Desktop Services UserMode Port Redirector (UmRdpService) is set to Disabled"
        {
           Name = 'UmRdpService'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.24' -and $LevelOne){
        Service "(L1) Ensure Remote Procedure Call (RPC) Locator (RpcLocator) is set to Disabled"
        {
           Name = 'RpcLocator'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.25' -and $LevelTwo){
        Service "(L2) Ensure Remote Registry (RemoteRegistry) is set to Disabled"
        {
           Name = 'RemoteRegistry'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.26' -and $LevelOne){
        Service "(L1) Ensure Routing and Remote Access (RemoteAccess) is set to Disabled"
        {
           Name = 'RemoteAccess'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.27' -and $LevelTwo){
        Service "(L2) Ensure Server (LanmanServer) is set to Disabled"
        {
           Name = 'LanmanServer'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.28' -and $LevelOne){
        Service "(L1) Ensure Simple TCPIP Services (simptcp) is set to Disabled or Not Installed"
        {
           Name = 'simptcp'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.29' -and $LevelTwo){
        Service "(L2) Ensure SNMP Service (SNMP) is set to Disabled or Not Installed"
        {
           Name = 'SNMP'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.30' -and $LevelOne){
        Service "(L1) Ensure SSDP Discovery (SSDPSRV) is set to Disabled"
        {
           Name = 'SSDPSRV'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.31' -and $LevelOne){
        Service "(L1) Ensure UPnP Device Host (upnphost) is set to Disabled"
        {
           Name = 'upnphost'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.32' -and $LevelOne){
        Service "(L1) Ensure Web Management Service (WMSvc) is set to Disabled or Not Installed"
        {
           Name = 'WMSVC'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.33' -and $LevelTwo){
        Service "(L2) Ensure Windows Error Reporting Service (WerSvc) is set to Disabled"
        {
           Name = 'WerSvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.34' -and $LevelTwo){
        Service "(L2) Ensure Windows Event Collector (Wecsvc) is set to Disabled"
        {
           Name = 'Wecsvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.35' -and $LevelOne){
        Service "(L1) Ensure Windows Media Player Network Sharing Service (WMPNetworkSvc) is set to Disabled or Not Installed"
        {
           Name = 'WMPNetworkSvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.36' -and $LevelOne){
        Service "(L1) Ensure Windows Mobile Hotspot Service (icssvc) is set to Disabled"
        {
           Name = 'icssvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.37' -and $LevelTwo){
        Service "(L2) Ensure Windows Push Notifications System Service (WpnService) is set to Disabled"
        {
           Name = 'WpnService'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.38' -and $LevelTwo){
        Service "(L2) Ensure Windows PushToInstall Service (PushToInstall) is set to Disabled"
        {
           Name = 'PushToInstall'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.39' -and $LevelTwo){
        Service "(L2) Ensure Windows Remote Management (WSManagement) (WinRM) is set to Disabled"
        {
           Name = 'WinRM'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.40' -and $LevelOne){
        Service "(L1) Ensure World Wide Web Publishing Service (W3SVC) is set to Disabled or Not Installed"
        {
           Name = 'W3SVC'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.41' -and $LevelOne){
        Service "(L1) Ensure Xbox Accessory Management Service (XboxGipSvc) is set to Disabled"
        {
           Name = 'XboxGipSvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.42' -and $LevelOne){
        Service "(L1) Ensure Xbox Live Auth Manager (XblAuthManager) is set to Disabled"
        {
           Name = 'XblAuthManager'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.43' -and $LevelOne){
        Service "(L1) Ensure Xbox Live Game Save (XblGameSave) is set to Disabled"
        {
           Name = 'XblGameSave'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '5.44' -and $LevelOne){
        Service "(L1) Ensure Xbox Live Networking Service (XboxNetApiSvc) is set to Disabled"
        {
           Name = 'XboxNetApiSvc'
           State = 'Stopped'
        }
    }
    if($ExcludeList -notcontains '9.1.1' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Firewall state is set to On (recommended)"
        {
           ValueName = 'EnableFirewall'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        }
    }
    if($ExcludeList -notcontains '9.1.2' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Inbound connections is set to Block (default)"
        {
           ValueName = 'DefaultInboundAction'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        }
    }
    if($ExcludeList -notcontains '9.1.3' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Outbound connections is set to Allow (default)"
        {
           ValueName = 'DefaultOutboundAction'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        }
    }
    if($ExcludeList -notcontains '9.1.4' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Settings Display a notification is set to No"
        {
           ValueName = 'DisableNotifications'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile'
        }
    }
    if($ExcludeList -notcontains '9.1.5' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Logging Name is set to SystemRootSystem32logfilesfirewalldomainfwlog"
        {
           ValueName = 'LogFilePath'
           ValueData = '%systemroot%\system32\logfiles\firewall\domainfw.log'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.1.6' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Logging Size limit (KB) is set to 16384 KB or greater"
        {
           ValueName = 'LogFileSize'
           ValueData = $916LogFileSize
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.1.7' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Logging Log dropped packets is set to Yes"
        {
           ValueName = 'LogDroppedPackets'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.1.8' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Domain Logging Log successful connections is set to Yes"
        {
           ValueName = 'LogSuccessfulConnections'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.2.1' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Firewall state is set to On (recommended)"
        {
           ValueName = 'EnableFirewall'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        }
    }
    if($ExcludeList -notcontains '9.2.2' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Inbound connections is set to Block (default)"
        {
           ValueName = 'DefaultInboundAction'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        }
    }
    if($ExcludeList -notcontains '9.2.3' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Outbound connections is set to Allow (default)"
        {
           ValueName = 'DefaultOutboundAction'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        }
    }
    if($ExcludeList -notcontains '9.2.4' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Settings Display a notification is set to No"
        {
           ValueName = 'DisableNotifications'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile'
        }
    }
    if($ExcludeList -notcontains '9.2.5' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Logging Name is set to SystemRootSystem32logfilesfirewallprivatefwlog"
        {
           ValueName = 'LogFilePath'
           ValueData = '%systemroot%\system32\logfiles\firewall\privatefw.log'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.2.6' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Logging Size limit (KB) is set to 16384 KB or greater"
        {
           ValueName = 'LogFileSize'
           ValueData = $926LogFileSize
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.2.7' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Logging Log dropped packets is set to Yes"
        {
           ValueName = 'LogDroppedPackets'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.2.8' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Private Logging Log successful connections is set to Yes"
        {
           ValueName = 'LogSuccessfulConnections'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.3.1' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Firewall state is set to On (recommended)"
        {
           ValueName = 'EnableFirewall'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        }
    }
    if($ExcludeList -notcontains '9.3.2' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Inbound connections is set to Block (default)"
        {
           ValueName = 'DefaultInboundAction'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        }
    }
    if($ExcludeList -notcontains '9.3.3' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Outbound connections is set to Allow (default)"
        {
           ValueName = 'DefaultOutboundAction'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        }
    }
    if($ExcludeList -notcontains '9.3.4' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Settings Display a notification is set to No"
        {
           ValueName = 'DisableNotifications'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        }
    }
    if($ExcludeList -notcontains '9.3.5' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Settings Apply local firewall rules is set to No"
        {
           ValueName = 'AllowLocalPolicyMerge'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        }
    }
    if($ExcludeList -notcontains '9.3.6' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Settings Apply local connection security rules is set to No"
        {
           ValueName = 'AllowLocalIPsecPolicyMerge'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile'
        }
    }
    if($ExcludeList -notcontains '9.3.7' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Logging Name is set to SystemRootSystem32logfilesfirewallpublicfwlog"
        {
           ValueName = 'LogFilePath'
           ValueData = '%systemroot%\system32\logfiles\firewall\publicfw.log'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.3.8' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Logging Size limit (KB) is set to 16384 KB or greater"
        {
           ValueName = 'LogFileSize'
           ValueData = $938LogFileSize
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.3.9' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Logging Log dropped packets is set to Yes"
        {
           ValueName = 'LogDroppedPackets'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '9.3.10' -and $LevelOne){
        Registry "(L1) Ensure Windows Firewall Public Logging Log successful connections is set to Yes"
        {
           ValueName = 'LogSuccessfulConnections'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
        }
    }
    if($ExcludeList -notcontains '17.1.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Credential Validation is set to Success and Failure"
        {
           Name = 'Credential Validation'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.1.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Credential Validation is set to Success and Failure (2)"
        {
           Name = 'Credential Validation'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.2.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Application Group Management is set to Success and Failure"
        {
           Name = 'Application Group Management'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.2.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Application Group Management is set to Success and Failure (2)"
        {
           Name = 'Application Group Management'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.2.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Security Group Management is set to include Success (2)"
        {
           Name = 'Security Group Management'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.2.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Security Group Management is set to include Success"
        {
           Name = 'Security Group Management'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.2.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit User Account Management is set to Success and Failure (2)"
        {
           Name = 'User Account Management'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.2.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit User Account Management is set to Success and Failure"
        {
           Name = 'User Account Management'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.3.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit PNP Activity is set to include Success"
        {
           Name = 'Plug and Play Events'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.3.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit PNP Activity is set to include Success (2)"
        {
           Name = 'Plug and Play Events'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.3.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Process Creation is set to include Success (2)"
        {
           Name = 'Process Creation'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.3.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Process Creation is set to include Success"
        {
           Name = 'Process Creation'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.5.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Account Lockout is set to include Failure"
        {
           Name = 'Account Lockout'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.5.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Account Lockout is set to include Failure (2)"
        {
           Name = 'Account Lockout'
           Ensure = 'Absent'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.5.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Group Membership is set to include Success"
        {
           Name = 'Group Membership'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.5.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Group Membership is set to include Success (2)"
        {
           Name = 'Group Membership'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.5.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Logoff is set to include Success (2)"
        {
           Name = 'Logoff'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.5.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Logoff is set to include Success"
        {
           Name = 'Logoff'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.5.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Logon is set to Success and Failure (2)"
        {
           Name = 'Logon'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.5.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Logon is set to Success and Failure"
        {
           Name = 'Logon'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.5.5' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other LogonLogoff Events is set to Success and Failure"
        {
           Name = 'Other Logon/Logoff Events'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.5.5' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other LogonLogoff Events is set to Success and Failure (2)"
        {
           Name = 'Other Logon/Logoff Events'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.5.6' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Special Logon is set to include Success (2)"
        {
           Name = 'Special Logon'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.5.6' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Special Logon is set to include Success"
        {
           Name = 'Special Logon'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.6.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Detailed File Share is set to include Failure (2)"
        {
           Name = 'Detailed File Share'
           Ensure = 'Absent'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.6.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Detailed File Share is set to include Failure"
        {
           Name = 'Detailed File Share'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.6.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit File Share is set to Success and Failure (2)"
        {
           Name = 'File Share'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.6.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit File Share is set to Success and Failure"
        {
           Name = 'File Share'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.6.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other Object Access Events is set to Success and Failure (2)"
        {
           Name = 'Other Object Access Events'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.6.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other Object Access Events is set to Success and Failure"
        {
           Name = 'Other Object Access Events'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.6.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Removable Storage is set to Success and Failure (2)"
        {
           Name = 'Removable Storage'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.6.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Removable Storage is set to Success and Failure"
        {
           Name = 'Removable Storage'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.7.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Audit Policy Change is set to include Success (2)"
        {
           Name = 'Audit Policy Change'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.7.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Audit Policy Change is set to include Success"
        {
           Name = 'Audit Policy Change'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.7.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Authentication Policy Change is set to include Success (2)"
        {
           Name = 'Authentication Policy Change'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.7.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Authentication Policy Change is set to include Success"
        {
           Name = 'Authentication Policy Change'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.7.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Authorization Policy Change is set to include Success (2)"
        {
           Name = 'Authorization Policy Change'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.7.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Authorization Policy Change is set to include Success"
        {
           Name = 'Authorization Policy Change'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.7.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit MPSSVC RuleLevel Policy Change is set to Success and Failure (2)"
        {
           Name = 'MPSSVC Rule-Level Policy Change'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.7.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit MPSSVC RuleLevel Policy Change is set to Success and Failure"
        {
           Name = 'MPSSVC Rule-Level Policy Change'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.7.5' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other Policy Change Events is set to include Failure"
        {
           Name = 'Other Policy Change Events'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.7.5' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other Policy Change Events is set to include Failure (2)"
        {
           Name = 'Other Policy Change Events'
           Ensure = 'Absent'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.8.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Sensitive Privilege Use is set to Success and Failure (2)"
        {
           Name = 'Sensitive Privilege Use'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.8.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Sensitive Privilege Use is set to Success and Failure"
        {
           Name = 'Sensitive Privilege Use'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.9.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit IPsec Driver is set to Success and Failure (2)"
        {
           Name = 'IPsec Driver'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.9.1' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit IPsec Driver is set to Success and Failure"
        {
           Name = 'IPsec Driver'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.9.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other System Events is set to Success and Failure (2)"
        {
           Name = 'Other System Events'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.9.2' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Other System Events is set to Success and Failure"
        {
           Name = 'Other System Events'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.9.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Security State Change is set to include Success (2)"
        {
           Name = 'Security State Change'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.9.3' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Security State Change is set to include Success"
        {
           Name = 'Security State Change'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.9.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Security System Extension is set to include Success (2)"
        {
           Name = 'Security System Extension'
           Ensure = 'Absent'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.9.4' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit Security System Extension is set to include Success"
        {
           Name = 'Security System Extension'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '17.9.5' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit System Integrity is set to Success and Failure (2)"
        {
           Name = 'System Integrity'
           Ensure = 'Present'
           AuditFlag = 'Failure'
        }
    }
    if($ExcludeList -notcontains '17.9.5' -and $LevelOne){
        AuditPolicySubcategory "(L1) Ensure Audit System Integrity is set to Success and Failure"
        {
           Name = 'System Integrity'
           Ensure = 'Present'
           AuditFlag = 'Success'
        }
    }
    if($ExcludeList -notcontains '18.1.1.1' -and $LevelOne){
        Registry "(L1) Ensure Prevent enabling lock screen camera is set to Enabled"
        {
           ValueName = 'NoLockScreenCamera'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
        }
    }
    if($ExcludeList -notcontains '18.1.1.2' -and $LevelOne){
        Registry "(L1) Ensure Prevent enabling lock screen slide show is set to Enabled"
        {
           ValueName = 'NoLockScreenSlideshow'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Personalization'
        }
    }
    if($ExcludeList -notcontains '18.1.2.2' -and $LevelOne){
        Registry "(L1) Ensure Allow users to enable online speech recognition services is set to Disabled"
        {
           ValueName = 'AllowInputPersonalization'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\InputPersonalization'
        }
    }
    if($ExcludeList -notcontains '18.1.3' -and $LevelTwo){
        Registry "(L2) Ensure Allow Online Tips is set to Disabled"
        {
           ValueName = 'AllowOnlineTips'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.2.2' -and $LevelOne){
        Registry "(L1) Ensure Do not allow password expiration time longer than required by policy is set to Enabled"
        {
           ValueName = 'PwdExpirationProtectionEnabled'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft Services\AdmPwd'
        }
    }
    if($ExcludeList -notcontains '18.2.3' -and $LevelOne){
        Registry "(L1) Ensure Enable Local Admin Password Management is set to Enabled"
        {
           ValueName = 'AdmPwdEnabled'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft Services\AdmPwd'
        }
    }
    if($ExcludeList -notcontains '18.2.4' -and $LevelOne){
        Registry "(L1) Ensure Password Settings Password Complexity is set to Enabled Large letters  small letters  numbers  special characters"
        {
           ValueName = 'PasswordComplexity'
           ValueData = 4
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft Services\AdmPwd'
        }
    }
    if($ExcludeList -notcontains '18.2.5' -and $LevelOne){
        Registry "(L1) Ensure Password Settings Password Length is set to Enabled 15 or more"
        {
           ValueName = 'PasswordLength'
           ValueData = $1825PasswordLength
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft Services\AdmPwd'
        }
    }
    if($ExcludeList -notcontains '18.2.6' -and $LevelOne){
        Registry "(L1) Ensure Password Settings Password Age (Days) is set to Enabled 30 or fewer"
        {
           ValueName = 'PasswordAgeDays'
           ValueData = $1826PasswordAgeDays
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft Services\AdmPwd'
        }
    }
    if($ExcludeList -notcontains '18.3.1' -and $LevelOne){
        Registry "(L1) Ensure Apply UAC restrictions to local accounts on network logons is set to Enabled"
        {
           ValueName = 'LocalAccountTokenFilterPolicy'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        }
    }
    if($ExcludeList -notcontains '18.3.2' -and $LevelOne){
        Registry "(L1) Ensure Configure SMB v1 client driver is set to Enabled Disable driver (recommended)"
        {
           ValueName = 'Start'
           ValueData = 4
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\MrxSmb10'
        }
    }
    if($ExcludeList -notcontains '18.3.3' -and $LevelOne){
        Registry "(L1) Ensure Configure SMB v1 server is set to Disabled"
        {
           ValueName = 'SMB1'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.3.4' -and $LevelOne){
        Registry "(L1) Ensure Enable Structured Exception Handling Overwrite Protection (SEHOP) is set to Enabled"
        {
           ValueName = 'DisableExceptionChainValidation'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel'
        }
    }
    if($ExcludeList -notcontains '18.3.5' -and $LevelOne){
        Registry "(L1) Ensure WDigest Authentication is set to Disabled"
        {
           ValueName = 'UseLogonCredential'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest'
        }
    }
    if($ExcludeList -notcontains '18.4.1' -and $LevelOne){
        Registry "(L1) Ensure MSS (AutoAdminLogon) Enable Automatic Logon (not recommended) is set to Disabled"
        {
           ValueName = 'AutoAdminLogon'
           ValueData = '0'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        }
    }
    if($ExcludeList -notcontains '18.4.2' -and $LevelOne){
        Registry "(L1) Ensure MSS (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing) is set to Enabled Highest protection source routing is completely disabled"
        {
           ValueName = 'DisableIPSourceRouting'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.3' -and $LevelOne){
        Registry "(L1) Ensure MSS (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing) is set to Enabled Highest protection source routing is completely disabled"
        {
           ValueName = 'DisableIPSourceRouting'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.4' -and $LevelTwo){
        Registry "(L2) Ensure MSS (DisableSavePassword) Prevent the dialup password from being saved is set to Enabled"
        {
           ValueName = 'DisableSavePassword'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.5' -and $LevelOne){
        Registry "(L1) Ensure MSS (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes is set to Disabled"
        {
           ValueName = 'EnableICMPRedirect'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.6' -and $LevelTwo){
        Registry "(L2) Ensure MSS (KeepAliveTime) How often keepalive packets are sent in milliseconds is set to Enabled 300000 or 5 minutes (recommended)"
        {
           ValueName = 'KeepAliveTime'
           ValueData = 300000
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.7' -and $LevelOne){
        Registry "(L1) Ensure MSS (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers is set to Enabled"
        {
           ValueName = 'NoNameReleaseOnDemand'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.8' -and $LevelTwo){
        Registry "(L2) Ensure MSS (PerformRouterDiscovery) Allow IRDP to detect and configure Default Gateway addresses (could lead to DoS) is set to Disabled"
        {
           ValueName = 'PerformRouterDiscovery'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.9' -and $LevelOne){
        Registry "(L1) Ensure MSS (SafeDllSearchMode) Enable Safe DLL search mode (recommended) is set to Enabled"
        {
           ValueName = 'SafeDllSearchMode'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
        }
    }
    if($ExcludeList -notcontains '18.4.10' -and $LevelOne){
        Registry "(L1) Ensure MSS (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 recommended) is set to Enabled 5 or fewer seconds"
        {
           ValueName = 'ScreenSaverGracePeriod'
           ValueData = $18410ScreenSaverGracePeriod
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        }
    }
    if($ExcludeList -notcontains '18.4.11' -and $LevelTwo){
        Registry "(L2) Ensure MSS (TcpMaxDataRetransmissions IPv6) How many times unacknowledged data is retransmitted is set to Enabled 3"
        {
           ValueName = 'TcpMaxDataRetransmissions'
           ValueData = 3
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.12' -and $LevelTwo){
        Registry "(L2) Ensure MSS (TcpMaxDataRetransmissions) How many times unacknowledged data is retransmitted is set to Enabled 3"
        {
           ValueName = 'TcpMaxDataRetransmissions'
           ValueData = 3
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.4.13' -and $LevelOne){
        Registry "(L1) Ensure MSS (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning is set to Enabled 90 or less"
        {
           ValueName = 'WarningLevel'
           ValueData = $18413WarningLevel
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Eventlog\Security'
        }
    }
    if($ExcludeList -notcontains '18.5.4.1' -and $LevelOne){
        Registry "(L1) Set NetBIOS node type to Pnode (Ensure NetBT Parameter NodeType is set to 0x2 (2))"
        {
           ValueName = 'NodeType'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.5.4.2' -and $LevelOne){
        Registry "(L1) Ensure Turn off multicast name resolution is set to Enabled"
        {
           ValueName = 'EnableMulticast'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient'
        }
    }
    if($ExcludeList -notcontains '18.5.5.1' -and $LevelTwo){
        Registry "(L2) Ensure Enable Font Providers is set to Disabled"
        {
           ValueName = 'EnableFontProviders'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.5.8.1' -and $LevelOne){
        Registry "(L1) Ensure Enable insecure guest logons is set to Disabled"
        {
           ValueName = 'AllowInsecureGuestAuth'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LanmanWorkstation'
        }
    }
    if($ExcludeList -notcontains '18.5.9.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled (4)"
        {
           ValueName = 'ProhibitLLTDIOOnPrivateNet'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.9.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled"
        {
           ValueName = 'EnableLLTDIO'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.9.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled (2)"
        {
           ValueName = 'AllowLLTDIOOnDomain'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.9.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled (3)"
        {
           ValueName = 'AllowLLTDIOOnPublicNet'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.9.2' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled (4)"
        {
           ValueName = 'ProhibitRspndrOnPrivateNet'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.9.2' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled (3)"
        {
           ValueName = 'AllowRspndrOnPublicNet'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.9.2' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled (2)"
        {
           ValueName = 'AllowRspndrOnDomain'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.9.2' -and $LevelTwo){
        Registry "(L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled"
        {
           ValueName = 'EnableRspndr'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
        }
    }
    if($ExcludeList -notcontains '18.5.10.2' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Microsoft PeertoPeer Networking Services is set to Enabled"
        {
           ValueName = 'Disabled'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Peernet'
        }
    }
    if($ExcludeList -notcontains '18.5.11.2' -and $LevelOne){
        Registry "(L1) Ensure Prohibit installation and configuration of Network Bridge on your DNS domain network is set to Enabled"
        {
           ValueName = 'NC_AllowNetBridge_NLA'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
        }
    }
    if($ExcludeList -notcontains '18.5.11.3' -and $LevelOne){
        Registry "(L1) Ensure Prohibit use of Internet Connection Sharing on your DNS domain network is set to Enabled"
        {
           ValueName = 'NC_ShowSharedAccessUI'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
        }
    }
    if($ExcludeList -notcontains '18.5.11.4' -and $LevelOne){
        Registry "(L1) Ensure Require domain users to elevate when setting a networks location is set to Enabled"
        {
           ValueName = 'NC_StdDomainUserSetLocation'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections'
        }
    }
    if($ExcludeList -notcontains '18.5.14.1' -and $LevelOne){
        Registry "(L1) Ensure Hardened UNC Paths is set to Enabled with Require Mutual Authentication and Require Integrity set for all NETLOGON and SYSVOL shares (2)"
        {
           ValueName = '\\*\SYSVOL'
           ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
        }
    }
    if($ExcludeList -notcontains '18.5.14.1' -and $LevelOne){
        Registry "(L1) Ensure Hardened UNC Paths is set to Enabled with Require Mutual Authentication and Require Integrity set for all NETLOGON and SYSVOL shares"
        {
           ValueName = '\\*\NETLOGON'
           ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
        }
    }
    if($ExcludeList -notcontains '18.5.19.2.1' -and $LevelTwo){
        Registry "(L2) Disable IPv6 (Ensure TCPIP6 Parameter DisabledComponents is set to 0xff (255))"
        {
           ValueName = 'DisabledComponents'
           ValueData = 255
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "(L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (2)"
        {
           ValueName = 'DisableUPnPRegistrar'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "(L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (6)"
        {
           ValueName = 'MaxWCNDeviceNumber'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "(L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (3)"
        {
           ValueName = 'DisableInBand802DOT11Registrar'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "(L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (4)"
        {
           ValueName = 'DisableFlashConfigRegistrar'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "(L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled"
        {
           ValueName = 'EnableRegistrars'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "(L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (5)"
        {
           ValueName = 'DisableWPDRegistrar'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "(L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (7)"
        {
           ValueName = 'HigherPrecedenceRegistrar'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
        }
    }
    if($ExcludeList -notcontains '18.5.20.2' -and $LevelTwo){
        Registry "(L2) Ensure Prohibit access of the Windows Connect Now wizards is set to Enabled"
        {
           ValueName = 'DisableWcnUi'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\UI'
        }
    }
    if($ExcludeList -notcontains '18.5.21.1' -and $LevelOne){
        Registry "(L1) Ensure Minimize the number of simultaneous connections to the Internet or a Windows Domain is set to Enabled"
        {
           ValueName = 'fMinimizeConnections'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy'
        }
    }
    if($ExcludeList -notcontains '18.5.21.2' -and $LevelOne){
        Registry "(L1) Ensure Prohibit connection to nondomain networks when connected to domain authenticated network is set to Enabled"
        {
           ValueName = 'fBlockNonDomain'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy'
        }
    }
    if($ExcludeList -notcontains '18.5.23.2.1' -and $LevelOne){
        Registry "(L1) Ensure Allow Windows to automatically connect to suggested open hotspots to networks shared by contacts and to hotspots offering paid services is set to Disabled"
        {
           ValueName = 'AutoConnectAllowedOEM'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\wcmsvc\wifinetworkmanager\config'
        }
    }
    if($ExcludeList -notcontains '18.7.1.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn off notifications network usage is set to Enabled"
        {
           ValueName = 'NoCloudApplicationNotification'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'
        }
    }
    if($ExcludeList -notcontains '18.8.3.1' -and $LevelOne){
        Registry "(L1) Ensure Include command line in process creation events is set to Disabled"
        {
           ValueName = 'ProcessCreationIncludeCmdLine_Enabled'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit'
        }
    }
    if($ExcludeList -notcontains '18.8.4.1' -and $LevelOne){
        Registry "(L1) Ensure Encryption Oracle Remediation is set to Enabled Force Updated Clients"
        {
           ValueName = 'AllowEncryptionOracle'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.8.4.2' -and $LevelOne){
        Registry "(L1) Ensure Remote host allows delegation of nonexportable credentials is set to Enabled"
        {
           ValueName = 'AllowProtectedCreds'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\CredentialsDelegation'
        }
    }
    if($ExcludeList -notcontains '18.8.5.1' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Turn On Virtualization Based Security is set to Enabled"
        {
           ValueName = 'EnableVirtualizationBasedSecurity'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
        }
    }
    if($ExcludeList -notcontains '18.8.5.2' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Turn On Virtualization Based Security Select Platform Security Level is set to Secure Boot and DMA Protection"
        {
           ValueName = 'RequirePlatformSecurityFeatures'
           ValueData = 3
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
        }
    }
    if($ExcludeList -notcontains '18.8.5.3' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Turn On Virtualization Based Security Virtualization Based Protection of Code Integrity is set to Enabled with UEFI lock"
        {
           ValueName = 'HypervisorEnforcedCodeIntegrity'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
        }
    }
    if($ExcludeList -notcontains '18.8.5.4' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Turn On Virtualization Based Security Require UEFI Memory Attributes Table is set to True (checked)"
        {
           ValueName = 'HVCIMATRequired'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
        }
    }
    if($ExcludeList -notcontains '18.8.5.5' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Turn On Virtualization Based Security Credential Guard Configuration is set to Enabled with UEFI lock"
        {
           ValueName = 'LsaCfgFlags'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
        }
    }
    if($ExcludeList -notcontains '18.8.5.6' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Turn On Virtualization Based Security Secure Launch Configuration is set to Enabled"
        {
           ValueName = 'ConfigureSystemGuardLaunch'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.1' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices that match any of these device IDs is set to Enabled"
        {
           ValueName = 'DenyDeviceIDs'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.2' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices that match any of these device IDs Prevent installation of devices that match any of these device IDs is set to PCICC0C0A"
        {
           ValueName = '1'
           ValueData = 'PCI\CC_0C0A'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceIDs'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.3' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices that match any of these device IDs Also apply to matching devices that are already installed is set to True (checked)"
        {
           ValueName = 'DenyDeviceIDsRetroactive'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.4' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices using drivers that match these device setup classes is set to Enabled (3)"
        {
           ValueName = '2'
           ValueData = '{7ebefbc0-3200-11d2-b4c2-00a0C9697d07}'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.4' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices using drivers that match these device setup classes is set to Enabled (2)"
        {
           ValueName = '1'
           ValueData = '{d48179be-ec20-11d1-b6b8-00c04fa372a7}'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.4' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices using drivers that match these device setup classes is set to Enabled (4)"
        {
           ValueName = '3'
           ValueData = '{c06ff265-ae09-48f0-812c-16753d7cba83}'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.4' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices using drivers that match these device setup classes is set to Enabled (5)"
        {
           ValueName = '4'
           ValueData = '{6bdd1fc1-810f-11d0-bec7-08002be2092f}'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.4' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices using drivers that match these device setup classes is set to Enabled"
        {
           ValueName = 'DenyDeviceClasses'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.5' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices using drivers that match these device setup classes Prevent installation of devices using drivers for these device setup is set to IEEE 1394 device setup classes"
        {
           ValueName = ''
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses'
        }
    }
    if($ExcludeList -notcontains '18.8.7.1.6' -and $BitLocker){
        Registry "(BL) Ensure Prevent installation of devices using drivers that match these device setup classes Also apply to matching devices that are already installed is set to True (checked)"
        {
           ValueName = 'DenyDeviceClassesRetroactive'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions'
        }
    }
    if($ExcludeList -notcontains '18.8.14.1' -and $LevelOne){
        Registry "(L1) Ensure BootStart Driver Initialization Policy is set to Enabled Good unknown and bad but critical"
        {
           ValueName = 'DriverLoadPolicy'
           ValueData = 3
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch'
        }
    }
    if($ExcludeList -notcontains '18.8.21.2' -and $LevelOne){
        Registry "(L1) Ensure Configure registry policy processing Do not apply during periodic background processing is set to Enabled FALSE"
        {
           ValueName = 'NoBackgroundPolicy'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
        }
    }
    if($ExcludeList -notcontains '18.8.21.2' -and $LevelOne){
        Registry "(L1) Ensure Configure registry policy processing Do not apply during periodic background processing is set to Enabled FALSE (2)"
        {
           ValueName = 'NoGPOListChanges'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
        }
    }
    if($ExcludeList -notcontains '18.8.21.4' -and $LevelOne){
        Registry "(L1) Ensure Continue experiences on this device is set to Disabled"
        {
           ValueName = 'EnableCdp'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.21.5' -and $LevelOne){
        Registry "(L1) Ensure Turn off background refresh of Group Policy is set to Disabled"
        {
           ValueName = 'DisableBkGndGroupPolicy'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn off access to the Store is set to Enabled"
        {
           ValueName = 'NoUseStoreOpenWith'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.2' -and $LevelOne){
        Registry "(L1) Ensure Turn off downloading of print drivers over HTTP is set to Enabled"
        {
           ValueName = 'DisableWebPnPDownload'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.3' -and $LevelTwo){
        Registry "(L2) Ensure Turn off handwriting personalization data sharing is set to Enabled"
        {
           ValueName = 'PreventHandwritingDataSharing'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.4' -and $LevelTwo){
        Registry "(L2) Ensure Turn off handwriting recognition error reporting is set to Enabled"
        {
           ValueName = 'PreventHandwritingErrorReports'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.5' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Internet Connection Wizard if URL connection is referring to Microsoftcom is set to Enabled (2)"
        {
           ValueName = 'NoRegistration'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Registration Wizard Control'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.5' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Internet Connection Wizard if URL connection is referring to Microsoftcom is set to Enabled"
        {
           ValueName = 'ExitOnMSICW'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Internet Connection Wizard'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.6' -and $LevelOne){
        Registry "(L1) Ensure Turn off Internet download for Web publishing and online ordering wizards is set to Enabled"
        {
           ValueName = 'NoWebServices'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.7' -and $LevelTwo){
        Registry "(L2) Ensure Turn off printing over HTTP is set to Enabled"
        {
           ValueName = 'DisableHTTPPrinting'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.9' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Search Companion content file updates is set to Enabled"
        {
           ValueName = 'DisableContentFileUpdates'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\SearchCompanion'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.10' -and $LevelTwo){
        Registry "(L2) Ensure Turn off the Order Prints picture task is set to Enabled"
        {
           ValueName = 'NoOnlinePrintsWizard'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.11' -and $LevelTwo){
        Registry "(L2) Ensure Turn off the Publish to Web task for files and folders is set to Enabled"
        {
           ValueName = 'NoPublishingWizard'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.12' -and $LevelTwo){
        Registry "(L2) Ensure Turn off the Windows Messenger Customer Experience Improvement Program is set to Enabled"
        {
           ValueName = 'CEIP'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Messenger\Client'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.13' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Windows Customer Experience Improvement Program is set to Enabled"
        {
           ValueName = 'CEIPEnable'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.14' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Windows Error Reporting is set to Enabled (2)"
        {
           ValueName = 'Disabled'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.14' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Windows Error Reporting is set to Enabled"
        {
           ValueName = 'DoReport'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting'
        }
    }
    if($ExcludeList -notcontains '18.8.25.1' -and $LevelTwo){
        Registry "(L2) Ensure Support device authentication using certificate is set to Enabled Automatic"
        {
           ValueName = 'DevicePKInitEnabled'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.8.25.1' -and $LevelTwo){
        Registry "(L2) Ensure Support device authentication using certificate is set to Enabled Automatic (2)"
        {
           ValueName = 'DevicePKInitBehavior'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
        }
    }
    if($ExcludeList -notcontains '18.8.26.1' -and $BitLocker){
        Registry "(BL) Ensure Enumeration policy for external devices incompatible with Kernel DMA Protection is set to Enabled Block All"
        {
           ValueName = 'DeviceEnumerationPolicy'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Kernel DMA Protection'
        }
    }
    if($ExcludeList -notcontains '18.8.27.1' -and $LevelTwo){
        Registry "(L2) Ensure Disallow copying of user input methods to the system account for signin is set to Enabled"
        {
           ValueName = 'BlockUserInputMethodsForSignIn'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Control Panel\International'
        }
    }
    if($ExcludeList -notcontains '18.8.28.1' -and $LevelOne){
        Registry "(L1) Ensure Block user from showing account details on signin is set to Enabled"
        {
           ValueName = 'BlockUserFromShowingAccountDetailsOnSignin'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.28.2' -and $LevelOne){
        Registry "(L1) Ensure Do not display network selection UI is set to Enabled"
        {
           ValueName = 'DontDisplayNetworkSelectionUI'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.28.3' -and $LevelOne){
        Registry "(L1) Ensure Do not enumerate connected users on domainjoined computers is set to Enabled"
        {
           ValueName = 'DontEnumerateConnectedUsers'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.28.4' -and $LevelOne){
        Registry "(L1) Ensure Enumerate local users on domainjoined computers is set to Disabled"
        {
           ValueName = 'EnumerateLocalUsers'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.28.5' -and $LevelOne){
        Registry "(L1) Ensure Turn off app notifications on the lock screen is set to Enabled"
        {
           ValueName = 'DisableLockScreenAppNotifications'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.28.6' -and $LevelOne){
        Registry "(L1) Ensure Turn off picture password signin is set to Enabled"
        {
           ValueName = 'BlockDomainPicturePassword'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.28.7' -and $LevelOne){
        Registry "(L1) Ensure Turn on convenience PIN signin is set to Disabled"
        {
           ValueName = 'AllowDomainPINLogon'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.31.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow Clipboard synchronization across devices is set to Disabled"
        {
           ValueName = 'AllowCrossDeviceClipboard'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.31.2' -and $LevelTwo){
        Registry "(L2) Ensure Allow upload of User Activities is set to Disabled"
        {
           ValueName = 'UploadUserActivities'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.1' -and $LevelOne){
        Registry "(L1) Ensure Allow network connectivity during connectedstandby (on battery) is set to Disabled"
        {
           ValueName = 'DCSettingIndex'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.2' -and $LevelOne){
        Registry "(L1) Ensure Allow network connectivity during connectedstandby (plugged in) is set to Disabled"
        {
           ValueName = 'ACSettingIndex'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.3' -and $BitLocker){
        Registry "(BL) Ensure Allow standby states (S1S3) when sleeping (on battery) is set to Disabled"
        {
           ValueName = 'DCSettingIndex'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\abfc2519-3608-4c2a-94ea-171b0ed546ab'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.4' -and $BitLocker){
        Registry "(BL) Ensure Allow standby states (S1S3) when sleeping (plugged in) is set to Disabled"
        {
           ValueName = 'ACSettingIndex'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\abfc2519-3608-4c2a-94ea-171b0ed546ab'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.5' -and $LevelOne){
        Registry "(L1) Ensure Require a password when a computer wakes (on battery) is set to Enabled"
        {
           ValueName = 'DCSettingIndex'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.6' -and $LevelOne){
        Registry "(L1) Ensure Require a password when a computer wakes (plugged in) is set to Enabled"
        {
           ValueName = 'ACSettingIndex'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
        }
    }
    if($ExcludeList -notcontains '18.8.36.1' -and $LevelOne){
        Registry "(L1) Ensure Configure Offer Remote Assistance is set to Disabled (3)"
        {
           ValueName = ''
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services\RAUnsolicit'
        }
    }
    if($ExcludeList -notcontains '18.8.36.1' -and $LevelOne){
        Registry "(L1) Ensure Configure Offer Remote Assistance is set to Disabled"
        {
           ValueName = 'fAllowUnsolicited'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.8.36.1' -and $LevelOne){
        Registry "(L1) Ensure Configure Offer Remote Assistance is set to Disabled (2)"
        {
           ValueName = 'fAllowUnsolicitedFullControl'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.8.36.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Solicited Remote Assistance is set to Disabled (2)"
        {
           ValueName = 'fAllowFullControl'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.8.36.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Solicited Remote Assistance is set to Disabled"
        {
           ValueName = 'fAllowToGetHelp'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.8.36.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Solicited Remote Assistance is set to Disabled (5)"
        {
           ValueName = 'fUseMailto'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.8.36.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Solicited Remote Assistance is set to Disabled (3)"
        {
           ValueName = 'MaxTicketExpiry'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.8.36.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Solicited Remote Assistance is set to Disabled (4)"
        {
           ValueName = 'MaxTicketExpiryUnits'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.8.37.1' -and $LevelOne){
        Registry "(L1) Ensure Enable RPC Endpoint Mapper Client Authentication is set to Enabled"
        {
           ValueName = 'EnableAuthEpResolution'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Rpc'
        }
    }
    if($ExcludeList -notcontains '18.8.37.2' -and $LevelOne){
        Registry "(L1) Ensure Restrict Unauthenticated RPC clients is set to Enabled Authenticated"
        {
           ValueName = 'RestrictRemoteClients'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Rpc'
        }
    }
    if($ExcludeList -notcontains '18.8.45.5.1' -and $LevelTwo){
        Registry "(L2) Ensure Microsoft Support Diagnostic Tool Turn on MSDT interactive communication with support provider is set to Disabled"
        {
           ValueName = 'DisableQueryRemoteServer'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy'
        }
    }
    if($ExcludeList -notcontains '18.8.45.11.1' -and $LevelTwo){
        Registry "(L2) Ensure EnableDisable PerfTrack is set to Disabled"
        {
           ValueName = 'ScenarioExecutionEnabled'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}'
        }
    }
    if($ExcludeList -notcontains '18.8.47.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn off the advertising ID is set to Enabled"
        {
           ValueName = 'DisabledByGroupPolicy'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo'
        }
    }
    if($ExcludeList -notcontains '18.8.50.1.1' -and $LevelTwo){
        Registry "(L2) Ensure Enable Windows NTP Client is set to Enabled"
        {
           ValueName = 'Enabled'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient'
        }
    }
    if($ExcludeList -notcontains '18.8.50.1.2' -and $LevelTwo){
        Registry "(L2) Ensure Enable Windows NTP Server is set to Disabled"
        {
           ValueName = 'Enabled'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\W32time\TimeProviders\NtpServer'
        }
    }
    if($ExcludeList -notcontains '18.9.4.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow a Windows app to share application data between users is set to Disabled"
        {
           ValueName = 'AllowSharedLocalAppData'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\AppModel\StateManager'
        }
    }
    if($ExcludeList -notcontains '18.9.6.1' -and $LevelOne){
        Registry "(L1) Ensure Allow Microsoft accounts to be optional is set to Enabled"
        {
           ValueName = 'MSAOptional'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        }
    }
    if($ExcludeList -notcontains '18.9.6.2' -and $LevelTwo){
        Registry "(L2) Ensure Block launching Universal Windows apps with Windows Runtime API access from hosted content is set to Enabled"
        {
           ValueName = 'BlockHostedAppAccessWinRT'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        }
    }
    if($ExcludeList -notcontains '18.9.8.1' -and $LevelOne){
        Registry "(L1) Ensure Disallow Autoplay for nonvolume devices is set to Enabled"
        {
           ValueName = 'NoAutoplayfornonVolume'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.9.8.2' -and $LevelOne){
        Registry "(L1) Ensure Set the default behavior for AutoRun is set to Enabled Do not execute any autorun commands"
        {
           ValueName = 'NoAutorun'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.9.8.3' -and $LevelOne){
        Registry "(L1) Ensure Turn off Autoplay is set to Enabled All drives"
        {
           ValueName = 'NoDriveTypeAutoRun'
           ValueData = 255
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.9.10.1.1' -and $LevelOne){
        Registry "(L1) Ensure Configure enhanced antispoofing is set to Enabled"
        {
           ValueName = 'EnhancedAntiSpoofing'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Biometrics\FacialFeatures'
        }
    }
    if($ExcludeList -notcontains '18.9.11.4' -and $BitLocker){
        Registry "(BL) Ensure Choose drive encryption method and cipher strength (Windows 10 Version 1511 and later) is set to Enabled XTSAES 256bit (3)"
        {
           ValueName = 'EncryptionMethodWithXtsRdv'
           ValueData = 4
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.4' -and $BitLocker){
        Registry "(BL) Ensure Choose drive encryption method and cipher strength (Windows 10 Version 1511 and later) is set to Enabled XTSAES 256bit"
        {
           ValueName = 'EncryptionMethodWithXtsOs'
           ValueData = 7
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.4' -and $BitLocker){
        Registry "(BL) Ensure Choose drive encryption method and cipher strength (Windows 10 Version 1511 and later) is set to Enabled XTSAES 256bit (2)"
        {
           ValueName = 'EncryptionMethodWithXtsFdv'
           ValueData = 7
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.5' -and $BitLocker){
        Registry "(BL) Ensure Disable new DMA devices when this computer is locked is set to Enabled"
        {
           ValueName = 'DisableExternalDMAUnderLock'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.1' -and $BitLocker){
        Registry "(BL) Ensure Allow access to BitLockerprotected fixed data drives from earlier versions of Windows is set to Disabled"
        {
           ValueName = 'FDVDiscoveryVolumeType'
           ValueData = '<none>'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.2' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered is set to Enabled"
        {
           ValueName = 'FDVRecovery'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.3' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered Allow data recovery agent is set to Enabled True"
        {
           ValueName = 'FDVManageDRA'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.4' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered Recovery Password is set to Enabled Allow 48digit recovery password"
        {
           ValueName = 'FDVRecoveryPassword'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.5' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered Recovery Key is set to Enabled Allow 256bit recovery key"
        {
           ValueName = 'FDVRecoveryKey'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.6' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered Omit recovery options from the BitLocker setup wizard is set to Enabled True"
        {
           ValueName = 'FDVHideRecoveryPage'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.7' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered Save BitLocker recovery information to AD DS for fixed data drives is set to Enabled False"
        {
           ValueName = 'FDVActiveDirectoryBackup'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.8' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered Configure storage of BitLocker recovery information to AD DS is set to Enabled Backup recovery passwords and key packages"
        {
           ValueName = 'FDVActiveDirectoryInfoToStore'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.9' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected fixed drives can be recovered Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives is set to Enabled False"
        {
           ValueName = 'FDVRequireActiveDirectoryBackup'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.1' -and $BitLocker){
        Registry "(BL) Ensure Allow enhanced PINs for startup is set to Enabled"
        {
           ValueName = 'UseEnhancedPin'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.2' -and $BitLocker){
        Registry "(BL) Ensure Allow Secure Boot for integrity validation is set to Enabled"
        {
           ValueName = 'OSAllowSecureBootForIntegrity'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.3' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered is set to Enabled"
        {
           ValueName = 'OSRecovery'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.4' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered Allow data recovery agent is set to Enabled False"
        {
           ValueName = 'OSManageDRA'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.5' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered Recovery Password is set to Enabled Require 48digit recovery password"
        {
           ValueName = 'OSRecoveryPassword'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.6' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered Recovery Key is set to Enabled Do not allow 256bit recovery key"
        {
           ValueName = 'OSRecoveryKey'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.7' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered Omit recovery options from the BitLocker setup wizard is set to Enabled True"
        {
           ValueName = 'OSHideRecoveryPage'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.8' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered Save BitLocker recovery information to AD DS for operating system drives is set to Enabled True"
        {
           ValueName = 'OSActiveDirectoryBackup'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.9' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered Configure storage of BitLocker recovery information to AD DS is set to Enabled Store recovery passwords and key packages"
        {
           ValueName = 'OSActiveDirectoryInfoToStore'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.1' -and $BitLocker){
        Registry "(BL) Ensure Allow access to BitLockerprotected removable data drives from earlier versions of Windows is set to Disabled"
        {
           ValueName = 'FDVNoBitLockerToGoReader'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.1' -and $BitLocker){
        Registry "(BL) Ensure Allow access to BitLockerprotected removable data drives from earlier versions of Windows is set to Disabled (2)"
        {
           ValueName = 'RDVDiscoveryVolumeType'
           ValueData = '<none>'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.1' -and $BitLocker){
        Registry "(BL) Ensure Allow access to BitLockerprotected removable data drives from earlier versions of Windows is set to Disabled (3)"
        {
           ValueName = 'RDVNoBitLockerToGoReader'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.2' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered is set to Enabled"
        {
           ValueName = 'RDVRecovery'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.3' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered Allow data recovery agent is set to Enabled True"
        {
           ValueName = 'RDVManageDRA'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.4' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered Recovery Password is set to Enabled Do not allow 48digit recovery password"
        {
           ValueName = 'RDVRecoveryPassword'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.5' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered Recovery Key is set to Enabled Do not allow 256bit recovery key"
        {
           ValueName = 'RDVRecoveryKey'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.6' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered Omit recovery options from the BitLocker setup wizard is set to Enabled True"
        {
           ValueName = 'RDVHideRecoveryPage'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.7' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered Save BitLocker recovery information to AD DS for removable data drives is set to Enabled False"
        {
           ValueName = 'RDVActiveDirectoryBackup'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.8' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered Configure storage of BitLocker recovery information to AD DS is set to Enabled Backup recovery passwords and key packages"
        {
           ValueName = 'RDVActiveDirectoryInfoToStore'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.9' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected removable drives can be recovered Do not enable BitLocker until recovery information is stored to AD DS for removable data drives is set to Enabled False"
        {
           ValueName = 'RDVRequireActiveDirectoryBackup'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.10' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for fixed data drives is set to Enabled"
        {
           ValueName = 'FDVHardwareEncryption'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.11' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for fixed data drives Use BitLocker softwarebased encryption when hardware encryption is not available is set to Enabled True"
        {
           ValueName = 'FDVAllowSoftwareEncryptionFailover'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.12' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for fixed data drives Restrict encryption algorithms and cipher suites allowed for hardwarebased encryption is set to Enabled False"
        {
           ValueName = 'FDVRestrictHardwareEncryptionAlgorithms'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.13' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for fixed data drives Restrict crypto algorithms or cipher suites to the following is set to Enabled 21684011013412216840110134142"
        {
           ValueName = 'FDVAllowedHardwareEncryptionAlgorithms'
           ValueData = '2.16.840.1.101.3.4.1.2;2.16.840.1.101.3.4.1.42'
           Ensure = 'Present'
           ValueType = 'ExpandString'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for fixed data drives is set to Disabled"
        {
           ValueName = 'FDVPassphrase'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for fixed data drives is set to Disabled (2)"
        {
           ValueName = 'FDVEnforcePassphrase'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for fixed data drives is set to Disabled (3)"
        {
           ValueName = 'FDVPassphraseComplexity'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for fixed data drives is set to Disabled (4)"
        {
           ValueName = 'FDVPassphraseLength'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.15' -and $BitLocker){
        Registry "(BL) Ensure Configure use of smart cards on fixed data drives is set to Enabled"
        {
           ValueName = 'FDVAllowUserCert'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.1.16' -and $BitLocker){
        Registry "(BL) Ensure Configure use of smart cards on fixed data drives Require use of smart cards on fixed data drives is set to Enabled True"
        {
           ValueName = 'FDVEnforceUserCert'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.10' -and $BitLocker){
        Registry "(BL) Ensure Choose how BitLockerprotected operating system drives can be recovered Do not enable BitLocker until recovery information is stored to AD DS for operating system drives is set to Enabled True"
        {
           ValueName = 'OSRequireActiveDirectoryBackup'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.11' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for operating system drives is set to Enabled"
        {
           ValueName = 'OSHardwareEncryption'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.12' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for operating system drives Use BitLocker softwarebased encryption when hardware encryption is not available is set to Enabled True"
        {
           ValueName = 'OSAllowSoftwareEncryptionFailover'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.13' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for operating system drives Restrict encryption algorithms and cipher suites allowed for hardwarebased encryption is set to Enabled False"
        {
           ValueName = 'OSRestrictHardwareEncryptionAlgorithms'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for operating system drives Restrict crypto algorithms or cipher suites to the following is set to Enabled 21684011013412216840110134142"
        {
           ValueName = 'OSAllowedHardwareEncryptionAlgorithms'
           ValueData = '2.16.840.1.101.3.4.1.2;2.16.840.1.101.3.4.1.42'
           Ensure = 'Present'
           ValueType = 'ExpandString'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.15' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for operating system drives is set to Disabled (2)"
        {
           ValueName = 'OSPassphraseComplexity'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.15' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for operating system drives is set to Disabled"
        {
           ValueName = 'OSPassphrase'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.15' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for operating system drives is set to Disabled (3)"
        {
           ValueName = 'OSPassphraseLength'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.15' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for operating system drives is set to Disabled (4)"
        {
           ValueName = 'OSPassphraseASCIIOnly'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.16' -and $BitLocker){
        Registry "(BL) Ensure Require additional authentication at startup is set to Enabled"
        {
           ValueName = 'UseAdvancedStartup'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.16' -and $BitLocker){
        Registry "(BL) Ensure Require additional authentication at startup is set to Enabled (5)"
        {
           ValueName = 'UseTPMKeyPIN'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.16' -and $BitLocker){
        Registry "(BL) Ensure Require additional authentication at startup is set to Enabled (2)"
        {
           ValueName = 'UseTPM'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.16' -and $BitLocker){
        Registry "(BL) Ensure Require additional authentication at startup is set to Enabled (3)"
        {
           ValueName = 'UseTPMPIN'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.16' -and $BitLocker){
        Registry "(BL) Ensure Require additional authentication at startup is set to Enabled (4)"
        {
           ValueName = 'UseTPMKey'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.2.17' -and $BitLocker){
        Registry "(BL) Ensure Require additional authentication at startup Allow BitLocker without a compatible TPM is set to Enabled False"
        {
           ValueName = 'EnableBDEWithNoTPM'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.10' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for removable data drives is set to Enabled"
        {
           ValueName = 'RDVHardwareEncryption'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.11' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for removable data drives Use BitLocker softwarebased encryption when hardware encryption is not available is set to Enabled True"
        {
           ValueName = 'RDVAllowSoftwareEncryptionFailover'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.12' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for removable data drives Restrict encryption algorithms and cipher suites allowed for hardwarebased encryption is set to Enabled False"
        {
           ValueName = 'RDVRestrictHardwareEncryptionAlgorithms'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.13' -and $BitLocker){
        Registry "(BL) Ensure Configure use of hardwarebased encryption for removable data drives Restrict crypto algorithms or cipher suites to the following is set to Enabled 21684011013412216840110134142"
        {
           ValueName = 'RDVAllowedHardwareEncryptionAlgorithms'
           ValueData = '2.16.840.1.101.3.4.1.2;2.16.840.1.101.3.4.1.42'
           Ensure = 'Present'
           ValueType = 'ExpandString'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for removable data drives is set to Disabled"
        {
           ValueName = 'RDVPassphrase'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for removable data drives is set to Disabled (4)"
        {
           ValueName = 'RDVPassphraseLength'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for removable data drives is set to Disabled (3)"
        {
           ValueName = 'RDVPassphraseComplexity'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.14' -and $BitLocker){
        Registry "(BL) Ensure Configure use of passwords for removable data drives is set to Disabled (2)"
        {
           ValueName = 'RDVEnforcePassphrase'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.15' -and $BitLocker){
        Registry "(BL) Ensure Configure use of smart cards on removable data drives is set to Enabled"
        {
           ValueName = 'RDVAllowUserCert'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.16' -and $BitLocker){
        Registry "(BL) Ensure Configure use of smart cards on removable data drives Require use of smart cards on removable data drives is set to Enabled True"
        {
           ValueName = 'RDVEnforceUserCert'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.17' -and $BitLocker){
        Registry "(BL) Ensure Deny write access to removable drives not protected by BitLocker is set to Enabled"
        {
           ValueName = 'RDVDenyWriteAccess'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\System\CurrentControlSet\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.11.3.18' -and $BitLocker){
        Registry "(BL) Ensure Deny write access to removable drives not protected by BitLocker Do not allow write access to devices configured in another organization is set to Enabled False"
        {
           ValueName = 'RDVDenyCrossOrg'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\FVE'
        }
    }
    if($ExcludeList -notcontains '18.9.12.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow Use of Camera is set to Disabled"
        {
           ValueName = 'AllowCamera'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Camera'
        }
    }
    if($ExcludeList -notcontains '18.9.13.1' -and $LevelOne){
        Registry "(L1) Ensure Turn off Microsoft consumer experiences is set to Enabled"
        {
           ValueName = 'DisableWindowsConsumerFeatures'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent'
        }
    }
    if($ExcludeList -notcontains '18.9.14.1' -and $LevelOne){
        Registry "(L1) Ensure Require pin for pairing is set to Enabled First Time OR Enabled Always"
        {
           ValueName = 'RequirePinForPairing'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Connect'
        }
    }
    if($ExcludeList -notcontains '18.9.15.1' -and $LevelOne){
        Registry "(L1) Ensure Do not display the password reveal button is set to Enabled"
        {
           ValueName = 'DisablePasswordReveal'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\CredUI'
        }
    }
    if($ExcludeList -notcontains '18.9.15.2' -and $LevelOne){
        Registry "(L1) Ensure Enumerate administrator accounts on elevation is set to Disabled"
        {
           ValueName = 'EnumerateAdministrators'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI'
        }
    }
    if($ExcludeList -notcontains '18.9.16.1' -and $LevelOne){
        Registry "(L1) Ensure Allow Telemetry is set to Enabled 0  Security Enterprise Only or Enabled 1  Basic"
        {
           ValueName = 'AllowTelemetry'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
        }
    }
    if($ExcludeList -notcontains '18.9.16.2' -and $LevelTwo){
        Registry "(L2) Ensure Configure Authenticated Proxy usage for the Connected User Experience and Telemetry service is set to Enabled Disable Authenticated Proxy usage"
        {
           ValueName = 'DisableEnterpriseAuthProxy'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
        }
    }
    if($ExcludeList -notcontains '18.9.16.3' -and $LevelOne){
        Registry "(L1) Ensure Do not show feedback notifications is set to Enabled"
        {
           ValueName = 'DoNotShowFeedbackNotifications'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
        }
    }
    if($ExcludeList -notcontains '18.9.16.4' -and $LevelOne){
        Registry "(L1) Ensure Toggle user control over Insider builds is set to Disabled"
        {
           ValueName = 'AllowBuildPreview'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\PreviewBuilds'
        }
    }
    if($ExcludeList -notcontains '18.9.17.1' -and $LevelOne){
        Registry "(L1) Ensure Download Mode is NOT set to Enabled Internet (3)"
        {
           ValueName = 'DODownloadMode'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\DeliveryOptimization'
        }
    }
    if($ExcludeList -notcontains '18.9.26.1.1' -and $LevelOne){
        Registry "(L1) Ensure Application Control Event Log behavior when the log file reaches its maximum size is set to Disabled"
        {
           ValueName = 'Retention'
           ValueData = '0'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application'
        }
    }
    if($ExcludeList -notcontains '18.9.26.1.2' -and $LevelOne){
        Registry "(L1) Ensure Application Specify the maximum log file size (KB) is set to Enabled 32768 or greater"
        {
           ValueName = 'MaxSize'
           ValueData = $1892612MaxSize
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application'
        }
    }
    if($ExcludeList -notcontains '18.9.26.2.1' -and $LevelOne){
        Registry "(L1) Ensure Security Control Event Log behavior when the log file reaches its maximum size is set to Disabled"
        {
           ValueName = 'Retention'
           ValueData = '0'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security'
        }
    }
    if($ExcludeList -notcontains '18.9.26.2.2' -and $LevelOne){
        Registry "(L1) Ensure Security Specify the maximum log file size (KB) is set to Enabled 196608 or greater"
        {
           ValueName = 'MaxSize'
           ValueData = $1892622MaxSize
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security'
        }
    }
    if($ExcludeList -notcontains '18.9.26.3.1' -and $LevelOne){
        Registry "(L1) Ensure Setup Control Event Log behavior when the log file reaches its maximum size is set to Disabled"
        {
           ValueName = 'Retention'
           ValueData = '0'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup'
        }
    }
    if($ExcludeList -notcontains '18.9.26.3.2' -and $LevelOne){
        Registry "(L1) Ensure Setup Specify the maximum log file size (KB) is set to Enabled 32768 or greater"
        {
           ValueName = 'MaxSize'
           ValueData = $1892632MaxSize
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup'
        }
    }
    if($ExcludeList -notcontains '18.9.26.4.1' -and $LevelOne){
        Registry "(L1) Ensure System Control Event Log behavior when the log file reaches its maximum size is set to Disabled"
        {
           ValueName = 'Retention'
           ValueData = '0'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System'
        }
    }
    if($ExcludeList -notcontains '18.9.26.4.2' -and $LevelOne){
        Registry "(L1) Ensure System Specify the maximum log file size (KB) is set to Enabled 32768 or greater"
        {
           ValueName = 'MaxSize'
           ValueData = $1892642MaxSize
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System'
        }
    }
    if($ExcludeList -notcontains '18.9.30.2' -and $LevelOne){
        Registry "(L1) Ensure Turn off Data Execution Prevention for Explorer is set to Disabled"
        {
           ValueName = 'NoDataExecutionPrevention'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.9.30.3' -and $LevelOne){
        Registry "(L1) Ensure Turn off heap termination on corruption is set to Disabled"
        {
           ValueName = 'NoHeapTerminationOnCorruption'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.9.30.4' -and $LevelOne){
        Registry "(L1) Ensure Turn off shell protocol protected mode is set to Disabled"
        {
           ValueName = 'PreXPSP2ShellProtocolBehavior'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        }
    }
    if($ExcludeList -notcontains '18.9.35.1' -and $LevelOne){
        Registry "(L1) Ensure Prevent the computer from joining a homegroup is set to Enabled"
        {
           ValueName = 'DisableHomeGroup'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\HomeGroup'
        }
    }
    if($ExcludeList -notcontains '18.9.39.2' -and $LevelTwo){
        Registry "(L2) Ensure Turn off location is set to Enabled"
        {
           ValueName = 'DisableLocation'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors'
        }
    }
    if($ExcludeList -notcontains '18.9.43.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow Message Service Cloud Sync is set to Disabled"
        {
           ValueName = 'AllowMessageSync'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Messaging'
        }
    }
    if($ExcludeList -notcontains '18.9.44.1' -and $LevelOne){
        Registry "(L1) Ensure Block all consumer Microsoft account user authentication is set to Enabled"
        {
           ValueName = 'DisableUserAuth'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftAccount'
        }
    }
    if($ExcludeList -notcontains '18.9.45.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow Address bar dropdown list suggestions is set to Disabled"
        {
           ValueName = 'ShowOneBox'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\ServiceUI'
        }
    }
    if($ExcludeList -notcontains '18.9.45.2' -and $LevelTwo){
        Registry "(L2) Ensure Allow Adobe Flash is set to Disabled"
        {
           ValueName = 'FlashPlayerEnabled'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Addons'
        }
    }
    if($ExcludeList -notcontains '18.9.45.3' -and $LevelTwo){
        Registry "(L2) Ensure Allow InPrivate Browsing is set to Disabled"
        {
           ValueName = 'AllowInPrivate'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main'
        }
    }
    if($ExcludeList -notcontains '18.9.45.4' -and $LevelOne){
        Registry "(L1) Ensure Allow Sideloading of extension is set to Disabled"
        {
           ValueName = 'AllowSideloadingOfExtensions'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Extensions'
        }
    }
    if($ExcludeList -notcontains '18.9.45.5' -and $LevelOne){
        Registry "(L1) Ensure Configure cookies is set to Enabled Block only 3rdparty cookies or higher"
        {
           ValueName = 'Cookies'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main'
        }
    }
    if($ExcludeList -notcontains '18.9.45.6' -and $LevelOne){
        Registry "(L1) Ensure Configure Password Manager is set to Disabled"
        {
           ValueName = 'FormSuggest Passwords'
           ValueData = 'no'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main'
        }
    }
    if($ExcludeList -notcontains '18.9.45.7' -and $LevelTwo){
        Registry "(L2) Ensure Configure Popup Blocker is set to Enabled"
        {
           ValueName = 'AllowPopups'
           ValueData = 'yes'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main'
        }
    }
    if($ExcludeList -notcontains '18.9.45.8' -and $LevelTwo){
        Registry "(L2) Ensure Configure search suggestions in Address bar is set to Disabled"
        {
           ValueName = 'ShowSearchSuggestionsGlobal'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\SearchScopes'
        }
    }
    if($ExcludeList -notcontains '18.9.45.9' -and $LevelOne){
        Registry "(L1) Ensure Configure the Adobe Flash ClicktoRun setting is set to Enabled"
        {
           ValueName = 'FlashClickToRunMode'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Security'
        }
    }
    if($ExcludeList -notcontains '18.9.45.10' -and $LevelTwo){
        Registry "(L2) Ensure Prevent access to the aboutflags page in Microsoft Edge is set to Enabled"
        {
           ValueName = 'PreventAccessToAboutFlagsInMicrosoftEdge'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main'
        }
    }
    if($ExcludeList -notcontains '18.9.45.11' -and $LevelOne){
        Registry "(L1) Ensure Prevent certificate error overrides is set to Enabled"
        {
           ValueName = 'PreventCertErrorOverrides'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Internet Settings'
        }
    }
    if($ExcludeList -notcontains '18.9.45.12' -and $LevelTwo){
        Registry "(L2) Ensure Prevent using Localhost IP address for WebRTC is set to Enabled"
        {
           ValueName = 'HideLocalHostIP'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main'
        }
    }
    if($ExcludeList -notcontains '18.9.52.1' -and $LevelOne){
        Registry "(L1) Ensure Prevent the usage of OneDrive for file storage is set to Enabled"
        {
           ValueName = 'DisableFileSyncNGSC'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\OneDrive'
        }
    }
    if($ExcludeList -notcontains '18.9.58.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn off Push To Install service is set to Enabled"
        {
           ValueName = 'DisablePushToInstall'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\PushToInstall'
        }
    }
    if($ExcludeList -notcontains '18.9.59.2.2' -and $LevelOne){
        Registry "(L1) Ensure Do not allow passwords to be saved is set to Enabled"
        {
           ValueName = 'DisablePasswordSaving'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.2.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow users to connect remotely by using Remote Desktop Services is set to Disabled"
        {
           ValueName = 'fDenyTSConnections'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.1' -and $LevelTwo){
        Registry "(L2) Ensure Do not allow COM port redirection is set to Enabled"
        {
           ValueName = 'fDisableCcm'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.2' -and $LevelOne){
        Registry "(L1) Ensure Do not allow drive redirection is set to Enabled"
        {
           ValueName = 'fDisableCdm'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.3' -and $LevelTwo){
        Registry "(L2) Ensure Do not allow LPT port redirection is set to Enabled"
        {
           ValueName = 'fDisableLPT'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.4' -and $LevelTwo){
        Registry "(L2) Ensure Do not allow supported Plug and Play device redirection is set to Enabled"
        {
           ValueName = 'fDisablePNPRedir'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.1' -and $LevelOne){
        Registry "(L1) Ensure Always prompt for password upon connection is set to Enabled"
        {
           ValueName = 'fPromptForPassword'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.2' -and $LevelOne){
        Registry "(L1) Ensure Require secure RPC communication is set to Enabled"
        {
           ValueName = 'fEncryptRPCTraffic'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.3' -and $LevelOne){
        Registry "(L1) Ensure Require use of specific security layer for remote (RDP) connections is set to Enabled SSL"
        {
           ValueName = 'SecurityLayer'
           ValueData = 2
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.4' -and $LevelOne){
        Registry "(L1) Ensure Require user authentication for remote connections by using Network Level Authentication is set to Enabled"
        {
           ValueName = 'UserAuthentication'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.5' -and $LevelOne){
        Registry "(L1) Ensure Set client connection encryption level is set to Enabled High Level"
        {
           ValueName = 'MinEncryptionLevel'
           ValueData = 3
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.10.1' -and $LevelTwo){
        Registry "(L2) Ensure Set time limit for active but idle Remote Desktop Services sessions is set to Enabled 15 minutes or less"
        {
           ValueName = 'MaxIdleTime'
           ValueData = $189593101MaxIdleTime
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.10.2' -and $LevelTwo){
        Registry "(L2) Ensure Set time limit for disconnected sessions is set to Enabled 1 minute"
        {
           ValueName = 'MaxDisconnectionTime'
           ValueData = 60000
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.11.1' -and $LevelOne){
        Registry "(L1) Ensure Do not delete temp folders upon exit is set to Disabled"
        {
           ValueName = 'DeleteTempDirsOnExit'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.11.2' -and $LevelOne){
        Registry "(L1) Ensure Do not use temporary folders per session is set to Disabled"
        {
           ValueName = 'PerSessionTempDir'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
        }
    }
    if($ExcludeList -notcontains '18.9.60.1' -and $LevelOne){
        Registry "(L1) Ensure Prevent downloading of enclosures is set to Enabled"
        {
           ValueName = 'DisableEnclosureDownload'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Feeds'
        }
    }
    if($ExcludeList -notcontains '18.9.61.2' -and $LevelTwo){
        Registry "(L2) Ensure Allow Cloud Search is set to Enabled Disable Cloud Search"
        {
           ValueName = 'AllowCloudSearch'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        }
    }
    if($ExcludeList -notcontains '18.9.61.3' -and $LevelOne){
        Registry "(L1) Ensure Allow Cortana is set to Disabled"
        {
           ValueName = 'AllowCortana'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        }
    }
    if($ExcludeList -notcontains '18.9.61.4' -and $LevelOne){
        Registry "(L1) Ensure Allow Cortana above lock screen is set to Disabled"
        {
           ValueName = 'AllowCortanaAboveLock'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        }
    }
    if($ExcludeList -notcontains '18.9.61.5' -and $LevelOne){
        Registry "(L1) Ensure Allow indexing of encrypted files is set to Disabled"
        {
           ValueName = 'AllowIndexingEncryptedStoresOrItems'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        }
    }
    if($ExcludeList -notcontains '18.9.61.6' -and $LevelOne){
        Registry "(L1) Ensure Allow search and Cortana to use location is set to Disabled"
        {
           ValueName = 'AllowSearchToUseLocation'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
        }
    }
    if($ExcludeList -notcontains '18.9.66.1' -and $LevelTwo){
        Registry "(L2) Ensure Turn off KMS Client Online AVS Validation is set to Enabled"
        {
           ValueName = 'NoGenTicket'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform'
        }
    }
    if($ExcludeList -notcontains '18.9.69.1' -and $LevelTwo){
        Registry "(L2) Ensure Disable all apps from Microsoft Store is set to Disabled"
        {
           ValueName = 'DisableStoreApps'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsStore'
        }
    }
    if($ExcludeList -notcontains '18.9.69.2' -and $LevelOne){
        Registry "(L1) Ensure Only display the private store within the Microsoft Store is set to Enabled"
        {
           ValueName = 'RequirePrivateStoreOnly'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsStore'
        }
    }
    if($ExcludeList -notcontains '18.9.69.3' -and $LevelOne){
        Registry "(L1) Ensure Turn off Automatic Download and Install of updates is set to Disabled"
        {
           ValueName = 'AutoDownload'
           ValueData = 4
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsStore'
        }
    }
    if($ExcludeList -notcontains '18.9.69.4' -and $LevelOne){
        Registry "(L1) Ensure Turn off the offer to update to the latest version of Windows is set to Enabled"
        {
           ValueName = 'DisableOSUpgrade'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsStore'
        }
    }
    if($ExcludeList -notcontains '18.9.69.5' -and $LevelTwo){
        Registry "(L2) Ensure Turn off the Store application is set to Enabled"
        {
           ValueName = 'RemoveWindowsStore'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsStore'
        }
    }
    if($ExcludeList -notcontains '18.9.77.14' -and $LevelOne){
        Registry "(L1) Ensure Configure detection for potentially unwanted applications is set to Enabled Block"
        {
           ValueName = 'PUAProtection'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender'
        }
    }
    if($ExcludeList -notcontains '18.9.77.15' -and $LevelOne){
        Registry "(L1) Ensure Turn off Windows Defender AntiVirus is set to Disabled"
        {
           ValueName = 'DisableAntiSpyware'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender'
        }
    }
    if($ExcludeList -notcontains '18.9.77.3.1' -and $LevelOne){
        Registry "(L1) Ensure Configure local setting override for reporting to Microsoft MAPS is set to Disabled"
        {
           ValueName = 'LocalSettingOverrideSpynetReporting'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet'
        }
    }
    if($ExcludeList -notcontains '18.9.77.3.2' -and $LevelTwo){
        Registry "(L2) Ensure Join Microsoft MAPS is set to Disabled"
        {
           ValueName = 'SpynetReporting'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet'
        }
    }
    if($ExcludeList -notcontains '18.9.77.7.1' -and $LevelOne){
        Registry "(L1) Ensure Turn on behavior monitoring is set to Enabled"
        {
           ValueName = 'DisableBehaviorMonitoring'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection'
        }
    }
    if($ExcludeList -notcontains '18.9.77.9.1' -and $LevelTwo){
        Registry "(L2) Ensure Configure Watson events is set to Disabled"
        {
           ValueName = 'DisableGenericRePorts'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Reporting'
        }
    }
    if($ExcludeList -notcontains '18.9.77.10.1' -and $LevelOne){
        Registry "(L1) Ensure Scan removable drives is set to Enabled"
        {
           ValueName = 'DisableRemovableDriveScanning'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Scan'
        }
    }
    if($ExcludeList -notcontains '18.9.77.10.2' -and $LevelOne){
        Registry "(L1) Ensure Turn on email scanning is set to Enabled"
        {
           ValueName = 'DisableEmailScanning'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Scan'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.1' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules is set to Enabled"
        {
           ValueName = 'ExploitGuard_ASR_Rules'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (3)"
        {
           ValueName = '5beb7efe-fd9a-4556-801d-275e5ffc04cc'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (2)"
        {
           ValueName = '3b576869-a4ec-4529-8536-b80a7769e899'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured"
        {
           ValueName = '26190899-1602-49e8-8b27-eb1d0a1ce869'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (4)"
        {
           ValueName = '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (5)"
        {
           ValueName = '7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (9)"
        {
           ValueName = 'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (10)"
        {
           ValueName = 'd3e037e1-3eb8-44c8-a917-57927947596d'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (7)"
        {
           ValueName = '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (8)"
        {
           ValueName = 'b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (11)"
        {
           ValueName = 'd4f940ab-401b-4efc-aadc-ad5f3c50688a'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.1.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Attack Surface Reduction rules Set the state for each ASR rule is configured (6)"
        {
           ValueName = '92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b'
           ValueData = '1'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.3.1' -and $LevelOne){
        Registry "(L1) Ensure Prevent users and apps from accessing dangerous websites is set to Enabled Block"
        {
           ValueName = 'EnableNetworkProtection'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection'
        }
    }
    if($ExcludeList -notcontains '18.9.78.1' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Allow auditing events in Windows Defender Application Guard is set to Enabled"
        {
           ValueName = 'AuditApplicationGuard'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.78.2' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Allow camera and microphone access in Windows Defender Application Guard is set to Disabled"
        {
           ValueName = 'AllowCameraMicrophoneRedirection'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.78.3' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Allow data persistence for Windows Defender Application Guard is set to Disabled"
        {
           ValueName = 'AllowPersistence'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.78.4' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Allow files to download and save to the host operating system from Windows Defender Application Guard is set to Disabled"
        {
           ValueName = 'SaveFilesToHost'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.78.5' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Allow users to trust files that open in Windows Defender Application Guard is set to Enabled 0 (Do not allow users to manually trust files) OR 2 (Allow users to manually trust after an antivirus check)"
        {
           ValueName = 'FileTrustCriteria'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.78.6' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Configure Windows Defender Application Guard clipboard settings Clipboard behavior setting is set to Enabled Enable clipboard operation from an isolated session to the host (2)"
        {
           ValueName = 'AppHVSIClipboardFileType'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.78.6' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Configure Windows Defender Application Guard clipboard settings Clipboard behavior setting is set to Enabled Enable clipboard operation from an isolated session to the host"
        {
           ValueName = 'AppHVSIClipboardSettings'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.78.7' -and $NextGenerationWindowsSecurity){
        Registry "(NG) Ensure Turn on Windows Defender Application Guard in Enterprise Mode is set to Enabled 1"
        {
           ValueName = 'AllowAppHVSI_ProviderSet'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
        }
    }
    if($ExcludeList -notcontains '18.9.80.1.1' -and $LevelOne){
        Registry "(L1) Ensure Configure Windows Defender SmartScreen is set to Enabled Warn and prevent bypass"
        {
           ValueName = 'EnableSmartScreen'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.9.80.1.1' -and $LevelOne){
        Registry "(L1) Ensure Configure Windows Defender SmartScreen is set to Enabled Warn and prevent bypass (2)"
        {
           ValueName = 'ShellSmartScreenLevel'
           ValueData = 'Block'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
        }
    }
    if($ExcludeList -notcontains '18.9.80.2.1' -and $LevelOne){
        Registry "(L1) Ensure Configure Windows Defender SmartScreen is set to Enabled"
        {
           ValueName = 'EnabledV9'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter'
        }
    }
    if($ExcludeList -notcontains '18.9.80.2.2' -and $LevelOne){
        Registry "(L1) Ensure Prevent bypassing Windows Defender SmartScreen prompts for files is set to Enabled"
        {
           ValueName = 'PreventOverrideAppRepUnknown'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter'
        }
    }
    if($ExcludeList -notcontains '18.9.80.2.3' -and $LevelOne){
        Registry "(L1) Ensure Prevent bypassing Windows Defender SmartScreen prompts for sites is set to Enabled"
        {
           ValueName = 'PreventOverride'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter'
        }
    }
    if($ExcludeList -notcontains '18.9.82.1' -and $LevelOne){
        Registry "(L1) Ensure Enables or disables Windows Game Recording and Broadcasting is set to Disabled"
        {
           ValueName = 'AllowGameDVR'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR'
        }
    }
    if($ExcludeList -notcontains '18.9.84.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow suggested apps in Windows Ink Workspace is set to Disabled"
        {
           ValueName = 'AllowSuggestedAppsInWindowsInkWorkspace'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace'
        }
    }
    if($ExcludeList -notcontains '18.9.84.2' -and $LevelOne){
        Registry "(L1) Ensure Allow Windows Ink Workspace is set to Enabled On but disallow access above lock OR Disabled but not Enabled On"
        {
           ValueName = 'AllowWindowsInkWorkspace'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace'
        }
    }
    if($ExcludeList -notcontains '18.9.85.1' -and $LevelOne){
        Registry "(L1) Ensure Allow user control over installs is set to Disabled"
        {
           ValueName = 'EnableUserControl'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
        }
    }
    if($ExcludeList -notcontains '18.9.85.2' -and $LevelOne){
        Registry "(L1) Ensure Always install with elevated privileges is set to Disabled"
        {
           ValueName = 'AlwaysInstallElevated'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
        }
    }
    if($ExcludeList -notcontains '18.9.85.3' -and $LevelTwo){
        Registry "(L2) Ensure Prevent Internet Explorer security prompt for Windows Installer scripts is set to Disabled"
        {
           ValueName = 'SafeForScripting'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
        }
    }
    if($ExcludeList -notcontains '18.9.86.1' -and $LevelOne){
        Registry "(L1) Ensure Signin last interactive user automatically after a systeminitiated restart is set to Disabled"
        {
           ValueName = 'DisableAutomaticRestartSignOn'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        }
    }
    if($ExcludeList -notcontains '18.9.95.1' -and $LevelOne){
        Registry "(L1) Ensure Turn on PowerShell Script Block Logging is set to Disabled (2)"
        {
           ValueName = 'EnableScriptBlockInvocationLogging'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
        }
    }
    if($ExcludeList -notcontains '18.9.95.1' -and $LevelOne){
        Registry "(L1) Ensure Turn on PowerShell Script Block Logging is set to Disabled"
        {
           ValueName = 'EnableScriptBlockLogging'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
        }
    }
    if($ExcludeList -notcontains '18.9.95.2' -and $LevelOne){
        Registry "(L1) Ensure Turn on PowerShell Transcription is set to Disabled (2)"
        {
           ValueName = 'OutputDirectory'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription'
        }
    }
    if($ExcludeList -notcontains '18.9.95.2' -and $LevelOne){
        Registry "(L1) Ensure Turn on PowerShell Transcription is set to Disabled"
        {
           ValueName = 'EnableTranscripting'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription'
        }
    }
    if($ExcludeList -notcontains '18.9.95.2' -and $LevelOne){
        Registry "(L1) Ensure Turn on PowerShell Transcription is set to Disabled (3)"
        {
           ValueName = 'EnableInvocationHeader'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription'
        }
    }
    if($ExcludeList -notcontains '18.9.97.1.1' -and $LevelOne){
        Registry "(L1) Ensure Allow Basic authentication is set to Disabled"
        {
           ValueName = 'AllowBasic'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
        }
    }
    if($ExcludeList -notcontains '18.9.97.1.2' -and $LevelOne){
        Registry "(L1) Ensure Allow unencrypted traffic is set to Disabled"
        {
           ValueName = 'AllowUnencryptedTraffic'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
        }
    }
    if($ExcludeList -notcontains '18.9.97.1.3' -and $LevelOne){
        Registry "(L1) Ensure Disallow Digest authentication is set to Enabled"
        {
           ValueName = 'AllowDigest'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.1' -and $LevelOne){
        Registry "(L1) Ensure Allow Basic authentication is set to Disabled (2)"
        {
           ValueName = 'AllowBasic'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.2' -and $LevelTwo){
        Registry "(L2) Ensure Allow remote server management through WinRM is set to Disabled (2)"
        {
           ValueName = 'IPv4Filter'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.2' -and $LevelTwo){
        Registry "(L2) Ensure Allow remote server management through WinRM is set to Disabled"
        {
           ValueName = 'AllowAutoConfig'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.2' -and $LevelTwo){
        Registry "(L2) Ensure Allow remote server management through WinRM is set to Disabled (3)"
        {
           ValueName = 'IPv6Filter'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.3' -and $LevelOne){
        Registry "(L1) Ensure Allow unencrypted traffic is set to Disabled (2)"
        {
           ValueName = 'AllowUnencryptedTraffic'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.4' -and $LevelOne){
        Registry "(L1) Ensure Disallow WinRM from storing RunAs credentials is set to Enabled"
        {
           ValueName = 'DisableRunAs'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
        }
    }
    if($ExcludeList -notcontains '18.9.98.1' -and $LevelTwo){
        Registry "(L2) Ensure Allow Remote Shell Access is set to Disabled"
        {
           ValueName = 'AllowRemoteShellAccess'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\WinRS'
        }
    }
    if($ExcludeList -notcontains '18.9.99.2.1' -and $LevelOne){
        Registry "(L1) Ensure Prevent users from modifying settings is set to Enabled"
        {
           ValueName = 'DisallowExploitProtectionOverride'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender Security Center\App and Browser protection'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled"
        {
           ValueName = 'NoAutoUpdate'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (9)"
        {
           ValueName = 'ScheduledInstallFourthWeek'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (3)"
        {
           ValueName = 'AutomaticMaintenanceEnabled'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (4)"
        {
           ValueName = 'ScheduledInstallTime'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (7)"
        {
           ValueName = 'ScheduledInstallSecondWeek'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (5)"
        {
           ValueName = 'ScheduledInstallEveryWeek'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (10)"
        {
           ValueName = 'AllowMUUpdateService'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (2)"
        {
           ValueName = 'AUOptions'
           ValueData = 3
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (6)"
        {
           ValueName = 'ScheduledInstallFirstWeek'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates is set to Enabled (8)"
        {
           ValueName = 'ScheduledInstallThirdWeek'
           Ensure = 'Absent'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.3' -and $LevelOne){
        Registry "(L1) Ensure Configure Automatic Updates Scheduled install day is set to 0  Every day"
        {
           ValueName = 'ScheduledInstallDay'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.4' -and $LevelOne){
        Registry "(L1) Ensure No autorestart with logged on users for scheduled automatic updates installations is set to Disabled"
        {
           ValueName = 'NoAutoRebootWithLoggedOnUsers'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU'
        }
    }
    if($ExcludeList -notcontains '18.9.102.5' -and $LevelOne){
        Registry "(L1) Ensure Remove access to Pause updates feature is set to Enabled"
        {
           ValueName = 'SetDisablePauseUXAccess'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.1' -and $LevelOne){
        Registry "(L1) Ensure Manage preview builds is set to Enabled Disable preview builds"
        {
           ValueName = 'ManagePreviewBuilds'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.1' -and $LevelOne){
        Registry "(L1) Ensure Manage preview builds is set to Enabled Disable preview builds (2)"
        {
           ValueName = 'ManagePreviewBuildsPolicyValue'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.2' -and $LevelOne){
        Registry "(L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled SemiAnnual Channel 180 or more days (3)"
        {
           ValueName = 'DeferFeatureUpdatesPeriodInDays'
           ValueData = $18910212DeferFeatureUpdatesPeriodInDays
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.2' -and $LevelOne){
        Registry "(L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled SemiAnnual Channel 180 or more days (4)"
        {
           ValueName = 'PauseFeatureUpdatesStartTime'
           ValueData = '0'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.2' -and $LevelOne){
        Registry "(L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled SemiAnnual Channel 180 or more days (2)"
        {
           ValueName = 'BranchReadinessLevel'
           ValueData = 32
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.2' -and $LevelOne){
        Registry "(L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled SemiAnnual Channel 180 or more days"
        {
           ValueName = 'DeferFeatureUpdates'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.3' -and $LevelOne){
        Registry "(L1) Ensure Select when Quality Updates are received is set to Enabled 0 days"
        {
           ValueName = 'DeferQualityUpdates'
           ValueData = 1
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.3' -and $LevelOne){
        Registry "(L1) Ensure Select when Quality Updates are received is set to Enabled 0 days (3)"
        {
           ValueName = 'PauseQualityUpdatesStartTime'
           ValueData = '0'
           Ensure = 'Present'
           ValueType = 'String'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.3' -and $LevelOne){
        Registry "(L1) Ensure Select when Quality Updates are received is set to Enabled 0 days (2)"
        {
           ValueName = 'DeferQualityUpdatesPeriodInDays'
           ValueData = 0
           Ensure = 'Present'
           ValueType = 'Dword'
           Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
        }
    }
}
