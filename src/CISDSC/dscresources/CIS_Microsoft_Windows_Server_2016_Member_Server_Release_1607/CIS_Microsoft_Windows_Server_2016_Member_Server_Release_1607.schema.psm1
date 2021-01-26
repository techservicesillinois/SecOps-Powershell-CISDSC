Configuration CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607
{
    param
    (
        [string[]]$ExcludeList = @(),
        [boolean]$LevelOne = $true,
        [boolean]$LevelTwo = $false,
        [boolean]$NextGenerationWindowsSecurity = $false,
        [ValidateRange(60,999)]
        [Int32]$cis112MaximumPasswordAge = 60,
        [ValidateRange(1,998)]
        [Int32]$cis113MinimumPasswordAge = 1,
        [ValidateRange(15,99999)]
        [Int32]$cis121Accountlockoutduration = 15,
        [ValidateRange(10,999)]
        [Int32]$cis122Accountlockoutthreshold = 10,
        [ValidateRange(15,99999)]
        [Int32]$cis123Resetaccountlockoutcounterafter = 15,
        [ValidateRange(15,64)]
        [int32]$cis1825PasswordLength = 15,
        [ValidateRange(30,365)]
        [int32]$cis1826PasswordAgeDays = 30,
        [ValidateRange(0,90)]
        [int32]$a18412WarningLevel = 90,
        [ValidateSet('0','1','2','3','4','5')]
        [string]$a1849ScreenSaverGracePeriod = '0',
        [ValidateRange(180,365)]
        [int32]$cis18910212DeferFeatureUpdatesPeriodInDays = 180,
        [ValidateRange(32768,2147483647)]
        [int32]$cis1892612MaxSize = 32768,
        [ValidateRange(196608,2147483647)]
        [int32]$cis1892622MaxSize = 196608,
        [ValidateRange(32768,2147483647)]
        [int32]$cis1892632MaxSize = 32768,
        [ValidateRange(32768,2147483647)]
        [int32]$cis1892642MaxSize = 32768,
        [ValidateRange(60000,900000)]
        [int32]$cis189593101MaxIdleTime = 900000,
        [ValidateLength(1,256)]
        [String]$cis2315AccountsRenameadministratoraccount,
        [ValidateLength(1,256)]
        [String]$cis2316AccountsRenameguestaccount,
        [ValidateRange(1,30)]
        [int32]$cis2365MaximumPasswordAge = 30,
        [ValidateRange(1,900)]
        [int32]$a2373InactivityTimeoutSecs = 900,
        [ValidateLength(1,2048)]
        [string]$a2374LegalNoticeText,
        [ValidateLength(1,512)]
        [string]$a2375LegalNoticeCaption,
        [ValidateSet('0','1','2','3','4')]
        [string]$a2376CachedLogonsCount = '4',
        [ValidateLength(1,15)]
        [int32]$cis2391AutoDisconnect = 15,
        [ValidateRange(16384,2147483647)]
        [int32]$cis916LogFileSize = 16384,
        [ValidateRange(16384,2147483647)]
        [int32]$cis926LogFileSize = 16384,
        [ValidateRange(16384,2147483647)]
        [int32]$cis938LogFileSize = 16384
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CISService'
    Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion '1.4.0.0'
    Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion '2.10.0.0'

    if($ExcludeList -notcontains '2.3.1.5' -and $PSBoundParameters.Keys -notcontains 'cis2315AccountsRenameadministratoraccount'){
        throw 'Please add "2.3.1.5" to the ExcludeList or provide a value for "cis2315AccountsRenameadministratoraccount"'
    }
    if($ExcludeList -notcontains '2.3.1.6' -and $PSBoundParameters.Keys -notcontains 'cis2316AccountsRenameguestaccount'){
        throw 'Please add "2.3.1.6" to the ExcludeList or provide a value for "cis2316AccountsRenameguestaccount"'
    }
    if($ExcludeList -notcontains '2.3.7.4' -and $PSBoundParameters.Keys -notcontains 'a2374LegalNoticeText'){
        throw 'Please add "2.3.7.4" to the ExcludeList or provide a value for "a2374LegalNoticeText"'
    }
    if($ExcludeList -notcontains '2.3.7.5' -and $PSBoundParameters.Keys -notcontains 'a2375LegalNoticeCaption'){
        throw 'Please add "2.3.7.5" to the ExcludeList or provide a value for "a2375LegalNoticeCaption"'
    }

    if($ExcludeList -notcontains '1.1.1' -and $LevelOne){
        AccountPolicy "1.1.1 - (L1) Ensure Enforce password history is set to 24 or more password(s)" {
            Enforce_password_history = 24
            Name = 'Enforce_password_history'
        }
    }
    if($ExcludeList -notcontains '1.1.2' -and $LevelOne){
        AccountPolicy "1.1.2 - (L1) Ensure Maximum password age is set to 60 or fewer days but not 0" {
            Maximum_Password_Age = $cis112MaximumPasswordAge
            Name = 'Maximum_Password_Age'
        }
    }
    if($ExcludeList -notcontains '1.1.3' -and $LevelOne){
        AccountPolicy "1.1.3 - (L1) Ensure Minimum password age is set to 1 or more day(s)" {
            Minimum_Password_Age = $cis113MinimumPasswordAge
            Name = 'Minimum_Password_Age'
        }
    }
    if($ExcludeList -notcontains '1.1.4' -and $LevelOne){
        AccountPolicy "1.1.4 - (L1) Ensure Minimum password length is set to 14 or more character(s)" {
            Minimum_Password_Length = 14
            Name = 'Minimum_Password_Length'
        }
    }
    if($ExcludeList -notcontains '1.1.5' -and $LevelOne){
        AccountPolicy "1.1.5 - (L1) Ensure Password must meet complexity requirements is set to Enabled" {
            Name = 'Password_must_meet_complexity_requirements'
            Password_must_meet_complexity_requirements = 'Enabled'
        }
    }
    if($ExcludeList -notcontains '1.1.6' -and $LevelOne){
        AccountPolicy "1.1.6 - (L1) Ensure Store passwords using reversible encryption is set to Disabled" {
            Name = 'Store_passwords_using_reversible_encryption'
            Store_passwords_using_reversible_encryption = 'Disabled'
        }
    }
    if($ExcludeList -notcontains '1.2.1' -and $LevelOne){
        AccountPolicy "1.2.1 - (L1) Ensure Account lockout duration is set to 15 or more minute(s)" {
            Account_lockout_duration = $cis121Accountlockoutduration
            Name = 'Account_lockout_duration'
        }
    }
    if($ExcludeList -notcontains '1.2.2' -and $LevelOne){
        AccountPolicy "1.2.2 - (L1) Ensure Account lockout threshold is set to 10 or fewer invalid logon attempt(s) but not 0" {
            Account_lockout_threshold = $cis122Accountlockoutthreshold
            Name = 'Account_lockout_threshold'
        }
    }
    if($ExcludeList -notcontains '1.2.3' -and $LevelOne){
        AccountPolicy "1.2.3 - (L1) Ensure Reset account lockout counter after is set to 15 or more minute(s)" {
            Name = 'Reset_account_lockout_counter_after'
            Reset_account_lockout_counter_after = $cis123Resetaccountlockoutcounterafter
        }
    }
    if($ExcludeList -notcontains '2.2.1' -and $LevelOne){
        UserRightsAssignment "2.2.1 - (L1) Ensure Access Credential Manager as a trusted caller is set to No One" {
            Force = $true
            Identity = @('')
            Policy = 'Access_Credential_Manager_as_a_trusted_caller'
        }
    }
    if($ExcludeList -notcontains '2.2.3' -and $LevelOne){
        UserRightsAssignment "2.2.3 - (L1) Ensure Access this computer from the network  is set to Administrators Authenticated Users (MS only)" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-11')
            Policy = 'Access_this_computer_from_the_network'
        }
    }
    if($ExcludeList -notcontains '2.2.4' -and $LevelOne){
        UserRightsAssignment "2.2.4 - (L1) Ensure Act as part of the operating system is set to No One" {
            Force = $true
            Identity = @('')
            Policy = 'Act_as_part_of_the_operating_system'
        }
    }
    if($ExcludeList -notcontains '2.2.6' -and $LevelOne){
        UserRightsAssignment "2.2.6 - (L1) Ensure Adjust memory quotas for a process is set to Administrators LOCAL SERVICE NETWORK SERVICE" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-19','*S-1-5-20')
            Policy = 'Adjust_memory_quotas_for_a_process'
        }
    }
    if($ExcludeList -notcontains '2.2.7' -and $LevelOne){
        UserRightsAssignment "2.2.7 - (L1) Ensure Allow log on locally is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Allow_log_on_locally'
        }
    }
    if($ExcludeList -notcontains '2.2.9' -and $LevelOne){
        UserRightsAssignment "2.2.9 - (L1) Ensure Allow log on through Remote Desktop Services is set to Administrators Remote Desktop Users (MS only)" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-32-555')
            Policy = 'Allow_log_on_through_Remote_Desktop_Services'
        }
    }
    if($ExcludeList -notcontains '2.2.10' -and $LevelOne){
        UserRightsAssignment "2.2.10 - (L1) Ensure Back up files and directories is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Back_up_files_and_directories'
        }
    }
    if($ExcludeList -notcontains '2.2.11' -and $LevelOne){
        UserRightsAssignment "2.2.11 - (L1) Ensure Change the system time is set to Administrators LOCAL SERVICE" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-19')
            Policy = 'Change_the_system_time'
        }
    }
    if($ExcludeList -notcontains '2.2.12' -and $LevelOne){
        UserRightsAssignment "2.2.12 - (L1) Ensure Change the time zone is set to Administrators LOCAL SERVICE" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-19')
            Policy = 'Change_the_time_zone'
        }
    }
    if($ExcludeList -notcontains '2.2.13' -and $LevelOne){
        UserRightsAssignment "2.2.13 - (L1) Ensure Create a pagefile is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Create_a_pagefile'
        }
    }
    if($ExcludeList -notcontains '2.2.14' -and $LevelOne){
        UserRightsAssignment "2.2.14 - (L1) Ensure Create a token object is set to No One" {
            Force = $true
            Identity = @('')
            Policy = 'Create_a_token_object'
        }
    }
    if($ExcludeList -notcontains '2.2.15' -and $LevelOne){
        UserRightsAssignment "2.2.15 - (L1) Ensure Create global objects is set to Administrators LOCAL SERVICE NETWORK SERVICE SERVICE" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-19','*S-1-5-20','*S-1-5-6')
            Policy = 'Create_global_objects'
        }
    }
    if($ExcludeList -notcontains '2.2.16' -and $LevelOne){
        UserRightsAssignment "2.2.16 - (L1) Ensure Create permanent shared objects is set to No One" {
            Force = $true
            Identity = @('')
            Policy = 'Create_permanent_shared_objects'
        }
    }
    if($ExcludeList -notcontains '2.2.18' -and $LevelOne){
        UserRightsAssignment "2.2.18 - (L1) Ensure Create symbolic links is set to Administrators NT VIRTUAL MACHINEVirtual Machines (MS only)" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Create_symbolic_links'
        }
    }
    if($ExcludeList -notcontains '2.2.19' -and $LevelOne){
        UserRightsAssignment "2.2.19 - (L1) Ensure Debug programs is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Debug_programs'
        }
    }
    if($ExcludeList -notcontains '2.2.21' -and $LevelOne){
        UserRightsAssignment "2.2.21 - (L1) Ensure Deny access to this computer from the network to include Guests Local account and member of Administrators group (MS only)" {
            Force = $true
            Identity = @('*S-1-5-32-546','*S-1-5-114')
            Policy = 'Deny_access_to_this_computer_from_the_network'
        }
    }
    if($ExcludeList -notcontains '2.2.22' -and $LevelOne){
        UserRightsAssignment "2.2.22 - (L1) Ensure Deny log on as a batch job to include Guests" {
            Force = $true
            Identity = @('*S-1-5-32-546')
            Policy = 'Deny_log_on_as_a_batch_job'
        }
    }
    if($ExcludeList -notcontains '2.2.23' -and $LevelOne){
        UserRightsAssignment "2.2.23 - (L1) Ensure Deny log on as a service to include Guests" {
            Force = $true
            Identity = @('*S-1-5-32-546')
            Policy = 'Deny_log_on_as_a_service'
        }
    }
    if($ExcludeList -notcontains '2.2.24' -and $LevelOne){
        UserRightsAssignment "2.2.24 - (L1) Ensure Deny log on locally to include Guests" {
            Force = $true
            Identity = @('*S-1-5-32-546')
            Policy = 'Deny_log_on_locally'
        }
    }
    if($ExcludeList -notcontains '2.2.26' -and $LevelOne){
        UserRightsAssignment "2.2.26 - (L1) Ensure Deny log on through Remote Desktop Services is set to Guests Local account (MS only)" {
            Force = $true
            Identity = @('*S-1-5-32-546','*S-1-5-113')
            Policy = 'Deny_log_on_through_Remote_Desktop_Services'
        }
    }
    if($ExcludeList -notcontains '2.2.28' -and $LevelOne){
        UserRightsAssignment "2.2.28 - (L1) Ensure Enable computer and user accounts to be trusted for delegation is set to No One (MS only)" {
            Force = $true
            Identity = @('')
            Policy = 'Enable_computer_and_user_accounts_to_be_trusted_for_delegation'
        }
    }
    if($ExcludeList -notcontains '2.2.29' -and $LevelOne){
        UserRightsAssignment "2.2.29 - (L1) Ensure Force shutdown from a remote system is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Force_shutdown_from_a_remote_system'
        }
    }
    if($ExcludeList -notcontains '2.2.30' -and $LevelOne){
        UserRightsAssignment "2.2.30 - (L1) Ensure Generate security audits is set to LOCAL SERVICE NETWORK SERVICE" {
            Force = $true
            Identity = @('*S-1-5-19','*S-1-5-20')
            Policy = 'Generate_security_audits'
        }
    }
    if($ExcludeList -notcontains '2.2.32' -and $LevelOne){
        UserRightsAssignment "2.2.32 - (L1) Ensure Impersonate a client after authentication is set to Administrators LOCAL SERVICE NETWORK SERVICE SERVICE and (when the Web Server (IIS) Role with Web Services Role Service is installed) IISIUSRS (MS only)" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-19','*S-1-5-20','*S-1-5-6')
            Policy = 'Impersonate_a_client_after_authentication'
        }
    }
    if($ExcludeList -notcontains '2.2.33' -and $LevelOne){
        UserRightsAssignment "2.2.33 - (L1) Ensure Increase scheduling priority is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Increase_scheduling_priority'
        }
    }
    if($ExcludeList -notcontains '2.2.34' -and $LevelOne){
        UserRightsAssignment "2.2.34 - (L1) Ensure Load and unload device drivers is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Load_and_unload_device_drivers'
        }
    }
    if($ExcludeList -notcontains '2.2.35' -and $LevelOne){
        UserRightsAssignment "2.2.35 - (L1) Ensure Lock pages in memory is set to No One" {
            Force = $true
            Identity = @('')
            Policy = 'Lock_pages_in_memory'
        }
    }
    if($ExcludeList -notcontains '2.2.38' -and $LevelOne){
        UserRightsAssignment "2.2.38 - (L1) Ensure Manage auditing and security log is set to Administrators (MS only)" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Manage_auditing_and_security_log'
        }
    }
    if($ExcludeList -notcontains '2.2.39' -and $LevelOne){
        UserRightsAssignment "2.2.39 - (L1) Ensure Modify an object label is set to No One" {
            Force = $true
            Identity = @('')
            Policy = 'Modify_an_object_label'
        }
    }
    if($ExcludeList -notcontains '2.2.40' -and $LevelOne){
        UserRightsAssignment "2.2.40 - (L1) Ensure Modify firmware environment values is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Modify_firmware_environment_values'
        }
    }
    if($ExcludeList -notcontains '2.2.41' -and $LevelOne){
        UserRightsAssignment "2.2.41 - (L1) Ensure Perform volume maintenance tasks is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Perform_volume_maintenance_tasks'
        }
    }
    if($ExcludeList -notcontains '2.2.42' -and $LevelOne){
        UserRightsAssignment "2.2.42 - (L1) Ensure Profile single process is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Profile_single_process'
        }
    }
    if($ExcludeList -notcontains '2.2.43' -and $LevelOne){
        UserRightsAssignment "2.2.43 - (L1) Ensure Profile system performance is set to Administrators NT SERVICEWdiServiceHost" {
            Force = $true
            Identity = @('*S-1-5-32-544','*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420')
            Policy = 'Profile_system_performance'
        }
    }
    if($ExcludeList -notcontains '2.2.44' -and $LevelOne){
        UserRightsAssignment "2.2.44 - (L1) Ensure Replace a process level token is set to LOCAL SERVICE NETWORK SERVICE" {
            Force = $true
            Identity = @('*S-1-5-19','*S-1-5-20')
            Policy = 'Replace_a_process_level_token'
        }
    }
    if($ExcludeList -notcontains '2.2.45' -and $LevelOne){
        UserRightsAssignment "2.2.45 - (L1) Ensure Restore files and directories is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Restore_files_and_directories'
        }
    }
    if($ExcludeList -notcontains '2.2.46' -and $LevelOne){
        UserRightsAssignment "2.2.46 - (L1) Ensure Shut down the system is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Shut_down_the_system'
        }
    }
    if($ExcludeList -notcontains '2.2.48' -and $LevelOne){
        UserRightsAssignment "2.2.48 - (L1) Ensure Take ownership of files or other objects is set to Administrators" {
            Force = $true
            Identity = @('*S-1-5-32-544')
            Policy = 'Take_ownership_of_files_or_other_objects'
        }
    }
    if($ExcludeList -notcontains '2.3.1.1' -and $LevelOne){
        SecurityOption "2.3.1.1 - (L1) Ensure Accounts Administrator account status is set to Disabled (MS only)" {
            Accounts_Administrator_account_status = 'Disabled'
            Name = 'Accounts_Administrator_account_status'
        }
    }
    if($ExcludeList -notcontains '2.3.1.2' -and $LevelOne){
        Registry "2.3.1.2 - (L1) Ensure Accounts Block Microsoft accounts is set to Users cant add or log on with Microsoft accounts" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 3
            ValueName = 'NoConnectedUser'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.1.3' -and $LevelOne){
        SecurityOption "2.3.1.3 - (L1) Ensure Accounts Guest account status is set to Disabled (MS only)" {
            Accounts_Guest_account_status = 'Disabled'
            Name = 'Accounts_Guest_account_status'
        }
    }
    if($ExcludeList -notcontains '2.3.1.4' -and $LevelOne){
        Registry "2.3.1.4 - (L1) Ensure Accounts Limit local account use of blank passwords to console logon only is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 1
            ValueName = 'LimitBlankPasswordUse'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.1.5' -and $LevelOne){
        SecurityOption "2.3.1.5 - (L1) Configure Accounts Rename administrator account" {
            Accounts_Rename_administrator_account = $cis2315AccountsRenameadministratoraccount
            Name = 'Accounts_Rename_administrator_account'
        }
    }
    if($ExcludeList -notcontains '2.3.1.6' -and $LevelOne){
        SecurityOption "2.3.1.6 - (L1) Configure Accounts Rename guest account" {
            Accounts_Rename_guest_account = $cis2316AccountsRenameguestaccount
            Name = 'Accounts_Rename_guest_account'
        }
    }
    if($ExcludeList -notcontains '2.3.2.1' -and $LevelOne){
        Registry "2.3.2.1 - (L1) Ensure Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 1
            ValueName = 'SCENoApplyLegacyAuditPolicy'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.2.2' -and $LevelOne){
        Registry "2.3.2.2 - (L1) Ensure Audit Shut down system immediately if unable to log security audits is set to Disabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 0
            ValueName = 'CrashOnAuditFail'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.4.1' -and $LevelOne){
        Registry "2.3.4.1 - (L1) Ensure Devices Allowed to format and eject removable media is set to Administrators" {
            Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueData = "0"
            ValueName = 'AllocateDASD'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '2.3.4.2' -and $LevelOne){
        Registry "2.3.4.2 - (L1) Ensure Devices Prevent users from installing printer drivers is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers'
            ValueData = 1
            ValueName = 'AddPrinterDrivers'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.6.1' -and $LevelOne){
        Registry "2.3.6.1 - (L1) Ensure Domain member Digitally encrypt or sign secure channel data (always) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
            ValueData = 1
            ValueName = 'RequireSignOrSeal'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.6.2' -and $LevelOne){
        Registry "2.3.6.2 - (L1) Ensure Domain member Digitally encrypt secure channel data (when possible) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
            ValueData = 1
            ValueName = 'SealSecureChannel'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.6.3' -and $LevelOne){
        Registry "2.3.6.3 - (L1) Ensure Domain member Digitally sign secure channel data (when possible) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
            ValueData = 1
            ValueName = 'SignSecureChannel'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.6.4' -and $LevelOne){
        Registry "2.3.6.4 - (L1) Ensure Domain member Disable machine account password changes is set to Disabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
            ValueData = 0
            ValueName = 'DisablePasswordChange'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.6.5' -and $LevelOne){
        Registry "2.3.6.5 - (L1) Ensure Domain member Maximum machine account password age is set to 30 or fewer days but not 0" {
            Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
            ValueData = $cis2365MaximumPasswordAge
            ValueName = 'MaximumPasswordAge'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.6.6' -and $LevelOne){
        Registry "2.3.6.6 - (L1) Ensure Domain member Require strong (Windows 2000 or later) session key is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
            ValueData = 1
            ValueName = 'RequireStrongKey'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.7.1' -and $LevelOne){
        Registry "2.3.7.1 - (L1) Ensure Interactive logon Do not display last user name is set to Enabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'DontDisplayLastUserName'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.7.2' -and $LevelOne){
        Registry "2.3.7.2 - (L1) Ensure Interactive logon Do not require CTRLALTDEL is set to Disabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 0
            ValueName = 'DisableCAD'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.7.3' -and $LevelOne){
        Registry "2.3.7.3 - (L1) Ensure Interactive logon Machine inactivity limit is set to 900 or fewer second(s) but not 0" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = $a2373InactivityTimeoutSecs
            ValueName = 'InactivityTimeoutSecs'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.7.4' -and $LevelOne){
        Registry "2.3.7.4 - (L1) Configure Interactive logon Message text for users attempting to log on" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = $a2374LegalNoticeText
            ValueName = 'LegalNoticeText'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '2.3.7.5' -and $LevelOne){
        Registry "2.3.7.5 - (L1) Configure Interactive logon Message title for users attempting to log on" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = $a2375LegalNoticeCaption
            ValueName = 'LegalNoticeCaption'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '2.3.7.6' -and $LevelTwo){
        Registry "2.3.7.6 - (L2) Ensure Interactive logon Number of previous logons to cache (in case domain controller is not available) is set to 4 or fewer logon(s) (MS only)" {
            Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueData = $a2376CachedLogonsCount
            ValueName = 'CachedLogonsCount'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '2.3.7.7' -and $LevelOne){
        Registry "2.3.7.7 - (L1) Ensure Interactive logon Prompt user to change password before expiration is set to between 5 and 14 days" {
            Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueData = 14
            ValueName = 'PasswordExpiryWarning'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.7.8' -and $LevelOne){
        Registry "2.3.7.8 - (L1) Ensure Interactive logon Require Domain Controller Authentication to unlock workstation is set to Enabled (MS only)" {
            Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueData = 1
            ValueName = 'ForceUnlockLogon'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.7.9' -and $LevelOne){
        Registry "2.3.7.9 - (L1) Ensure Interactive logon Smart card removal behavior is set to Lock Workstation or higher" {
            Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueData = "1"
            ValueName = 'ScRemoveOption'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '2.3.8.1' -and $LevelOne){
        Registry "2.3.8.1 - (L1) Ensure Microsoft network client Digitally sign communications (always) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
            ValueData = 1
            ValueName = 'RequireSecuritySignature'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.8.2' -and $LevelOne){
        Registry "2.3.8.2 - (L1) Ensure Microsoft network client Digitally sign communications (if server agrees) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
            ValueData = 1
            ValueName = 'EnableSecuritySignature'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.8.3' -and $LevelOne){
        Registry "2.3.8.3 - (L1) Ensure Microsoft network client Send unencrypted password to third-party SMB servers is set to Disabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
            ValueData = 0
            ValueName = 'EnablePlainTextPassword'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.9.1' -and $LevelOne){
        Registry "2.3.9.1 - (L1) Ensure Microsoft network server Amount of idle time required before suspending session is set to 15 or fewer minute(s)" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = $cis2391AutoDisconnect
            ValueName = 'AutoDisconnect'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.9.2' -and $LevelOne){
        Registry "2.3.9.2 - (L1) Ensure Microsoft network server Digitally sign communications (always) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = 1
            ValueName = 'RequireSecuritySignature'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.9.3' -and $LevelOne){
        Registry "2.3.9.3 - (L1) Ensure Microsoft network server Digitally sign communications (if client agrees) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = 1
            ValueName = 'EnableSecuritySignature'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.9.4' -and $LevelOne){
        Registry "2.3.9.4 - (L1) Ensure Microsoft network server Disconnect clients when logon hours expire is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = 1
            ValueName = 'EnableForcedLogOff'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.9.5' -and $LevelOne){
        Registry "2.3.9.5 - (L1) Ensure Microsoft network server Server SPN target name validation level is set to Accept if provided by client or higher (MS only)" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = 1
            ValueName = 'SmbServerNameHardeningLevel'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.10.1' -and $LevelOne){
        SecurityOption "2.3.10.1 - (L1) Ensure Network access Allow anonymous SIDName translation is set to Disabled" {
            Name = 'Network_access_Allow_anonymous_SID_Name_translation'
            Network_access_Allow_anonymous_SID_Name_translation = 'Disabled'
        }
    }
    if($ExcludeList -notcontains '2.3.10.2' -and $LevelOne){
        Registry "2.3.10.2 - (L1) Ensure Network access Do not allow anonymous enumeration of SAM accounts is set to Enabled (MS only)" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 1
            ValueName = 'RestrictAnonymousSAM'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.10.3' -and $LevelOne){
        Registry "2.3.10.3 - (L1) Ensure Network access Do not allow anonymous enumeration of SAM accounts and shares is set to Enabled (MS only)" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 1
            ValueName = 'RestrictAnonymous'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.10.4' -and $LevelTwo){
        Registry "2.3.10.4 - (L2) Ensure Network access Do not allow storage of passwords and credentials for network authentication is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 1
            ValueName = 'DisableDomainCreds'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.10.5' -and $LevelOne){
        Registry "2.3.10.5 - (L1) Ensure Network access Let Everyone permissions apply to anonymous users is set to Disabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 0
            ValueName = 'EveryoneIncludesAnonymous'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.10.7' -and $LevelOne){
        Registry "2.3.10.7 - (L1) Configure Network access Named Pipes that can be accessed anonymously (MS only)" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = @('')
            ValueName = 'NullSessionPipes'
            ValueType = 'MultiString'
        }
    }
    if($ExcludeList -notcontains '2.3.10.8' -and $LevelOne){
        Registry "2.3.10.8 - (L1) Configure Network access Remotely accessible registry paths" {
            Key = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths'
            ValueData = @('System\CurrentControlSet\Control\ProductOptions','System\CurrentControlSet\Control\Server Applications','Software\Microsoft\Windows NT\CurrentVersion')
            ValueName = 'Machine'
            ValueType = 'MultiString'
        }
    }
    if($ExcludeList -notcontains '2.3.10.9' -and $LevelOne){
        Registry "2.3.10.9 - (L1) Configure Network access Remotely accessible registry paths and sub-paths" {
            Key = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths'
            ValueData = @('Software\Microsoft\Windows NT\CurrentVersion\Print','Software\Microsoft\Windows NT\CurrentVersion\Windows','System\CurrentControlSet\Control\Print\Printers','System\CurrentControlSet\Services\Eventlog','Software\Microsoft\OLAP Server','System\CurrentControlSet\Control\ContentIndex','System\CurrentControlSet\Control\Terminal Server','System\CurrentControlSet\Control\Terminal Server\UserConfig','System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration','Software\Microsoft\Windows NT\CurrentVersion\Perflib','System\CurrentControlSet\Services\SysmonLog')
            ValueName = 'Machine'
            ValueType = 'MultiString'
        }
    }
    if($ExcludeList -notcontains '2.3.10.10' -and $LevelOne){
        Registry "2.3.10.10 - (L1) Ensure Network access Restrict anonymous access to Named Pipes and Shares is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = 1
            ValueName = 'RestrictNullSessAccess'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.10.11' -and $LevelOne){
        Registry "2.3.10.11 - (L1) Ensure Network access Restrict clients allowed to make remote calls to SAM is set to Administrators Remote Access Allow (MS only)" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = "O:BAG:BAD:(A;;RC;;;BA)"
            ValueName = 'RestrictRemoteSAM'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '2.3.10.12' -and $LevelOne){
        Registry "2.3.10.12 - (L1) Ensure Network access Shares that can be accessed anonymously is set to None" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
            ValueData = @('')
            ValueName = 'NullSessionShares'
            ValueType = 'MultiString'
        }
    }
    if($ExcludeList -notcontains '2.3.10.13' -and $LevelOne){
        Registry "2.3.10.13 - (L1) Ensure Network access Sharing and security model for local accounts is set to Classic - local users authenticate as themselves" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 0
            ValueName = 'ForceGuest'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.1' -and $LevelOne){
        Registry "2.3.11.1 - (L1) Ensure Network security Allow Local System to use computer identity for NTLM is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 1
            ValueName = 'UseMachineId'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.2' -and $LevelOne){
        Registry "2.3.11.2 - (L1) Ensure Network security Allow LocalSystem NULL session fallback is set to Disabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
            ValueData = 0
            ValueName = 'allownullsessionfallback'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.3' -and $LevelOne){
        Registry "2.3.11.3 - (L1) Ensure Network Security Allow PKU2U authentication requests to this computer to use online identities is set to Disabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\pku2u'
            ValueData = 0
            ValueName = 'AllowOnlineID'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.4' -and $LevelOne){
        Registry "2.3.11.4 - (L1) Ensure Network security Configure encryption types allowed for Kerberos is set to AES128HMACSHA1 AES256HMACSHA1 Future encryption types" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
            ValueData = 2147483640
            ValueName = 'SupportedEncryptionTypes'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.5' -and $LevelOne){
        Registry "2.3.11.5 - (L1) Ensure Network security Do not store LAN Manager hash value on next password change is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 1
            ValueName = 'NoLMHash'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.6' -and $LevelOne){
        SecurityOption "2.3.11.6 - (L1) Ensure Network security Force logoff when logon hours expire is set to Enabled" {
            Name = 'Network_security_Force_logoff_when_logon_hours_expire'
            Network_security_Force_logoff_when_logon_hours_expire = 'Enabled'
        }
    }
    if($ExcludeList -notcontains '2.3.11.7' -and $LevelOne){
        Registry "2.3.11.7 - (L1) Ensure Network security LAN Manager authentication level is set to Send NTLMv2 response only. Refuse LM  NTLM" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa'
            ValueData = 5
            ValueName = 'LmCompatibilityLevel'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.8' -and $LevelOne){
        Registry "2.3.11.8 - (L1) Ensure Network security LDAP client signing requirements is set to Negotiate signing or higher" {
            Key = 'HKLM:\System\CurrentControlSet\Services\LDAP'
            ValueData = 1
            ValueName = 'LDAPClientIntegrity'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.9' -and $LevelOne){
        Registry "2.3.11.9 - (L1) Ensure Network security Minimum session security for NTLM SSP based (including secure RPC) clients is set to Require NTLMv2 session security Require 128-bit encryption" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
            ValueData = 537395200
            ValueName = 'NTLMMinClientSec'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.11.10' -and $LevelOne){
        Registry "2.3.11.10 - (L1) Ensure Network security Minimum session security for NTLM SSP based (including secure RPC) servers is set to Require NTLMv2 session security Require 128-bit encryption" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
            ValueData = 537395200
            ValueName = 'NTLMMinServerSec'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.13.1' -and $LevelOne){
        Registry "2.3.13.1 - (L1) Ensure Shutdown Allow system to be shut down without having to log on is set to Disabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 0
            ValueName = 'ShutdownWithoutLogon'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.15.1' -and $LevelOne){
        Registry "2.3.15.1 - (L1) Ensure System objects Require case insensitivity for non-Windows subsystems is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel'
            ValueData = 1
            ValueName = 'ObCaseInsensitive'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.15.2' -and $LevelOne){
        Registry "2.3.15.2 - (L1) Ensure System objects Strengthen default permissions of internal system objects (e.g. Symbolic Links) is set to Enabled" {
            Key = 'HKLM:\System\CurrentControlSet\Control\Session Manager'
            ValueData = 1
            ValueName = 'ProtectionMode'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.1' -and $LevelOne){
        Registry "2.3.17.1 - (L1) Ensure User Account Control Admin Approval Mode for the Built-in Administrator account is set to Enabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'FilterAdministratorToken'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.2' -and $LevelOne){
        Registry "2.3.17.2 - (L1) Ensure User Account Control Behavior of the elevation prompt for administrators in Admin Approval Mode is set to Prompt for consent on the secure desktop" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 2
            ValueName = 'ConsentPromptBehaviorAdmin'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.3' -and $LevelOne){
        Registry "2.3.17.3 - (L1) Ensure User Account Control Behavior of the elevation prompt for standard users is set to Automatically deny elevation requests" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 0
            ValueName = 'ConsentPromptBehaviorUser'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.4' -and $LevelOne){
        Registry "2.3.17.4 - (L1) Ensure User Account Control Detect application installations and prompt for elevation is set to Enabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'EnableInstallerDetection'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.5' -and $LevelOne){
        Registry "2.3.17.5 - (L1) Ensure User Account Control Only elevate UIAccess applications that are installed in secure locations is set to Enabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'EnableSecureUIAPaths'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.6' -and $LevelOne){
        Registry "2.3.17.6 - (L1) Ensure User Account Control Run all administrators in Admin Approval Mode is set to Enabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'EnableLUA'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.7' -and $LevelOne){
        Registry "2.3.17.7 - (L1) Ensure User Account Control Switch to the secure desktop when prompting for elevation is set to Enabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'PromptOnSecureDesktop'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '2.3.17.8' -and $LevelOne){
        Registry "2.3.17.8 - (L1) Ensure User Account Control Virtualize file and registry write failures to per-user locations is set to Enabled" {
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'EnableVirtualization'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.1.1' -and $LevelOne){
        Registry "9.1.1 - (L1) Ensure Windows Firewall Domain Firewall state is set to On (recommended)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile'
            ValueData = 1
            ValueName = 'EnableFirewall'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.1.2' -and $LevelOne){
        Registry "9.1.2 - (L1) Ensure Windows Firewall Domain Inbound connections is set to Block (default)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile'
            ValueData = 1
            ValueName = 'DefaultInboundAction'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.1.3' -and $LevelOne){
        Registry "9.1.3 - (L1) Ensure Windows Firewall Domain Outbound connections is set to Allow (default)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile'
            ValueData = 0
            ValueName = 'DefaultOutboundAction'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.1.4' -and $LevelOne){
        Registry "9.1.4 - (L1) Ensure Windows Firewall Domain Settings Display a notification is set to No" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile'
            ValueData = 1
            ValueName = 'DisableNotifications'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.1.5' -and $LevelOne){
        Registry "9.1.5 - (L1) Ensure Windows Firewall Domain Logging Name is set to SystemRootSystem32logfilesfirewalldomainfw.log" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
            ValueData = '%systemroot%\system32\logfiles\firewall\domainfw.log'
            ValueName = 'LogFilePath'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '9.1.6' -and $LevelOne){
        Registry "9.1.6 - (L1) Ensure Windows Firewall Domain Logging Size limit (KB) is set to 16384 KB or greater" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
            ValueData = $cis916LogFileSize
            ValueName = 'LogFileSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.1.7' -and $LevelOne){
        Registry "9.1.7 - (L1) Ensure Windows Firewall Domain Logging Log dropped packets is set to Yes" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
            ValueData = 1
            ValueName = 'LogDroppedPackets'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.1.8' -and $LevelOne){
        Registry "9.1.8 - (L1) Ensure Windows Firewall Domain Logging Log successful connections is set to Yes" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging'
            ValueData = 1
            ValueName = 'LogSuccessfulConnections'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.2.1' -and $LevelOne){
        Registry "9.2.1 - (L1) Ensure Windows Firewall Private Firewall state is set to On (recommended)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile'
            ValueData = 1
            ValueName = 'EnableFirewall'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.2.2' -and $LevelOne){
        Registry "9.2.2 - (L1) Ensure Windows Firewall Private Inbound connections is set to Block (default)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile'
            ValueData = 1
            ValueName = 'DefaultInboundAction'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.2.3' -and $LevelOne){
        Registry "9.2.3 - (L1) Ensure Windows Firewall Private Outbound connections is set to Allow (default)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile'
            ValueData = 0
            ValueName = 'DefaultOutboundAction'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.2.4' -and $LevelOne){
        Registry "9.2.4 - (L1) Ensure Windows Firewall Private Settings Display a notification is set to No" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile'
            ValueData = 1
            ValueName = 'DisableNotifications'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.2.5' -and $LevelOne){
        Registry "9.2.5 - (L1) Ensure Windows Firewall Private Logging Name is set to SystemRootSystem32logfilesfirewallprivatefw.log" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
            ValueData = '%systemroot%\system32\logfiles\firewall\privatefw.log'
            ValueName = 'LogFilePath'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '9.2.6' -and $LevelOne){
        Registry "9.2.6 - (L1) Ensure Windows Firewall Private Logging Size limit (KB) is set to 16384 KB or greater" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
            ValueData = $cis926LogFileSize
            ValueName = 'LogFileSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.2.7' -and $LevelOne){
        Registry "9.2.7 - (L1) Ensure Windows Firewall Private Logging Log dropped packets is set to Yes" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
            ValueData = 1
            ValueName = 'LogDroppedPackets'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.2.8' -and $LevelOne){
        Registry "9.2.8 - (L1) Ensure Windows Firewall Private Logging Log successful connections is set to Yes" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
            ValueData = 1
            ValueName = 'LogSuccessfulConnections'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.1' -and $LevelOne){
        Registry "9.3.1 - (L1) Ensure Windows Firewall Public Firewall state is set to On (recommended)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueData = 1
            ValueName = 'EnableFirewall'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.2' -and $LevelOne){
        Registry "9.3.2 - (L1) Ensure Windows Firewall Public Inbound connections is set to Block (default)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueData = 1
            ValueName = 'DefaultInboundAction'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.3' -and $LevelOne){
        Registry "9.3.3 - (L1) Ensure Windows Firewall Public Outbound connections is set to Allow (default)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueData = 0
            ValueName = 'DefaultOutboundAction'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.4' -and $LevelOne){
        Registry "9.3.4 - (L1) Ensure Windows Firewall Public Settings Display a notification is set to No" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueData = 1
            ValueName = 'DisableNotifications'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.5' -and $LevelOne){
        Registry "9.3.5 - (L1) Ensure Windows Firewall Public Settings Apply local firewall rules is set to No" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueData = 0
            ValueName = 'AllowLocalPolicyMerge'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.6' -and $LevelOne){
        Registry "9.3.6 - (L1) Ensure Windows Firewall Public Settings Apply local connection security rules is set to No" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'
            ValueData = 0
            ValueName = 'AllowLocalIPsecPolicyMerge'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.7' -and $LevelOne){
        Registry "9.3.7 - (L1) Ensure Windows Firewall Public Logging Name is set to SystemRootSystem32logfilesfirewallpublicfw.log" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
            ValueData = '%systemroot%\system32\logfiles\firewall\publicfw.log'
            ValueName = 'LogFilePath'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '9.3.8' -and $LevelOne){
        Registry "9.3.8 - (L1) Ensure Windows Firewall Public Logging Size limit (KB) is set to 16384 KB or greater" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
            ValueData = $cis938LogFileSize
            ValueName = 'LogFileSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.9' -and $LevelOne){
        Registry "9.3.9 - (L1) Ensure Windows Firewall Public Logging Log dropped packets is set to Yes" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
            ValueData = 1
            ValueName = 'LogDroppedPackets'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '9.3.10' -and $LevelOne){
        Registry "9.3.10 - (L1) Ensure Windows Firewall Public Logging Log successful connections is set to Yes" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging'
            ValueData = 1
            ValueName = 'LogSuccessfulConnections'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '17.1.1' -and $LevelOne){
        AuditPolicySubcategory "17.1.1 - (L1) Ensure Audit Credential Validation is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Credential Validation'
        }
        AuditPolicySubcategory "17.1.1 - (L1) Ensure Audit Credential Validation is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Credential Validation'
        }
    }
    if($ExcludeList -notcontains '17.2.1' -and $LevelOne){
        AuditPolicySubcategory "17.2.1 - (L1) Ensure Audit Application Group Management is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Application Group Management'
        }
        AuditPolicySubcategory "17.2.1 - (L1) Ensure Audit Application Group Management is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Application Group Management'
        }
    }
    if($ExcludeList -notcontains '17.2.5' -and $LevelOne){
        AuditPolicySubcategory "17.2.5 - (L1) Ensure Audit Security Group Management is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Security Group Management'
        }
        AuditPolicySubcategory "17.2.5 - (L1) Ensure Audit Security Group Management is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Security Group Management'
        }
    }
    if($ExcludeList -notcontains '17.2.6' -and $LevelOne){
        AuditPolicySubcategory "17.2.6 - (L1) Ensure Audit User Account Management is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'User Account Management'
        }
        AuditPolicySubcategory "17.2.6 - (L1) Ensure Audit User Account Management is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'User Account Management'
        }
    }
    if($ExcludeList -notcontains '17.3.1' -and $LevelOne){
        AuditPolicySubcategory "17.3.1 - (L1) Ensure Audit PNP Activity is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Plug and Play Events'
        }
        AuditPolicySubcategory "17.3.1 - (L1) Ensure Audit PNP Activity is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Plug and Play Events'
        }
    }
    if($ExcludeList -notcontains '17.3.2' -and $LevelOne){
        AuditPolicySubcategory "17.3.2 - (L1) Ensure Audit Process Creation is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Process Creation'
        }
        AuditPolicySubcategory "17.3.2 - (L1) Ensure Audit Process Creation is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Process Creation'
        }
    }
    if($ExcludeList -notcontains '17.5.1' -and $LevelOne){
        AuditPolicySubcategory "17.5.1 - (L1) Ensure Audit Account Lockout is set to include Failure (1)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Account Lockout'
        }
        AuditPolicySubcategory "17.5.1 - (L1) Ensure Audit Account Lockout is set to include Failure (2)" {
            AuditFlag = 'Success'
            Ensure = 'Absent'
            Name = 'Account Lockout'
        }
    }
    if($ExcludeList -notcontains '17.5.2' -and $LevelOne){
        AuditPolicySubcategory "17.5.2 - (L1) Ensure Audit Group Membership is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Group Membership'
        }
        AuditPolicySubcategory "17.5.2 - (L1) Ensure Audit Group Membership is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Group Membership'
        }
    }
    if($ExcludeList -notcontains '17.5.3' -and $LevelOne){
        AuditPolicySubcategory "17.5.3 - (L1) Ensure Audit Logoff is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Logoff'
        }
        AuditPolicySubcategory "17.5.3 - (L1) Ensure Audit Logoff is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Logoff'
        }
    }
    if($ExcludeList -notcontains '17.5.4' -and $LevelOne){
        AuditPolicySubcategory "17.5.4 - (L1) Ensure Audit Logon is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Logon'
        }
        AuditPolicySubcategory "17.5.4 - (L1) Ensure Audit Logon is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Logon'
        }
    }
    if($ExcludeList -notcontains '17.5.5' -and $LevelOne){
        AuditPolicySubcategory "17.5.5 - (L1) Ensure Audit Other LogonLogoff Events is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Other Logon/Logoff Events'
        }
        AuditPolicySubcategory "17.5.5 - (L1) Ensure Audit Other LogonLogoff Events is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Other Logon/Logoff Events'
        }
    }
    if($ExcludeList -notcontains '17.5.6' -and $LevelOne){
        AuditPolicySubcategory "17.5.6 - (L1) Ensure Audit Special Logon is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Special Logon'
        }
        AuditPolicySubcategory "17.5.6 - (L1) Ensure Audit Special Logon is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Special Logon'
        }
    }
    if($ExcludeList -notcontains '17.6.1' -and $LevelOne){
        AuditPolicySubcategory "17.6.1 - (L1) Ensure Audit Detailed File Share is set to include Failure (1)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Detailed File Share'
        }
        AuditPolicySubcategory "17.6.1 - (L1) Ensure Audit Detailed File Share is set to include Failure (2)" {
            AuditFlag = 'Success'
            Ensure = 'Absent'
            Name = 'Detailed File Share'
        }
    }
    if($ExcludeList -notcontains '17.6.2' -and $LevelOne){
        AuditPolicySubcategory "17.6.2 - (L1) Ensure Audit File Share is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'File Share'
        }
        AuditPolicySubcategory "17.6.2 - (L1) Ensure Audit File Share is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'File Share'
        }
    }
    if($ExcludeList -notcontains '17.6.3' -and $LevelOne){
        AuditPolicySubcategory "17.6.3 - (L1) Ensure Audit Other Object Access Events is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Other Object Access Events'
        }
        AuditPolicySubcategory "17.6.3 - (L1) Ensure Audit Other Object Access Events is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Other Object Access Events'
        }
    }
    if($ExcludeList -notcontains '17.6.4' -and $LevelOne){
        AuditPolicySubcategory "17.6.4 - (L1) Ensure Audit Removable Storage is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Removable Storage'
        }
        AuditPolicySubcategory "17.6.4 - (L1) Ensure Audit Removable Storage is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Removable Storage'
        }
    }
    if($ExcludeList -notcontains '17.7.1' -and $LevelOne){
        AuditPolicySubcategory "17.7.1 - (L1) Ensure Audit Audit Policy Change is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Audit Policy Change'
        }
        AuditPolicySubcategory "17.7.1 - (L1) Ensure Audit Audit Policy Change is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Audit Policy Change'
        }
    }
    if($ExcludeList -notcontains '17.7.2' -and $LevelOne){
        AuditPolicySubcategory "17.7.2 - (L1) Ensure Audit Authentication Policy Change is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Authentication Policy Change'
        }
        AuditPolicySubcategory "17.7.2 - (L1) Ensure Audit Authentication Policy Change is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Authentication Policy Change'
        }
    }
    if($ExcludeList -notcontains '17.7.3' -and $LevelOne){
        AuditPolicySubcategory "17.7.3 - (L1) Ensure Audit Authorization Policy Change is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Authorization Policy Change'
        }
        AuditPolicySubcategory "17.7.3 - (L1) Ensure Audit Authorization Policy Change is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Authorization Policy Change'
        }
    }
    if($ExcludeList -notcontains '17.7.4' -and $LevelOne){
        AuditPolicySubcategory "17.7.4 - (L1) Ensure Audit MPSSVC Rule-Level Policy Change is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'MPSSVC Rule-Level Policy Change'
        }
        AuditPolicySubcategory "17.7.4 - (L1) Ensure Audit MPSSVC Rule-Level Policy Change is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'MPSSVC Rule-Level Policy Change'
        }
    }
    if($ExcludeList -notcontains '17.7.5' -and $LevelOne){
        AuditPolicySubcategory "17.7.5 - (L1) Ensure Audit Other Policy Change Events is set to include Failure (1)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Other Policy Change Events'
        }
        AuditPolicySubcategory "17.7.5 - (L1) Ensure Audit Other Policy Change Events is set to include Failure (2)" {
            AuditFlag = 'Success'
            Ensure = 'Absent'
            Name = 'Other Policy Change Events'
        }
    }
    if($ExcludeList -notcontains '17.8.1' -and $LevelOne){
        AuditPolicySubcategory "17.8.1 - (L1) Ensure Audit Sensitive Privilege Use is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Sensitive Privilege Use'
        }
        AuditPolicySubcategory "17.8.1 - (L1) Ensure Audit Sensitive Privilege Use is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Sensitive Privilege Use'
        }
    }
    if($ExcludeList -notcontains '17.9.1' -and $LevelOne){
        AuditPolicySubcategory "17.9.1 - (L1) Ensure Audit IPsec Driver is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'IPsec Driver'
        }
        AuditPolicySubcategory "17.9.1 - (L1) Ensure Audit IPsec Driver is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'IPsec Driver'
        }
    }
    if($ExcludeList -notcontains '17.9.2' -and $LevelOne){
        AuditPolicySubcategory "17.9.2 - (L1) Ensure Audit Other System Events is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Other System Events'
        }
        AuditPolicySubcategory "17.9.2 - (L1) Ensure Audit Other System Events is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'Other System Events'
        }
    }
    if($ExcludeList -notcontains '17.9.3' -and $LevelOne){
        AuditPolicySubcategory "17.9.3 - (L1) Ensure Audit Security State Change is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Security State Change'
        }
        AuditPolicySubcategory "17.9.3 - (L1) Ensure Audit Security State Change is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Security State Change'
        }
    }
    if($ExcludeList -notcontains '17.9.4' -and $LevelOne){
        AuditPolicySubcategory "17.9.4 - (L1) Ensure Audit Security System Extension is set to include Success (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'Security System Extension'
        }
        AuditPolicySubcategory "17.9.4 - (L1) Ensure Audit Security System Extension is set to include Success (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Absent'
            Name = 'Security System Extension'
        }
    }
    if($ExcludeList -notcontains '17.9.5' -and $LevelOne){
        AuditPolicySubcategory "17.9.5 - (L1) Ensure Audit System Integrity is set to Success and Failure (1)" {
            AuditFlag = 'Success'
            Ensure = 'Present'
            Name = 'System Integrity'
        }
        AuditPolicySubcategory "17.9.5 - (L1) Ensure Audit System Integrity is set to Success and Failure (2)" {
            AuditFlag = 'Failure'
            Ensure = 'Present'
            Name = 'System Integrity'
        }
    }
    if($ExcludeList -notcontains '18.1.1.1' -and $LevelOne){
        Registry "18.1.1.1 - (L1) Ensure Prevent enabling lock screen camera is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
            ValueData = 1
            ValueName = 'NoLockScreenCamera'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.1.1.2' -and $LevelOne){
        Registry "18.1.1.2 - (L1) Ensure Prevent enabling lock screen slide show is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
            ValueData = 1
            ValueName = 'NoLockScreenSlideshow'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.1.2.2' -and $LevelOne){
        Registry "18.1.2.2 - (L1) Ensure Allow users to enable online speech recognition services is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization'
            ValueData = 0
            ValueName = 'AllowInputPersonalization'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.1.3' -and $LevelTwo){
        Registry "18.1.3 - (L2) Ensure Allow Online Tips is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            ValueData = 0
            ValueName = 'AllowOnlineTips'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.2.2' -and $LevelOne){
        Registry "18.2.2 - (L1) Ensure Do not allow password expiration time longer than required by policy is set to Enabled (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft Services\AdmPwd'
            ValueData = 1
            ValueName = 'PwdExpirationProtectionEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.2.3' -and $LevelOne){
        Registry "18.2.3 - (L1) Ensure Enable Local Admin Password Management is set to Enabled (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft Services\AdmPwd'
            ValueData = 1
            ValueName = 'AdmPwdEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.2.4' -and $LevelOne){
        Registry "18.2.4 - (L1) Ensure Password Settings Password Complexity is set to Enabled Large letters  small letters  numbers  special characters (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft Services\AdmPwd'
            ValueData = 4
            ValueName = 'PasswordComplexity'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.2.5' -and $LevelOne){
        Registry "18.2.5 - (L1) Ensure Password Settings Password Length is set to Enabled 15 or more (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft Services\AdmPwd'
            ValueData = $cis1825PasswordLength
            ValueName = 'PasswordLength'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.2.6' -and $LevelOne){
        Registry "18.2.6 - (L1) Ensure Password Settings Password Age (Days) is set to Enabled 30 or fewer (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft Services\AdmPwd'
            ValueData = $cis1826PasswordAgeDays
            ValueName = 'PasswordAgeDays'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.3.1' -and $LevelOne){
        Registry "18.3.1 - (L1) Ensure Apply UAC restrictions to local accounts on network logons is set to Enabled (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 0
            ValueName = 'LocalAccountTokenFilterPolicy'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.3.2' -and $LevelOne){
        Registry "18.3.2 - (L1) Ensure Configure SMB v1 client driver is set to Enabled Disable driver (recommended)" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\MrxSmb10'
            ValueData = 4
            ValueName = 'Start'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.3.3' -and $LevelOne){
        Registry "18.3.3 - (L1) Ensure Configure SMB v1 server is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
            ValueData = 0
            ValueName = 'SMB1'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.3.4' -and $LevelOne){
        Registry "18.3.4 - (L1) Ensure Enable Structured Exception Handling Overwrite Protection (SEHOP) is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel'
            ValueData = 0
            ValueName = 'DisableExceptionChainValidation'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.3.6' -and $LevelOne){
        Registry "18.3.6 - (L1) Ensure NetBT NodeType configuration is set to Enabled P-node (recommended)" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters'
            ValueData = 2
            ValueName = 'NodeType'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.3.7' -and $LevelOne){
        Registry "18.3.7 - (L1) Ensure WDigest Authentication is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest'
            ValueData = 0
            ValueName = 'UseLogonCredential'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.1' -and $LevelOne){
        Registry "18.4.1 - (L1) Ensure MSS (AutoAdminLogon) Enable Automatic Logon (not recommended) is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueData = '0'
            ValueName = 'AutoAdminLogon'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.4.2' -and $LevelOne){
        Registry "18.4.2 - (L1) Ensure MSS (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing) is set to Enabled Highest protection source routing is completely disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
            ValueData = 2
            ValueName = 'DisableIPSourceRouting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.3' -and $LevelOne){
        Registry "18.4.3 - (L1) Ensure MSS (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing) is set to Enabled Highest protection source routing is completely disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
            ValueData = 2
            ValueName = 'DisableIPSourceRouting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.4' -and $LevelOne){
        Registry "18.4.4 - (L1) Ensure MSS (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
            ValueData = 0
            ValueName = 'EnableICMPRedirect'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.5' -and $LevelTwo){
        Registry "18.4.5 - (L2) Ensure MSS (KeepAliveTime) How often keep-alive packets are sent in milliseconds is set to Enabled 300000 or 5 minutes (recommended)" {
            Ensure = 'Present'
            Key = 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters'
            ValueData = 300000
            ValueName = 'KeepAliveTime'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.6' -and $LevelOne){
        Registry "18.4.6 - (L1) Ensure MSS (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters'
            ValueData = 1
            ValueName = 'NoNameReleaseOnDemand'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.7' -and $LevelTwo){
        Registry "18.4.7 - (L2) Ensure MSS (PerformRouterDiscovery) Allow IRDP to detect and configure Default Gateway addresses (could lead to DoS) is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters'
            ValueData = 0
            ValueName = 'PerformRouterDiscovery'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.8' -and $LevelOne){
        Registry "18.4.8 - (L1) Ensure MSS (SafeDllSearchMode) Enable Safe DLL search mode (recommended) is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
            ValueData = 1
            ValueName = 'SafeDllSearchMode'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.9' -and $LevelOne){
        Registry "18.4.9 - (L1) Ensure MSS (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 recommended) is set to Enabled 5 or fewer seconds" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueData = $a1849ScreenSaverGracePeriod
            ValueName = 'ScreenSaverGracePeriod'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.4.10' -and $LevelTwo){
        Registry "18.4.10 - (L2) Ensure MSS (TcpMaxDataRetransmissions IPv6) How many times unacknowledged data is retransmitted is set to Enabled 3" {
            Ensure = 'Present'
            Key = 'HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters'
            ValueData = 3
            ValueName = 'TcpMaxDataRetransmissions'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.11' -and $LevelTwo){
        Registry "18.4.11 - (L2) Ensure MSS (TcpMaxDataRetransmissions) How many times unacknowledged data is retransmitted is set to Enabled 3" {
            Ensure = 'Present'
            Key = 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters'
            ValueData = 3
            ValueName = 'TcpMaxDataRetransmissions'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.4.12' -and $LevelOne){
        Registry "18.4.12 - (L1) Ensure MSS (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning is set to Enabled 90 or less" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Services\Eventlog\Security'
            ValueData = $a18412WarningLevel
            ValueName = 'WarningLevel'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.4.1' -and $LevelOne){
        Registry "18.5.4.1 - (L1) Ensure Turn off multicast name resolution is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'
            ValueData = 0
            ValueName = 'EnableMulticast'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.5.1' -and $LevelTwo){
        Registry "18.5.5.1 - (L2) Ensure Enable Font Providers is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\System'
            ValueData = 0
            ValueName = 'EnableFontProviders'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.8.1' -and $LevelOne){
        Registry "18.5.8.1 - (L1) Ensure Enable insecure guest logons is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation'
            ValueData = 0
            ValueName = 'AllowInsecureGuestAuth'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.9.1' -and $LevelTwo){
        Registry "18.5.9.1 - (L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'EnableLLTDIO'
            ValueType = 'Dword'
        }
        Registry "18.5.9.1 - (L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'AllowLLTDIOOnDomain'
            ValueType = 'Dword'
        }
        Registry "18.5.9.1 - (L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled (3)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'AllowLLTDIOOnPublicNet'
            ValueType = 'Dword'
        }
        Registry "18.5.9.1 - (L2) Ensure Turn on Mapper IO (LLTDIO) driver is set to Disabled (4)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'ProhibitLLTDIOOnPrivateNet'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.9.2' -and $LevelTwo){
        Registry "18.5.9.2 - (L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'EnableRspndr'
            ValueType = 'Dword'
        }
        Registry "18.5.9.2 - (L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'AllowRspndrOnDomain'
            ValueType = 'Dword'
        }
        Registry "18.5.9.2 - (L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled (3)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'AllowRspndrOnPublicNet'
            ValueType = 'Dword'
        }
        Registry "18.5.9.2 - (L2) Ensure Turn on Responder (RSPNDR) driver is set to Disabled (4)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LLTD'
            ValueData = 0
            ValueName = 'ProhibitRspndrOnPrivateNet'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.10.2' -and $LevelTwo){
        Registry "18.5.10.2 - (L2) Ensure Turn off Microsoft Peer-to-Peer Networking Services is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Peernet'
            ValueData = 1
            ValueName = 'Disabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.11.2' -and $LevelOne){
        Registry "18.5.11.2 - (L1) Ensure Prohibit installation and configuration of Network Bridge on your DNS domain network is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections'
            ValueData = 0
            ValueName = 'NC_AllowNetBridge_NLA'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.11.3' -and $LevelOne){
        Registry "18.5.11.3 - (L1) Ensure Prohibit use of Internet Connection Sharing on your DNS domain network is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections'
            ValueData = 0
            ValueName = 'NC_ShowSharedAccessUI'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.11.4' -and $LevelOne){
        Registry "18.5.11.4 - (L1) Ensure Require domain users to elevate when setting a networks location is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections'
            ValueData = 1
            ValueName = 'NC_StdDomainUserSetLocation'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.14.1' -and $LevelOne){
        Registry "18.5.14.1 - (L1) Ensure Hardened UNC Paths is set to Enabled with Require Mutual Authentication and Require Integrity set for all NETLOGON and SYSVOL shares (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
            ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'
            ValueName = '\\*\NETLOGON'
            ValueType = 'String'
        }
        Registry "18.5.14.1 - (L1) Ensure Hardened UNC Paths is set to Enabled with Require Mutual Authentication and Require Integrity set for all NETLOGON and SYSVOL shares (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths'
            ValueData = 'RequireMutualAuthentication=1, RequireIntegrity=1'
            ValueName = '\\*\SYSVOL'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.5.19.2.1' -and $LevelTwo){
        Registry "18.5.19.2.1 - (L2) Disable IPv6 (Ensure TCPIP6 Parameter DisabledComponents is set to 0xff (255))" {
            Ensure = 'Present'
            Key = 'HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters'
            ValueData = 255
            ValueName = 'DisabledComponents'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.20.1' -and $LevelTwo){
        Registry "18.5.20.1 - (L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
            ValueData = 0
            ValueName = 'EnableRegistrars'
            ValueType = 'Dword'
        }
        Registry "18.5.20.1 - (L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
            ValueData = 0
            ValueName = 'DisableUPnPRegistrar'
            ValueType = 'Dword'
        }
        Registry "18.5.20.1 - (L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (3)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
            ValueData = 0
            ValueName = 'DisableInBand802DOT11Registrar'
            ValueType = 'Dword'
        }
        Registry "18.5.20.1 - (L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (4)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
            ValueData = 0
            ValueName = 'DisableFlashConfigRegistrar'
            ValueType = 'Dword'
        }
        Registry "18.5.20.1 - (L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (5)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
            ValueData = 0
            ValueName = 'DisableWPDRegistrar'
            ValueType = 'Dword'
        }
        Registry "18.5.20.1 - (L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (6)" {
            Ensure = 'Absent'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
            ValueName = 'MaxWCNDeviceNumber'
        }
        Registry "18.5.20.1 - (L2) Ensure Configuration of wireless settings using Windows Connect Now is set to Disabled (7)" {
            Ensure = 'Absent'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\Registrars'
            ValueName = 'HigherPrecedenceRegistrar'
        }
    }
    if($ExcludeList -notcontains '18.5.20.2' -and $LevelTwo){
        Registry "18.5.20.2 - (L2) Ensure Prohibit access of the Windows Connect Now wizards is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WCN\UI'
            ValueData = 1
            ValueName = 'DisableWcnUi'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.21.1' -and $LevelOne){
        Registry "18.5.21.1 - (L1) Ensure Minimize the number of simultaneous connections to the Internet or a Windows Domain is set to Enabled 1  Minimize simultaneous connections" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy'
            ValueData = 1
            ValueName = 'fMinimizeConnections'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.5.21.2' -and $LevelTwo){
        Registry "18.5.21.2 - (L2) Ensure Prohibit connection to non-domain networks when connected to domain authenticated network is set to Enabled (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy'
            ValueData = 1
            ValueName = 'fBlockNonDomain'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.7.1.1' -and $LevelTwo){
        Registry "18.7.1.1 - (L2) Ensure Turn off notifications network usage is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'
            ValueData = 1
            ValueName = 'NoCloudApplicationNotification'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.3.1' -and $LevelOne){
        Registry "18.8.3.1 - (L1) Ensure Include command line in process creation events is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit'
            ValueData = 0
            ValueName = 'ProcessCreationIncludeCmdLine_Enabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.4.1' -and $LevelOne){
        Registry "18.8.4.1 - (L1) Ensure Encryption Oracle Remediation is set to Enabled Force Updated Clients" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters'
            ValueData = 0
            ValueName = 'AllowEncryptionOracle'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.4.2' -and $LevelOne){
        Registry "18.8.4.2 - (L1) Ensure Remote host allows delegation of non-exportable credentials is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation'
            ValueData = 1
            ValueName = 'AllowProtectedCreds'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.5.1' -and $NextGenerationWindowsSecurity){
        Registry "18.8.5.1 - (NG) Ensure Turn On Virtualization Based Security is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
            ValueData = 1
            ValueName = 'EnableVirtualizationBasedSecurity'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.5.2' -and $NextGenerationWindowsSecurity){
        Registry "18.8.5.2 - (NG) Ensure Turn On Virtualization Based Security Select Platform Security Level is set to Secure Boot and DMA Protection" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
            ValueData = 3
            ValueName = 'RequirePlatformSecurityFeatures'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.5.3' -and $NextGenerationWindowsSecurity){
        Registry "18.8.5.3 - (NG) Ensure Turn On Virtualization Based Security Virtualization Based Protection of Code Integrity is set to Enabled with UEFI lock" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
            ValueData = 1
            ValueName = 'HypervisorEnforcedCodeIntegrity'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.5.4' -and $NextGenerationWindowsSecurity){
        Registry "18.8.5.4 - (NG) Ensure Turn On Virtualization Based Security Require UEFI Memory Attributes Table is set to True (checked)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
            ValueData = 1
            ValueName = 'HVCIMATRequired'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.5.6' -and $NextGenerationWindowsSecurity){
        Registry "18.8.5.6 - (NG) Ensure Turn On Virtualization Based Security Credential Guard Configuration is set to Disabled (DC Only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
            ValueData = 1
            ValueName = 'LsaCfgFlags'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.5.7' -and $NextGenerationWindowsSecurity){
        Registry "18.8.5.7 - (NG) Ensure Turn On Virtualization Based Security Secure Launch Configuration is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard'
            ValueData = 1
            ValueName = 'ConfigureSystemGuardLaunch'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.14.1' -and $LevelOne){
        Registry "18.8.14.1 - (L1) Ensure Boot-Start Driver Initialization Policy is set to Enabled Good unknown and bad but critical" {
            Ensure = 'Present'
            Key = 'HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch'
            ValueData = 3
            ValueName = 'DriverLoadPolicy'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.21.2' -and $LevelOne){
        Registry "18.8.21.2 - (L1) Ensure Configure registry policy processing Do not apply during periodic background processing is set to Enabled FALSE" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
            ValueData = 0
            ValueName = 'NoBackgroundPolicy'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.21.3' -and $LevelOne){
        Registry "18.8.21.3 - (L1) Ensure Configure registry policy processing Process even if the Group Policy objects have not changed is set to Enabled TRUE" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}'
            ValueData = 0
            ValueName = 'NoGPOListChanges'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.21.4' -and $LevelOne){
        Registry "18.8.21.4 - (L1) Ensure Continue experiences on this device is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 0
            ValueName = 'EnableCdp'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.21.5' -and $LevelOne){
        Registry "18.8.21.5 - (L1) Ensure Turn off background refresh of Group Policy is set to Disabled" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'DisableBkGndGroupPolicy'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.1' -and $LevelOne){
        Registry "18.8.22.1.1 - (L1) Ensure Turn off downloading of print drivers over HTTP is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers'
            ValueData = 1
            ValueName = 'DisableWebPnPDownload'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.2' -and $LevelTwo){
        Registry "18.8.22.1.2 - (L2) Ensure Turn off handwriting personalization data sharing is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC'
            ValueData = 1
            ValueName = 'PreventHandwritingDataSharing'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.3' -and $LevelTwo){
        Registry "18.8.22.1.3 - (L2) Ensure Turn off handwriting recognition error reporting is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports'
            ValueData = 1
            ValueName = 'PreventHandwritingErrorReports'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.4' -and $LevelTwo){
        Registry "18.8.22.1.4 - (L2) Ensure Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\Internet Connection Wizard'
            ValueData = 1
            ValueName = 'ExitOnMSICW'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.5' -and $LevelOne){
        Registry "18.8.22.1.5 - (L1) Ensure Turn off Internet download for Web publishing and online ordering wizards is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            ValueData = 1
            ValueName = 'NoWebServices'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.6' -and $LevelTwo){
        Registry "18.8.22.1.6 - (L2) Ensure Turn off printing over HTTP is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers'
            ValueData = 1
            ValueName = 'DisableHTTPPrinting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.7' -and $LevelTwo){
        Registry "18.8.22.1.7 - (L2) Ensure Turn off Registration if URL connection is referring to Microsoft.com is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\Registration Wizard Control'
            ValueData = 1
            ValueName = 'NoRegistration'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.8' -and $LevelTwo){
        Registry "18.8.22.1.8 - (L2) Ensure Turn off Search Companion content file updates is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\SearchCompanion'
            ValueData = 1
            ValueName = 'DisableContentFileUpdates'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.9' -and $LevelTwo){
        Registry "18.8.22.1.9 - (L2) Ensure Turn off the Order Prints picture task is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            ValueData = 1
            ValueName = 'NoOnlinePrintsWizard'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.10' -and $LevelTwo){
        Registry "18.8.22.1.10 - (L2) Ensure Turn off the Publish to Web task for files and folders is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            ValueData = 1
            ValueName = 'NoPublishingWizard'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.11' -and $LevelTwo){
        Registry "18.8.22.1.11 - (L2) Ensure Turn off the Windows Messenger Customer Experience Improvement Program is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Messenger\Client'
            ValueData = 2
            ValueName = 'CEIP'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.12' -and $LevelTwo){
        Registry "18.8.22.1.12 - (L2) Ensure Turn off Windows Customer Experience Improvement Program is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows'
            ValueData = 0
            ValueName = 'CEIPEnable'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.22.1.13' -and $LevelTwo){
        Registry "18.8.22.1.13 - (L2) Ensure Turn off Windows Error Reporting is set to Enabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting'
            ValueData = 0
            ValueName = 'DoReport'
            ValueType = 'Dword'
        }
        Registry "18.8.22.1.13 - (L2) Ensure Turn off Windows Error Reporting is set to Enabled (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting'
            ValueData = 1
            ValueName = 'Disabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.25.1' -and $LevelTwo){
        Registry "18.8.25.1 - (L2) Ensure Support device authentication using certificate is set to Enabled Automatic (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
            ValueData = 1
            ValueName = 'DevicePKInitEnabled'
            ValueType = 'Dword'
        }
        Registry "18.8.25.1 - (L2) Ensure Support device authentication using certificate is set to Enabled Automatic (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
            ValueData = 0
            ValueName = 'DevicePKInitBehavior'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.27.1' -and $LevelTwo){
        Registry "18.8.27.1 - (L2) Ensure Disallow copying of user input methods to the system account for sign-in is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Control Panel\International'
            ValueData = 1
            ValueName = 'BlockUserInputMethodsForSignIn'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.28.1' -and $LevelOne){
        Registry "18.8.28.1 - (L1) Ensure Block user from showing account details on sign-in is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 1
            ValueName = 'BlockUserFromShowingAccountDetailsOnSignin'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.28.2' -and $LevelOne){
        Registry "18.8.28.2 - (L1) Ensure Do not display network selection UI is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 1
            ValueName = 'DontDisplayNetworkSelectionUI'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.28.3' -and $LevelOne){
        Registry "18.8.28.3 - (L1) Ensure Do not enumerate connected users on domain-joined computers is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 1
            ValueName = 'DontEnumerateConnectedUsers'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.28.4' -and $LevelOne){
        Registry "18.8.28.4 - (L1) Ensure Enumerate local users on domain-joined computers is set to Disabled (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 0
            ValueName = 'EnumerateLocalUsers'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.28.5' -and $LevelOne){
        Registry "18.8.28.5 - (L1) Ensure Turn off app notifications on the lock screen is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 1
            ValueName = 'DisableLockScreenAppNotifications'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.28.6' -and $LevelOne){
        Registry "18.8.28.6 - (L1) Ensure Turn off picture password sign-in is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 1
            ValueName = 'BlockDomainPicturePassword'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.28.7' -and $LevelOne){
        Registry "18.8.28.7 - (L1) Ensure Turn on convenience PIN sign-in is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 0
            ValueName = 'AllowDomainPINLogon'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.1' -and $LevelTwo){
        Registry "18.8.34.6.1 - (L2) Ensure Allow network connectivity during connected-standby (on battery) is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9'
            ValueData = 0
            ValueName = 'DCSettingIndex'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.2' -and $LevelTwo){
        Registry "18.8.34.6.2 - (L2) Ensure Allow network connectivity during connected-standby (plugged in) is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9'
            ValueData = 0
            ValueName = 'ACSettingIndex'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.3' -and $LevelOne){
        Registry "18.8.34.6.3 - (L1) Ensure Require a password when a computer wakes (on battery) is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
            ValueData = 1
            ValueName = 'DCSettingIndex'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.34.6.4' -and $LevelOne){
        Registry "18.8.34.6.4 - (L1) Ensure Require a password when a computer wakes (plugged in) is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
            ValueData = 1
            ValueName = 'ACSettingIndex'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.36.1' -and $LevelOne){
        Registry "18.8.36.1 - (L1) Ensure Configure Offer Remote Assistance is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 0
            ValueName = 'fAllowUnsolicited'
            ValueType = 'Dword'
        }
        Registry "18.8.36.1 - (L1) Ensure Configure Offer Remote Assistance is set to Disabled (2)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'fAllowUnsolicitedFullControl'
        }
        Registry "18.8.36.1 - (L1) Ensure Configure Offer Remote Assistance is set to Disabled (3)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\RAUnsolicit'
            ValueName = ''
        }
    }
    if($ExcludeList -notcontains '18.8.36.2' -and $LevelOne){
        Registry "18.8.36.2 - (L1) Ensure Configure Solicited Remote Assistance is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 0
            ValueName = 'fAllowToGetHelp'
            ValueType = 'Dword'
        }
        Registry "18.8.36.2 - (L1) Ensure Configure Solicited Remote Assistance is set to Disabled (2)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'fAllowFullControl'
        }
        Registry "18.8.36.2 - (L1) Ensure Configure Solicited Remote Assistance is set to Disabled (3)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'MaxTicketExpiry'
        }
        Registry "18.8.36.2 - (L1) Ensure Configure Solicited Remote Assistance is set to Disabled (4)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'MaxTicketExpiryUnits'
        }
        Registry "18.8.36.2 - (L1) Ensure Configure Solicited Remote Assistance is set to Disabled (5)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueName = 'fUseMailto'
        }
    }
    if($ExcludeList -notcontains '18.8.37.1' -and $LevelOne){
        Registry "18.8.37.1 - (L1) Ensure Enable RPC Endpoint Mapper Client Authentication is set to Enabled (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc'
            ValueData = 1
            ValueName = 'EnableAuthEpResolution'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.37.2' -and $LevelTwo){
        Registry "18.8.37.2 - (L2) Ensure Restrict Unauthenticated RPC clients is set to Enabled Authenticated (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Rpc'
            ValueData = 1
            ValueName = 'RestrictRemoteClients'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.47.5.1' -and $LevelTwo){
        Registry "18.8.47.5.1 - (L2) Ensure Microsoft Support Diagnostic Tool Turn on MSDT interactive communication with support provider is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy'
            ValueData = 0
            ValueName = 'DisableQueryRemoteServer'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.47.11.1' -and $LevelTwo){
        Registry "18.8.47.11.1 - (L2) Ensure EnableDisable PerfTrack is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}'
            ValueData = 0
            ValueName = 'ScenarioExecutionEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.49.1' -and $LevelTwo){
        Registry "18.8.49.1 - (L2) Ensure Turn off the advertising ID is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo'
            ValueData = 1
            ValueName = 'DisabledByGroupPolicy'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.52.1.1' -and $LevelTwo){
        Registry "18.8.52.1.1 - (L2) Ensure Enable Windows NTP Client is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\W32time\TimeProviders\NtpClient'
            ValueData = 1
            ValueName = 'Enabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.8.52.1.2' -and $LevelTwo){
        Registry "18.8.52.1.2 - (L2) Ensure Enable Windows NTP Server is set to Disabled (MS only)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\W32time\TimeProviders\NtpServer'
            ValueData = 0
            ValueName = 'Enabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.4.1' -and $LevelTwo){
        Registry "18.9.4.1 - (L2) Ensure Allow a Windows app to share application data between users is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\AppModel\StateManager'
            ValueData = 0
            ValueName = 'AllowSharedLocalAppData'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.6.1' -and $LevelOne){
        Registry "18.9.6.1 - (L1) Ensure Allow Microsoft accounts to be optional is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'MSAOptional'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.8.1' -and $LevelOne){
        Registry "18.9.8.1 - (L1) Ensure Disallow Autoplay for non-volume devices is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
            ValueData = 1
            ValueName = 'NoAutoplayfornonVolume'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.8.2' -and $LevelOne){
        Registry "18.9.8.2 - (L1) Ensure Set the default behavior for AutoRun is set to Enabled Do not execute any autorun commands" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            ValueData = 1
            ValueName = 'NoAutorun'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.8.3' -and $LevelOne){
        Registry "18.9.8.3 - (L1) Ensure Turn off Autoplay is set to Enabled All drives" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            ValueData = 255
            ValueName = 'NoDriveTypeAutoRun'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.10.1.1' -and $LevelOne){
        Registry "18.9.10.1.1 - (L1) Ensure Configure enhanced anti-spoofing is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures'
            ValueData = 1
            ValueName = 'EnhancedAntiSpoofing'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.12.1' -and $LevelTwo){
        Registry "18.9.12.1 - (L2) Ensure Allow Use of Camera is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Camera'
            ValueData = 0
            ValueName = 'AllowCamera'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.13.1' -and $LevelOne){
        Registry "18.9.13.1 - (L1) Ensure Turn off Microsoft consumer experiences is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
            ValueData = 1
            ValueName = 'DisableWindowsConsumerFeatures'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.14.1' -and $LevelOne){
        Registry "18.9.14.1 - (L1) Ensure Require pin for pairing is set to Enabled First Time OR Enabled Always" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Connect'
            ValueData = 1
            ValueName = 'RequirePinForPairing'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.15.1' -and $LevelOne){
        Registry "18.9.15.1 - (L1) Ensure Do not display the password reveal button is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredUI'
            ValueData = 1
            ValueName = 'DisablePasswordReveal'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.15.2' -and $LevelOne){
        Registry "18.9.15.2 - (L1) Ensure Enumerate administrator accounts on elevation is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI'
            ValueData = 0
            ValueName = 'EnumerateAdministrators'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.16.1' -and $LevelOne){
        Registry "18.9.16.1 - (L1) Ensure Allow Telemetry is set to Enabled 0 - Security Enterprise Only or Enabled 1 - Basic" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
            ValueData = 0
            ValueName = 'AllowTelemetry'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.16.2' -and $LevelTwo){
        Registry "18.9.16.2 - (L2) Ensure Configure Authenticated Proxy usage for the Connected User Experience and Telemetry service is set to Enabled Disable Authenticated Proxy usage" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection'
            ValueData = 1
            ValueName = 'DisableEnterpriseAuthProxy'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.16.3' -and $LevelOne){
        Registry "18.9.16.3 - (L1) Ensure Do not show feedback notifications is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
            ValueData = 1
            ValueName = 'DoNotShowFeedbackNotifications'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.16.4' -and $LevelOne){
        Registry "18.9.16.4 - (L1) Ensure Toggle user control over Insider builds is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds'
            ValueData = 0
            ValueName = 'AllowBuildPreview'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.26.1.1' -and $LevelOne){
        Registry "18.9.26.1.1 - (L1) Ensure Application Control Event Log behavior when the log file reaches its maximum size is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application'
            ValueData = '0'
            ValueName = 'Retention'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.9.26.1.2' -and $LevelOne){
        Registry "18.9.26.1.2 - (L1) Ensure Application Specify the maximum log file size (KB) is set to Enabled 32768 or greater" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application'
            ValueData = $cis1892612MaxSize
            ValueName = 'MaxSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.26.2.1' -and $LevelOne){
        Registry "18.9.26.2.1 - (L1) Ensure Security Control Event Log behavior when the log file reaches its maximum size is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security'
            ValueData = '0'
            ValueName = 'Retention'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.9.26.2.2' -and $LevelOne){
        Registry "18.9.26.2.2 - (L1) Ensure Security Specify the maximum log file size (KB) is set to Enabled 196608 or greater" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security'
            ValueData = $cis1892622MaxSize
            ValueName = 'MaxSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.26.3.1' -and $LevelOne){
        Registry "18.9.26.3.1 - (L1) Ensure Setup Control Event Log behavior when the log file reaches its maximum size is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup'
            ValueData = '0'
            ValueName = 'Retention'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.9.26.3.2' -and $LevelOne){
        Registry "18.9.26.3.2 - (L1) Ensure Setup Specify the maximum log file size (KB) is set to Enabled 32768 or greater" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup'
            ValueData = $cis1892632MaxSize
            ValueName = 'MaxSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.26.4.1' -and $LevelOne){
        Registry "18.9.26.4.1 - (L1) Ensure System Control Event Log behavior when the log file reaches its maximum size is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System'
            ValueData = '0'
            ValueName = 'Retention'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.9.26.4.2' -and $LevelOne){
        Registry "18.9.26.4.2 - (L1) Ensure System Specify the maximum log file size (KB) is set to Enabled 32768 or greater" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System'
            ValueData = $cis1892642MaxSize
            ValueName = 'MaxSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.30.2' -and $LevelOne){
        Registry "18.9.30.2 - (L1) Ensure Turn off Data Execution Prevention for Explorer is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
            ValueData = 0
            ValueName = 'NoDataExecutionPrevention'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.30.3' -and $LevelOne){
        Registry "18.9.30.3 - (L1) Ensure Turn off heap termination on corruption is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
            ValueData = 0
            ValueName = 'NoHeapTerminationOnCorruption'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.30.4' -and $LevelOne){
        Registry "18.9.30.4 - (L1) Ensure Turn off shell protocol protected mode is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            ValueData = 0
            ValueName = 'PreXPSP2ShellProtocolBehavior'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.39.1' -and $LevelTwo){
        Registry "18.9.39.1 - (L2) Ensure Turn off location is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors'
            ValueData = 1
            ValueName = 'DisableLocation'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.43.1' -and $LevelTwo){
        Registry "18.9.43.1 - (L2) Ensure Allow Message Service Cloud Sync is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\Messaging'
            ValueData = 0
            ValueName = 'AllowMessageSync'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.44.1' -and $LevelOne){
        Registry "18.9.44.1 - (L1) Ensure Block all consumer Microsoft account user authentication is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftAccount'
            ValueData = 1
            ValueName = 'DisableUserAuth'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.52.1' -and $LevelOne){
        Registry "18.9.52.1 - (L1) Ensure Prevent the usage of OneDrive for file storage is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive'
            ValueData = 1
            ValueName = 'DisableFileSyncNGSC'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.2.2' -and $LevelOne){
        Registry "18.9.59.2.2 - (L1) Ensure Do not allow passwords to be saved is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'DisablePasswordSaving'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.2.1' -and $LevelTwo){
        Registry "18.9.59.3.2.1 - (L2) Ensure Restrict Remote Desktop Services users to a single Remote Desktop Services session is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'fSingleSessionPerUser'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.1' -and $LevelTwo){
        Registry "18.9.59.3.3.1 - (L2) Ensure Do not allow COM port redirection is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'fDisableCcm'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.2' -and $LevelOne){
        Registry "18.9.59.3.3.2 - (L1) Ensure Do not allow drive redirection is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'fDisableCdm'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.3' -and $LevelTwo){
        Registry "18.9.59.3.3.3 - (L2) Ensure Do not allow LPT port redirection is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'fDisableLPT'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.3.4' -and $LevelTwo){
        Registry "18.9.59.3.3.4 - (L2) Ensure Do not allow supported Plug and Play device redirection is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'fDisablePNPRedir'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.1' -and $LevelOne){
        Registry "18.9.59.3.9.1 - (L1) Ensure Always prompt for password upon connection is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'fPromptForPassword'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.2' -and $LevelOne){
        Registry "18.9.59.3.9.2 - (L1) Ensure Require secure RPC communication is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'fEncryptRPCTraffic'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.3' -and $LevelOne){
        Registry "18.9.59.3.9.3 - (L1) Ensure Require use of specific security layer for remote (RDP) connections is set to Enabled SSL" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 2
            ValueName = 'SecurityLayer'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.4' -and $LevelOne){
        Registry "18.9.59.3.9.4 - (L1) Ensure Require user authentication for remote connections by using Network Level Authentication is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'UserAuthentication'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.9.5' -and $LevelOne){
        Registry "18.9.59.3.9.5 - (L1) Ensure Set client connection encryption level is set to Enabled High Level" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 3
            ValueName = 'MinEncryptionLevel'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.10.1' -and $LevelTwo){
        Registry "18.9.59.3.10.1 - (L2) Ensure Set time limit for active but idle Remote Desktop Services sessions is set to Enabled 15 minutes or less" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = $cis189593101MaxIdleTime
            ValueName = 'MaxIdleTime'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.10.2' -and $LevelTwo){
        Registry "18.9.59.3.10.2 - (L2) Ensure Set time limit for disconnected sessions is set to Enabled 1 minute" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 60000
            ValueName = 'MaxDisconnectionTime'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.11.1' -and $LevelOne){
        Registry "18.9.59.3.11.1 - (L1) Ensure Do not delete temp folders upon exit is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'DeleteTempDirsOnExit'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.59.3.11.2' -and $LevelOne){
        Registry "18.9.59.3.11.2 - (L1) Ensure Do not use temporary folders per session is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            ValueData = 1
            ValueName = 'PerSessionTempDir'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.60.1' -and $LevelOne){
        Registry "18.9.60.1 - (L1) Ensure Prevent downloading of enclosures is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds'
            ValueData = 1
            ValueName = 'DisableEnclosureDownload'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.61.2' -and $LevelTwo){
        Registry "18.9.61.2 - (L2) Ensure Allow Cloud Search is set to Enabled Disable Cloud Search" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search'
            ValueData = 0
            ValueName = 'AllowCloudSearch'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.61.3' -and $LevelOne){
        Registry "18.9.61.3 - (L1) Ensure Allow indexing of encrypted files is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
            ValueData = 0
            ValueName = 'AllowIndexingEncryptedStoresOrItems'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.66.1' -and $LevelTwo){
        Registry "18.9.66.1 - (L2) Ensure Turn off KMS Client Online AVS Validation is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform'
            ValueData = 1
            ValueName = 'NoGenTicket'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.14' -and $LevelOne){
        Registry "18.9.77.14 - (L1) Ensure Configure detection for potentially unwanted applications is set to Enabled Block" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender'
            ValueData = 1
            ValueName = 'PUAProtection'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.15' -and $LevelOne){
        Registry "18.9.77.15 - (L1) Ensure Turn off Windows Defender AntiVirus is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender'
            ValueData = 0
            ValueName = 'DisableAntiSpyware'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.3.1' -and $LevelOne){
        Registry "18.9.77.3.1 - (L1) Ensure Configure local setting override for reporting to Microsoft MAPS is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet'
            ValueData = 0
            ValueName = 'LocalSettingOverrideSpynetReporting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.3.2' -and $LevelTwo){
        Registry "18.9.77.3.2 - (L2) Ensure Join Microsoft MAPS is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet'
            ValueData = 0
            ValueName = 'SpynetReporting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.7.1' -and $LevelOne){
        Registry "18.9.77.7.1 - (L1) Ensure Turn on behavior monitoring is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection'
            ValueData = 0
            ValueName = 'DisableBehaviorMonitoring'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.9.1' -and $LevelTwo){
        Registry "18.9.77.9.1 - (L2) Ensure Configure Watson events is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows Defender\Reporting'
            ValueData = 1
            ValueName = 'DisableGenericRePorts'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.10.1' -and $LevelOne){
        Registry "18.9.77.10.1 - (L1) Ensure Scan removable drives is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan'
            ValueData = 0
            ValueName = 'DisableRemovableDriveScanning'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.10.2' -and $LevelOne){
        Registry "18.9.77.10.2 - (L1) Ensure Turn on e-mail scanning is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan'
            ValueData = 0
            ValueName = 'DisableEmailScanning'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.77.13.3.1' -and $LevelOne){
        Registry "18.9.77.13.3.1 - (L1) Ensure Prevent users and apps from accessing dangerous websites is set to Enabled Block" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection'
            ValueData = 1
            ValueName = 'EnableNetworkProtection'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.80.1.1' -and $LevelOne){
        Registry "18.9.80.1.1 - (L1) Ensure Configure Windows Defender SmartScreen is set to Enabled Warn and prevent bypass (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 1
            ValueName = 'EnableSmartScreen'
            ValueType = 'Dword'
        }
        Registry "18.9.80.1.1 - (L1) Ensure Configure Windows Defender SmartScreen is set to Enabled Warn and prevent bypass (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
            ValueData = 'Block'
            ValueName = 'ShellSmartScreenLevel'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '18.9.84.1' -and $LevelTwo){
        Registry "18.9.84.1 - (L2) Ensure Allow suggested apps in Windows Ink Workspace is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace'
            ValueData = 0
            ValueName = 'AllowSuggestedAppsInWindowsInkWorkspace'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.84.2' -and $LevelOne){
        Registry "18.9.84.2 - (L1) Ensure Allow Windows Ink Workspace is set to Enabled On but disallow access above lock OR Disabled but not Enabled On" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace'
            ValueData = 0
            ValueName = 'AllowWindowsInkWorkspace'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.85.1' -and $LevelOne){
        Registry "18.9.85.1 - (L1) Ensure Allow user control over installs is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer'
            ValueData = 0
            ValueName = 'EnableUserControl'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.85.2' -and $LevelOne){
        Registry "18.9.85.2 - (L1) Ensure Always install with elevated privileges is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer'
            ValueData = 0
            ValueName = 'AlwaysInstallElevated'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.85.3' -and $LevelTwo){
        Registry "18.9.85.3 - (L2) Ensure Prevent Internet Explorer security prompt for Windows Installer scripts is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\Installer'
            ValueData = 0
            ValueName = 'SafeForScripting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.86.1' -and $LevelOne){
        Registry "18.9.86.1 - (L1) Ensure Sign-in and lock last interactive user automatically after a restart is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueData = 1
            ValueName = 'DisableAutomaticRestartSignOn'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.95.1' -and $LevelOne){
        Registry "18.9.95.1 - (L1) Ensure Turn on PowerShell Script Block Logging is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
            ValueData = 0
            ValueName = 'EnableScriptBlockLogging'
            ValueType = 'Dword'
        }
        Registry "18.9.95.1 - (L1) Ensure Turn on PowerShell Script Block Logging is set to Disabled (2)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
            ValueName = 'EnableScriptBlockInvocationLogging'
        }
    }
    if($ExcludeList -notcontains '18.9.95.2' -and $LevelOne){
        Registry "18.9.95.2 - (L1) Ensure Turn on PowerShell Transcription is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription'
            ValueData = 0
            ValueName = 'EnableTranscripting'
            ValueType = 'Dword'
        }
        Registry "18.9.95.2 - (L1) Ensure Turn on PowerShell Transcription is set to Disabled (2)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription'
            ValueName = 'OutputDirectory'
        }
        Registry "18.9.95.2 - (L1) Ensure Turn on PowerShell Transcription is set to Disabled (3)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription'
            ValueName = 'EnableInvocationHeader'
        }
    }
    if($ExcludeList -notcontains '18.9.97.1.1' -and $LevelOne){
        Registry "18.9.97.1.1 - (L1) Ensure Allow Basic authentication is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client'
            ValueData = 0
            ValueName = 'AllowBasic'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.97.1.2' -and $LevelOne){
        Registry "18.9.97.1.2 - (L1) Ensure Allow unencrypted traffic is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client'
            ValueData = 0
            ValueName = 'AllowUnencryptedTraffic'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.97.1.3' -and $LevelOne){
        Registry "18.9.97.1.3 - (L1) Ensure Disallow Digest authentication is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client'
            ValueData = 0
            ValueName = 'AllowDigest'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.1' -and $LevelOne){
        Registry "18.9.97.2.1 - (L1) Ensure Allow Basic authentication is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service'
            ValueData = 0
            ValueName = 'AllowBasic'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.2' -and $LevelTwo){
        Registry "18.9.97.2.2 - (L2) Ensure Allow remote server management through WinRM is set to Disabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
            ValueData = 0
            ValueName = 'AllowAutoConfig'
            ValueType = 'Dword'
        }
        Registry "18.9.97.2.2 - (L2) Ensure Allow remote server management through WinRM is set to Disabled (2)" {
            Ensure = 'Absent'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
            ValueName = 'IPv4Filter'
        }
        Registry "18.9.97.2.2 - (L2) Ensure Allow remote server management through WinRM is set to Disabled (3)" {
            Ensure = 'Absent'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service'
            ValueName = 'IPv6Filter'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.3' -and $LevelOne){
        Registry "18.9.97.2.3 - (L1) Ensure Allow unencrypted traffic is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service'
            ValueData = 0
            ValueName = 'AllowUnencryptedTraffic'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.97.2.4' -and $LevelOne){
        Registry "18.9.97.2.4 - (L1) Ensure Disallow WinRM from storing RunAs credentials is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service'
            ValueData = 1
            ValueName = 'DisableRunAs'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.98.1' -and $LevelTwo){
        Registry "18.9.98.1 - (L2) Ensure Allow Remote Shell Access is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\WinRS'
            ValueData = 0
            ValueName = 'AllowRemoteShellAccess'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.99.2.1' -and $LevelOne){
        Registry "18.9.99.2.1 - (L1) Ensure Prevent users from modifying settings is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection'
            ValueData = 1
            ValueName = 'DisallowExploitProtectionOverride'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.102.2' -and $LevelOne){
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueData = 0
            ValueName = 'NoAutoUpdate'
            ValueType = 'Dword'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueData = 3
            ValueName = 'AUOptions'
            ValueType = 'Dword'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (3)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueName = 'AutomaticMaintenanceEnabled'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (4)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueData = 3
            ValueName = 'ScheduledInstallTime'
            ValueType = 'Dword'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (5)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueData = 1
            ValueName = 'ScheduledInstallEveryWeek'
            ValueType = 'Dword'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (6)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueName = 'ScheduledInstallFirstWeek'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (7)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueName = 'ScheduledInstallSecondWeek'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (8)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueName = 'ScheduledInstallThirdWeek'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (9)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueName = 'ScheduledInstallFourthWeek'
        }
        Registry "18.9.102.2 - (L1) Ensure Configure Automatic Updates is set to Enabled (10)" {
            Ensure = 'Absent'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueName = 'AllowMUUpdateService'
        }
    }
    if($ExcludeList -notcontains '18.9.102.3' -and $LevelOne){
        Registry "18.9.102.3 - (L1) Ensure Configure Automatic Updates Scheduled install day is set to 0 - Every day" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueData = 0
            ValueName = 'ScheduledInstallDay'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.102.4' -and $LevelOne){
        Registry "18.9.102.4 - (L1) Ensure No auto-restart with logged on users for scheduled automatic updates installations is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
            ValueData = 0
            ValueName = 'NoAutoRebootWithLoggedOnUsers'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.1' -and $LevelOne){
        Registry "18.9.102.1.1 - (L1) Ensure Manage preview builds is set to Enabled Disable preview builds (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 1
            ValueName = 'ManagePreviewBuilds'
            ValueType = 'Dword'
        }
        Registry "18.9.102.1.1 - (L1) Ensure Manage preview builds is set to Enabled Disable preview builds (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 0
            ValueName = 'ManagePreviewBuildsPolicyValue'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.2' -and $LevelOne){
        Registry "18.9.102.1.2 - (L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled Semi-Annual Channel 180 or more days (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 1
            ValueName = 'DeferFeatureUpdates'
            ValueType = 'Dword'
        }
        Registry "18.9.102.1.2 - (L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled Semi-Annual Channel 180 or more days (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 32
            ValueName = 'BranchReadinessLevel'
            ValueType = 'Dword'
        }
        Registry "18.9.102.1.2 - (L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled Semi-Annual Channel 180 or more days (3)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = $cis18910212DeferFeatureUpdatesPeriodInDays
            ValueName = 'DeferFeatureUpdatesPeriodInDays'
            ValueType = 'Dword'
        }
        Registry "18.9.102.1.2 - (L1) Ensure Select when Preview Builds and Feature Updates are received is set to Enabled Semi-Annual Channel 180 or more days (4)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 0
            ValueName = 'PauseFeatureUpdatesStartTime'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '18.9.102.1.3' -and $LevelOne){
        Registry "18.9.102.1.3 - (L1) Ensure Select when Quality Updates are received is set to Enabled 0 days (1)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 1
            ValueName = 'DeferQualityUpdates'
            ValueType = 'Dword'
        }
        Registry "18.9.102.1.3 - (L1) Ensure Select when Quality Updates are received is set to Enabled 0 days (2)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 0
            ValueName = 'DeferQualityUpdatesPeriodInDays'
            ValueType = 'Dword'
        }
        Registry "18.9.102.1.3 - (L1) Ensure Select when Quality Updates are received is set to Enabled 0 days (3)" {
            Ensure = 'Present'
            Key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            ValueData = 0
            ValueName = 'PauseQualityUpdatesStartTime'
            ValueType = 'Dword'
        }
    }
}
