$script:PlasterTemplatePath = Join-Path -Path $PSScriptRoot -ChildPath 'plasterTemplates'
[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}

Class Recommendation {
    [string]$SectionNum
    [string]$RecommendationNum
    [string]$Title
    [string]$Description
    [string]$RemediationProcedure
    [string]$AuditProcedure

    Recommendation([System.Management.Automation.PSCustomObject]$Excel){
        #$This.title = $Excel.title -rep
    }

}

Class DSCConfigurationParameter{
    [string]$Name
    [string]$DataType
    [string]$DefaultValue
    [string]$TextBlock

    DSCConfigurationParameter($Name, $DataType, $DefaultValue){
        $this.Name = $Name
        $this.DataType = $DataType
        $this.DefaultValue = $DefaultValue
        $this.TextBlock = $this.GenerateTextBlock()
    }

    [string]GenerateTextBlock(){
        $blankDefinition = @'
        {0}
        {1} = {2}
'@

        return ($blankDefinition -f $this.DataType,$this.Name,$this.DefaultValue)
    }
}

Class ScaffoldingBlock {
    [object]$Recommendation
    [string]$ResourceType
    [System.Collections.Hashtable]$ResourceParameters
    [string]$TextBlock
    [version]$RecommendationVersioned

    ScaffoldingBlock($Recommendation, $ResourceType, $ResourceParameters){
        $this.Recommendation = $Recommendation
        $this.ResourceType = $ResourceType
        $this.ResourceParameters = $ResourceParameters
        $this.RecommendationVersioned = $Recommendation.RecommendationVersioned
        $this.UpdateForPotentialParameter()
        $script:UsedResourceTitles += $This.Recommendation.title
        $this.TextBlock = $this.GenerateTextBlock()
    }

    UpdateForPotentialParameter(){
        if($this.Recommendation.PotentialParameter){
            switch($this.ResourceType){
                'Registry'{
                    [string]$DataType = switch($this.ResourceParameters['ValueType']){
                        "'String'" {'[string]'}
                        "'MultiString'" {'[string[]]'}
                        "'Dword'" {'[int32]'}
                    }
                    [string]$Name = "$('$')$($this.RecommendationVersioned.ToString().Replace('.',''))_$($this.ResourceParameters['ValueName'].replace("'",''))"
                    $script:DSCConfigurationParameters += [DSCConfigurationParameter]::new($Name,$DataType,$this.ResourceParameters['ValueData'])
                    $this.ResourceParameters['ValueData'] = $Name
                }

                'AccountPolicy'{
                    [string]$Name = "$('$')$($this.RecommendationVersioned.ToString().Replace('.',''))_$($this.ResourceParameters['Name'].replace("'",'').replace('_',''))"
                    $ValueKey = $this.ResourceParameters['Name'].replace("'",'')
                    [string]$DataType = "[$($this.ResourceParameters[$ValueKey].GetType().Name)]"
                    #[string]$DataType = "[derp]"
                    $script:DSCConfigurationParameters += [DSCConfigurationParameter]::new($Name,$DataType,$this.ResourceParameters[$ValueKey])
                    $this.ResourceParameters[$ValueKey] = $Name
                }
            }
        }
    }

    [string]GenerateTextBlock(){
        [string[]]$ResourceParametersString = @()
        foreach($Key in $this.ResourceParameters.keys){
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

        [string]$Title = $This.Recommendation.title
        [int]$TitleCount = ($script:UsedResourceTitles | Where-Object -FilterScript {$_ -eq $This.Recommendation.title} | Measure-Object).count
        if($TitleCount -gt 1){
            $Title = "$($Title) ($($TitleCount))"
        }

        $Replacements = @(
            $This.Recommendation.'recommendation #',
            $This.Recommendation.Level,
            $This.ResourceType,
            $Title,
            ($ResourceParametersString -join "`n")
        )

        return ($blankDefinition -f $Replacements)
    }
}

$script:BenchmarkRecommendations = @{}
$script:BenchmarkSections = @{}
$script:StaticCorrections = @{}
[string[]]$script:UsedResourceTitles = @()
[int]$script:ServiceSection = 0
[int]$script:UserSection = 0

$script:DSCConfigurationParameters = @(
    [DSCConfigurationParameter]::new('$ExcludeList','[string[]]','@()'),
    [DSCConfigurationParameter]::new('$LevelOne','[boolean]','$true'),
    [DSCConfigurationParameter]::new('$LevelTwo','[boolean]','$false'),
    [DSCConfigurationParameter]::new('$BitLocker','[boolean]','$false'),
    [DSCConfigurationParameter]::new('$NextGenerationWindowsSecurity','[boolean]','$false')
)

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

$script:AuditSubCategory = @{
    "0CCE9211-69AE-11D9-BED3-505054503030" = "Security System Extension"
    "0CCE9212-69AE-11D9-BED3-505054503030" = "System Integrity"
    "0CCE9213-69AE-11D9-BED3-505054503030" = "IPsec Driver"
    "0CCE9214-69AE-11D9-BED3-505054503030" = "Other System Events"
    "0CCE9210-69AE-11D9-BED3-505054503030" = "Security State Change"
    "0CCE9215-69AE-11D9-BED3-505054503030" = "Logon"
    "0CCE9216-69AE-11D9-BED3-505054503030" = "Logoff"
    "0CCE9217-69AE-11D9-BED3-505054503030" = "Account Lockout"
    "0CCE9218-69AE-11D9-BED3-505054503030" = "IPsec Main Mode"
    "0CCE9219-69AE-11D9-BED3-505054503030" = "IPsec Quick Mode"
    "0CCE921A-69AE-11D9-BED3-505054503030" = "IPsec Extended Mode"
    "0CCE921B-69AE-11D9-BED3-505054503030" = "Special Logon"
    "0CCE921C-69AE-11D9-BED3-505054503030" = "Other Logon/Logoff Events"
    "0CCE9243-69AE-11D9-BED3-505054503030" = "Network Policy Server"
    "0cce9247-69ae-11d9-bed3-505054503030" = "User / Device Claims"
    "0cce9249-69ae-11d9-bed3-505054503030" = "Group Membership"
    "0CCE921D-69AE-11D9-BED3-505054503030" = "File System"
    "0CCE921E-69AE-11D9-BED3-505054503030" = "Registry"
    "0CCE921F-69AE-11D9-BED3-505054503030" = "Kernel Object"
    "0CCE9220-69AE-11D9-BED3-505054503030" = "SAM"
    "0CCE9221-69AE-11D9-BED3-505054503030" = "Certification Services"
    "0CCE9222-69AE-11D9-BED3-505054503030" = "Application Generated"
    "0CCE9223-69AE-11D9-BED3-505054503030" = "Handle Manipulation"
    "0CCE9224-69AE-11D9-BED3-505054503030" = "File Share"
    "0CCE9225-69AE-11D9-BED3-505054503030" = "Filtering Platform Packet Drop"
    "0CCE9226-69AE-11D9-BED3-505054503030" = "Filtering Platform Connection"
    "0CCE9227-69AE-11D9-BED3-505054503030" = "Other Object Access Events"
    "0CCE9244-69AE-11D9-BED3-505054503030" = "Detailed File Share"
    "0CCE9245-69AE-11D9-BED3-505054503030" = "Removable Storage"
    "0CCE9246-69AE-11D9-BED3-505054503030" = "Central Policy Staging"
    "0CCE9229-69AE-11D9-BED3-505054503030" = "Non Sensitive Privilege Use"
    "0CCE922A-69AE-11D9-BED3-505054503030" = "Other Privilege Use Events"
    "0CCE9228-69AE-11D9-BED3-505054503030" = "Sensitive Privilege Use"
    "0CCE922B-69AE-11D9-BED3-505054503030" = "Process Creation"
    "0CCE922C-69AE-11D9-BED3-505054503030" = "Process Termination"
    "0CCE922D-69AE-11D9-BED3-505054503030" = "DPAPI Activity"
    "0CCE922E-69AE-11D9-BED3-505054503030" = "RPC Events"
    "0cce9248-69ae-11d9-bed3-505054503030" = "Plug and Play Events"
    "0CCE9230-69AE-11D9-BED3-505054503030" = "Authentication Policy Change"
    "0CCE9231-69AE-11D9-BED3-505054503030" = "Authorization Policy Change"
    "0CCE9232-69AE-11D9-BED3-505054503030" = "MPSSVC Rule-Level Policy Change"
    "0CCE9233-69AE-11D9-BED3-505054503030" = "Filtering Platform Policy Change"
    "0CCE9234-69AE-11D9-BED3-505054503030" = "Other Policy Change Events"
    "0CCE922F-69AE-11D9-BED3-505054503030" = "Audit Policy Change"
    "0CCE9235-69AE-11D9-BED3-505054503030" = "User Account Management"
    "0CCE9236-69AE-11D9-BED3-505054503030" = "Computer Account Management"
    "0CCE9237-69AE-11D9-BED3-505054503030" = "Security Group Management"
    "0CCE9238-69AE-11D9-BED3-505054503030" = "Distribution Group Management"
    "0CCE9239-69AE-11D9-BED3-505054503030" = "Application Group Management"
    "0CCE923A-69AE-11D9-BED3-505054503030" = "Other Account Management Events"
    "0CCE923C-69AE-11D9-BED3-505054503030" = "Directory Service Changes"
    "0CCE923D-69AE-11D9-BED3-505054503030" = "Directory Service Replication"
    "0CCE923E-69AE-11D9-BED3-505054503030" = "Detailed Directory Service Replication"
    "0CCE923B-69AE-11D9-BED3-505054503030" = "Directory Service Access"
    "0CCE9240-69AE-11D9-BED3-505054503030" = "Kerberos Service Ticket Operations"
    "0CCE9241-69AE-11D9-BED3-505054503030" = "Other Account Logon Events"
    "0CCE9242-69AE-11D9-BED3-505054503030" = "Kerberos Authentication Service"
    "0CCE923F-69AE-11D9-BED3-505054503030" = "Credential Validation"
}

$script:RegistryDataType = @{
    'REG_SZ' = 'String'
    'REG-BINARY' = 'Binary'
    'REG_DWORD' = 'Dword'
    'REG_QWORD' = 'Qword'
    'REG_MULTI_SZ' = 'MultiString'
    'REG_EXPAND_SZ' = 'ExpandString'
}