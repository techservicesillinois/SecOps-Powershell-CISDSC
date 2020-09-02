$script:PlasterTemplatePath = Join-Path -Path $PSScriptRoot -ChildPath 'plasterTemplates'
[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}

#This class is utilized to help centralize the logic for generating parameters for recommendations where appropriate.
#These are created within the ScaffoldingBlock class and later used within Get-ConfigurationHeader
#The constructor should probably be reworked to just take a scaffolding block object vs the various properties individually.
Class DSCConfigurationParameter{
    [string]$Name
    [string]$DataType
    [string]$DefaultValue
    [string]$TextBlock

    DSCConfigurationParameter($RecommendationNum, $Name, $DataType, $DefaultValue){
        [string]$SanitizedName = $Name -replace "[^a-zA-Z0-9]",""
        [string]$SanitizedRecommendationNum = $RecommendationNum.Replace('.','')

        $This.Name = '${0}{1}' -f $SanitizedRecommendationNum,$SanitizedName
        $This.DataType = $DataType
        $This.DefaultValue = "$($DefaultValue)".replace('"',"'")

        <# Example of formated definition
            [Int32]$112MaximumPasswordAge = 60
        #>
        $This.TextBlock = "        $($This.DataType)$($This.Name) = $($This.DefaultValue)"
    }
}

#This class is utilized by Update-CISBenchmarkData to cleanly import the information from the CIS excel files.
Class Recommendation{
    [string]$SectionNum
    [string]$RecommendationNum
    [string]$Title
    [string]$DSCTitle
    [string]$Description
    [string]$RemediationProcedure
    [string]$AuditProcedure
    [string]$Level
    #The version typing is required later for sorting properly.
    [version]$RecommendationVersioned
    [version]$SectionVersioned
    [int]$TopLevelSection
    [System.Collections.Hashtable[]]$ResourceParameters
    [string]$DSCTextBlock
    [DSCConfigurationParameter]$DSCConfigParameter


    Recommendation([Object]$ExcelRow){
        $This.SectionNum = $ExcelRow.'section #'
        $This.RecommendationNum = $ExcelRow.'recommendation #'
        #Quotes are normalized for consistentcy in checks.
        $This.Title = $ExcelRow.Title.Replace('"',"'")
        #Most special characters are filtered out of the title for the DSC resource. This prevents various encoding issues.
        $This.DSCTitle = $This.Title -replace "[^a-zA-Z0-9() ]",""
        $This.Description = $ExcelRow.Description
        $This.RemediationProcedure = $ExcelRow.'remediation procedure'
        $This.AuditProcedure = $ExcelRow.'audit procedure'

        [regex]$LevelPattern = '^\(.{2}\)'
        switch($LevelPattern.Match($This.Title).Value){
            '(L1)'{$This.Level = 'LevelOne'}
            '(L2)'{$This.Level = 'LevelTwo'}
            '(BL)'{$This.Level = 'BitLocker'}
            '(NG)'{$This.Level = 'NextGenerationWindowsSecurity'}
            default {$This.Level = [string]::Empty}
        }

        $This.RecommendationVersioned = $This.ConvertNumStringToVersion($This.RecommendationNum)
        $This.SectionVersioned = $This.ConvertNumStringToVersion($This.SectionNum)
        $This.TopLevelSection = $This.RecommendationVersioned.Major
    }

    [version]ConvertNumStringToVersion([string]$CISNumberString){
        #.Net is limited to 4 part version numbers and some CIS recommendations are 5+. This method will consoldate everything past the 4th number into one.
        function Get-DotCount([string]$String){
            ($string.length - $string.replace('.','').length)
        }

        [string]$VerString = $CISNumberString
        [int]$Dotcount = Get-DotCount -String $VerString

        if($Dotcount -eq 0){
            $VerString = "$($VerString).0"
        }
        elseif($Dotcount -ge 4) {
            do{
                $VerString = $VerString.Remove($VerString.LastIndexOf('.'),1)
            }
            until((Get-DotCount -String $VerString) -eq 3)
        }

        return [version]$VerString
    }

    UpdateForDSCParameter(){
        [boolean]$NeedsParam = switch($This.Title){
            {$_ -like "*or more*"}{$True}
            {$_ -like "*or fewer*"}{$True}
            {$_ -like "*or greater*"}{$True}
            {$_ -like "*or less*"}{$True}
            {$_ -eq "(L1) Configure 'Interactive logon: Message text for users attempting to log on'"}{$True}
            {$_ -eq "(L1) Configure 'Interactive logon: Message title for users attempting to log on'"}{$True}
            {$_ -eq "(L1) Configure 'Accounts: Rename administrator account'"}{$True}
            {$_ -eq "(L1) Configure 'Accounts: Rename guest account'"}{$True}
            default {$False}
        }

        if($NeedsParam){
            [int[]]$NumbersInTitle = [int[]]($This.Title.Substring(5) -replace '[^0-9 ]' -split ' ').where({$_}) | Sort-Object -Descending

            #Recommendations can have many associated settings but typically only one of these is configurable.
            #The configurable setting is identified by it's value matching a number in the title if there are no numbers they are all given a parameter.
            foreach($Hash in $This.ResourceParameters){
                foreach($Value in $Hash.Values){
                    if( ($Value -in $NumbersInTitle) -or !$NumbersInTitle -or $This.ResourceParameters.Count -eq 1){
                        switch($Hash['ResourceType']){
                            'Registry'{
                                [string]$DataType = switch($Hash['ValueType']){
                                    "'String'" {'[string]'}
                                    "'MultiString'" {'[string[]]'}
                                    "'Dword'" {'[int32]'}
                                }
                                $This.DSCConfigParameter = [DSCConfigurationParameter]::new($This.RecommendationNum,$Hash['ValueName'],$DataType,$Hash['ValueData'])
                                $Hash['ValueData'] = $This.DSCConfigParameter.Name
                            }

                            {$_ -in ('SecurityOption','AccountPolicy')}{
                                $ValueKey = $Hash['Name'].replace("'",'')
                                [string]$DataType = "[$($Hash[$ValueKey].GetType().Name)]"
                                $This.DSCConfigParameter = [DSCConfigurationParameter]::new($This.RecommendationNum,$Hash['Name'],$DataType,$Hash[$ValueKey])
                                $Hash[$ValueKey] = $This.DSCConfigParameter.Name
                            }
                        }
                        break
                    }
                }
            }
        }
    }

    GenerateTextBlock(){
        $This.UpdateForDSCParameter()

        [string]$Conditional = '    if($ExcludeList -notcontains ''{0}'' -and ${1}){{' -f $This.RecommendationNum,$This.Level
        [int]$TitleCount = 1
        [string[]]$ResourceParametersString = @()
        $ResourceParametersString += $Conditional

        foreach($Hash in $This.ResourceParameters){
            if($This.ResourceParameters.Count -gt 1){
                $FunctionalTitle = "$($This.DSCTitle) ($($TitleCount))"
                $TitleCount++
            }
            else{
                $FunctionalTitle = $This.DSCTitle
            }

            $ResourceParametersString += '        {0} "{1}" {{' -f $Hash['ResourceType'],$FunctionalTitle
            foreach($Key in ($Hash.keys | Sort-Object)){
                if($Key -ne 'ResourceType'){
                    $ResourceParametersString += "            $($Key) = $($Hash[$Key])"
                }
            }
            $ResourceParametersString += '        }'
        }

        $ResourceParametersString += "    }"
        $This.DSCTextBlock = ($ResourceParametersString -join "`n")
    }
}

$script:BenchmarkRecommendations = @{}
$script:StaticCorrections = @{}
[int]$script:ServiceSection = 0
[int]$script:UserSection = 0
[System.Collections.ArrayList]$script:RecommendationErrors = @()
[System.Collections.ArrayList]$script:DSCConfigurationParameters = @()

#Below is various dictionaries used to translate values from group policy to DSC.
#These where pulled from https://github.com/microsoft/BaselineManagement/blob/master/src/Helpers/Enumerations.ps1
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