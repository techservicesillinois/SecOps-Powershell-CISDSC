[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}

Class ScaffoldingBlock {
    [object]$Reccomendation
    [string]$ResourceType
    [System.Collections.Hashtable]$ResourceParameters
    [string]$TextBlock

    ScaffoldingBlock($Reccomendation, $ResourceType, $ResourceParameters){
        $this.Reccomendation = $Reccomendation
        $this.ResourceType = $ResourceType
        $this.ResourceParameters = $ResourceParameters
        $this.TextBlock = $this.GenerateTextBlock()
    }

    [string]GenerateTextBlock(){
        [string[]]$ResourceParametersString = @()
        foreach($Key in $This.ResourceParameters.keys){
            $ResourceParametersString += "           $Key = $($This.ResourceParameters[$Key])"
        }

        $blankDefinition = @'
    if($ExcludeList -notcontains '{0}' -and ${1}){{
        {2} "{3}"
        {{
{4}
        }}
    }}
'@

        $Replacements = @(
            $This.Reccomendation.'recommendation #',
            $This.Reccomendation.Level,
            $This.ResourceType,
            $This.Reccomendation.title,
            ($ResourceParametersString -join "`n")
        )

        return ($blankDefinition -f $Replacements)
    }
}

$script:BenchmarkReccomendations = @{}
$script:BenchmarkSections = @{}

$script:UserRights = @{
    "SeTrustedCredManAccessPrivilege" = "Access_Credential_Manager_as_a_trusted_caller"
    "SeNetworkLogonRight" = "Access_this_computer_from_the_network"
    "SeTcbPrivilege" = "Act_as_part_of_the_operating_system"
    "SeMachineAccountPrivilege" = "Add_workstations_to_domain"
    "SeIncreaseQuotaPrivilege" = "Adjust_memory_quotas_for_a_process"
    "SeInteractiveLogonRight" = "Allow_log_on_locally"
    "SeRemoteInteractiveLogonRight" = "Allow_log_on_through_Remote_Desktop_Services"
    "SeBackupPrivilege" = "Back_up_files_and_directories"
    "SeChangeNotifyPrivilege" = "Bypass_traverse_checking"
    "SeSystemtimePrivilege" = "Change_the_system_time"
    "SeTimeZonePrivilege" = "Change_the_time_zone"
    "SeCreatePagefilePrivilege" = "Create_a_pagefile"
    "SeCreateTokenPrivilege" = "Create_a_token_object"
    "SeCreateGlobalPrivilege" = "Create_global_objects"
    "SeCreatePermanentPrivilege" = "Create_permanent_shared_objects"
    "SeCreateSymbolicLinkPrivilege" = "Create_symbolic_links"
    "SeDebugPrivilege" = "Debug_programs"
    "SeDenyNetworkLogonRight" = "Deny_access_to_this_computer_from_the_network"
    "SeDenyBatchLogonRight" = "Deny_log_on_as_a_batch_job"
    "SeDenyServiceLogonRight" = "Deny_log_on_as_a_service"
    "SeDenyInteractiveLogonRight" = "Deny_log_on_locally"
    "SeDenyRemoteInteractiveLogonRight" = "Deny_log_on_through_Remote_Desktop_Services"
    "SeEnableDelegationPrivilege" = "Enable_computer_and_user_accounts_to_be_trusted_for_delegation"
    "SeRemoteShutdownPrivilege" = "Force_shutdown_from_a_remote_system"
    "SeAuditPrivilege" = "Generate_security_audits"
    "SeImpersonatePrivilege" = "Impersonate_a_client_after_authentication"
    "SeIncreaseWorkingSetPrivilege" = "Increase_a_process_working_set"
    "SeIncreaseBasePriorityPrivilege" = "Increase_scheduling_priority"
    "SeLoadDriverPrivilege" = "Load_and_unload_device_drivers"
    "SeLockMemoryPrivilege" = "Lock_pages_in_memory"
    "SeBatchLogonRight" = "Log_on_as_a_batch_job"
    "SeServiceLogonRight" = "Log_on_as_a_service"
    "SeSecurityPrivilege" = "Manage_auditing_and_security_log"
    "SeRelabelPrivilege" = "Modify_an_object_label"
    "SeSystemEnvironmentPrivilege" = "Modify_firmware_environment_values"
    "SeManageVolumePrivilege" = "Perform_volume_maintenance_tasks"
    "SeProfileSingleProcessPrivilege" = "Profile_single_process"
    "SeSystemProfilePrivilege" = "Profile_system_performance"
    "SeUndockPrivilege" = "Remove_computer_from_docking_station"
    "SeAssignPrimaryTokenPrivilege" = "Replace_a_process_level_token"
    "SeRestorePrivilege" = "Restore_files_and_directories"
    "SeShutdownPrivilege" = "Shut_down_the_system"
    "SeSyncAgentPrivilege" = "Synchronize_directory_service_data"
    "SeTakeOwnershipPrivilege" =  "Take_ownership_of_files_or_other_objects"
}

$script:SecurityOptionSettings = @{
    'ForceLogoffWhenHourExpire' = 'Network_security_Force_logoff_when_logon_hours_expire'
    'LSAAnonymousNameLookup' = 'Network_access_Allow_anonymous_SID_Name_translation'
    'EnableAdminAccount' = 'Accounts_Administrator_account_status'
    'EnableGuestAccount' = 'Accounts_Guest_account_status'
    'NewAdministratorName' = 'Accounts_Rename_administrator_account'
    'NewGuestName' = 'Accounts_Rename_guest_account'
}

$script:AccountPolicySettings = @{
    'MaximumPasswordAge' = 'Maximum_Password_Age'
    'MinimumPasswordAge' = 'Minimum_Password_Age'
    'MinimumPasswordLength' = 'Minimum_Password_Length'
    'PasswordComplexity' = 'Password_must_meet_complexity_requirements'
    'ClearTextPassword' = 'Store_passwords_using_reversible_encryption'
    'PasswordHistorySize' = 'Enforce_password_history'
    'MaxServiceAge' = 'Maximum_lifetime_for_service_ticket'
    'MaxTicketAge' = 'Maximum_lifetime_for_user_ticket'
    'MaxRenewAge' = 'Maximum_lifetime_for_user_ticket_renewal'
    'MaxClockSkew' = 'Maximum_tolerance_for_computer_clock_synchronization'
    'TicketValidateClient' = 'Enforce_user_logon_restrictions'
    'LockoutDuration' = 'Account_lockout_duration'
    'LockoutBadCount' = 'Account_lockout_threshold'
    'ResetLockoutCount' = 'Reset_account_lockout_counter_after'
}

$script:SecuritySettingsWEnabledDisabled = @(
    "Accounts_Administrator_account_status",
    "Accounts_Guest_account_status",
    "Enforce_user_logon_restrictions",
    "Password_must_meet_complexity_requirements",
    "Store_passwords_using_reversible_encryption",
    "Network_access_Allow_anonymous_SID_Name_translation",
    "Network_security_Force_logoff_when_logon_hours_expire"
)

$script:SecuritySettings = @(
    "MinimumPasswordAge",
    "MaximumPasswordAge",
    "MinimumPasswordLength",
    "PasswordComplexity",
    "PasswordHistorySize",
    "LockoutBadCount",
    "ForceLogoffWhenHourExpire",
    "NewAdministratorName",
    "NewGuestName",
    "ClearTextPassword",
    "LSAAnonymousNameLookup",
    "EnableAdminAccount",
    "EnableGuestAccount",
    "ResetLockoutCount",
    "LockoutDuration",
    "MaxServiceAge",
    "MaxTicketAge",
    "MaxRenewAge",
    "MaxClockSkew",
    "TicketValidateClient"
)

$script:EnabledDisabled = @(
    "Disabled",
    "Enabled"
)