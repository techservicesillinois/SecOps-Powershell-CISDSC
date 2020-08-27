$script:PlasterTemplatePath = Join-Path -Path $PSScriptRoot -ChildPath 'plasterTemplates'
[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}

#This class is utilized by Update-CISBenchmarkData to cleanly import the information from the CIS excel files.
Class Recommendation{
    [string]$SectionNum
    [string]$RecommendationNum
    [string]$Title
    [String]$DSCTitle
    [string]$Description
    [string]$RemediationProcedure
    [string]$AuditProcedure
    [string]$Level
    #The version typing is required later for sorting properly.
    [Version]$RecommendationVersioned
    [Version]$SectionVersioned
    [int]$TopLevelSection
    [Boolean]$DSCParameter

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

        switch($This.Title){
            {$_ -like "*or more*"}{$This.DSCParameter = $True}
            {$_ -like "*or fewer*"}{$This.DSCParameter = $True}
            {$_ -like "*or greater*"}{$This.DSCParameter = $True}
            {$_ -like "*or less*"}{$This.DSCParameter = $True}
            #{$_ -like "*between*"}{$This.DSCParameter = $True} this was causing false positives.
            {$_ -eq "(L1) Configure 'Interactive logon: Message text for users attempting to log on'"}{$This.DSCParameter = $True}
            {$_ -eq "(L1) Configure 'Interactive logon: Message title for users attempting to log on'"}{$This.DSCParameter = $True}
            {$_ -eq "(L1) Configure 'Accounts: Rename administrator account'"}{$This.DSCParameter = $True}
            {$_ -eq "(L1) Configure 'Accounts: Rename guest account'"}{$This.DSCParameter = $True}
            default {$This.DSCParameter = $False}
        }
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
}

#This class is utilized to help centralize the logic for generating parameters for recommendations where appropriate.
#These are created within the ScaffoldingBlock class and later used within Get-ConfigurationHeader
#The constructor should probably be reworked to just take a scaffolding block object vs the various properties individually.
Class DSCConfigurationParameter{
    [string]$Name
    [string]$DataType
    [string]$DefaultValue
    [string]$TextBlock
    #[string]$Validation

    DSCConfigurationParameter($Name, $DataType, $DefaultValue, $Title){
        $This.Name = $Name
        $This.DataType = $DataType
        $This.DefaultValue = "$($DefaultValue)".replace('"',"'")

        <# Parameter validation based on titles is currently unreliable due to some recommendations having multiple settings. Commented out until a solution is identified
        #We can always expect the first 5 characters of the title to be the level acronym. EX: '(L1) '
        [int[]]$NumbersInTitle = [int[]]($Title.Substring(5) -replace '[^0-9 ]' -split ' ').where({$_}) | Sort-Object -Descending
        #Some benchmarks implying a lower value is acceptable specifically say but not 0 implying a minimum value of 1 instead.
        #So the true/false value of that text appearing can be directly converted to a 1/0 for the minimum value.
        [Boolean]$ButNotZero = $Title -like "*but not 0*"

        [int]$Start = 0
        [int]$End = 0
        switch($Title){
            {$_ -like "*or more*" -or $_ -like "*or greater*"}{
                $Start = $NumbersInTitle[0]
                $End = [int32]::MaxValue
                $This.Validation = "[ValidateRange($($Start),$($End))]"
            }
            {$_ -like "*or fewer*" -or $_ -like "*or less*"}{
                $Start = [int]$ButNotZero
                $End = $NumbersInTitle[0]
                $This.Validation = "[ValidateRange($($Start),$($End))]"
            }
            {$_ -like "*between*"}{
                #this helps mitigate some false positives from the word between appearing by ensuring two values are in the title.
                if(($Start = $NumbersInTitle[1])){
                    $End = $NumbersInTitle[0]
                    $This.Validation = "[ValidateRange($($Start),$($End))]"
                }
                else{
                    $This.Validation = $null
                }
            }
            Default{
                $This.Validation = $null
            }
        }
        #>

        $This.TextBlock = $This.GenerateTextBlock()
    }

    <# Example of formated definition
        [Int32]$112MaximumPasswordAge = 60
    #>

    [string]GenerateTextBlock(){
        $blankDefinition = @'
        {0}{1} = {2}
'@

        return ($blankDefinition -f $This.DataType,$This.Name,$This.DefaultValue)
    }
}

#This class contains the logic combining the CIS Excel information and DSC into actual text to be placed into the resulting composite resource.
#Used within ConvertTo-DSC
Class ScaffoldingBlock{
    [Recommendation]$Recommendation
    [string]$ResourceType
    [System.Collections.Hashtable]$ResourceParameters
    [string]$TextBlock
    [version]$RecommendationVersioned

    ScaffoldingBlock($Recommendation, $ResourceType, $ResourceParameters){
        $This.Recommendation = $Recommendation
        $This.ResourceType = $ResourceType
        $This.ResourceParameters = $ResourceParameters
        $This.RecommendationVersioned = $Recommendation.RecommendationVersioned
        $This.UpdateForDSCParameter()
        $script:UsedResourceTitles += $This.Recommendation.DSCTitle
        $This.TextBlock = $This.GenerateTextBlock()
    }

    UpdateForDSCParameter(){
        if($This.Recommendation.DSCParameter){
            switch($This.ResourceType){
                'Registry'{
                    [string]$DataType = switch($This.ResourceParameters['ValueType']){
                        "'String'" {'[string]'}
                        "'MultiString'" {'[string[]]'}
                        "'Dword'" {'[int32]'}
                    }
                    [string]$Name = "$('$')$($This.RecommendationVersioned.ToString().Replace('.',''))$($This.ResourceParameters['ValueName'].replace("'",''))"
                    #Titles are stored in script scope so they can be de-duplicated later.
                    $script:DSCConfigurationParameters += [DSCConfigurationParameter]::new($Name,$DataType,$This.ResourceParameters['ValueData'],$This.Recommendation.DSCTitle)
                    $This.ResourceParameters['ValueData'] = $Name
                }

                {$_ -in ('SecurityOption','AccountPolicy')}{
                    [string]$Name = "$('$')$($This.RecommendationVersioned.ToString().Replace('.',''))$($This.ResourceParameters['Name'].replace("'",'').replace('_',''))"
                    $ValueKey = $This.ResourceParameters['Name'].replace("'",'')
                    [string]$DataType = "[$($This.ResourceParameters[$ValueKey].GetType().Name)]"
                    #Titles are stored in script scope so they can be de-duplicated later.
                    $script:DSCConfigurationParameters += [DSCConfigurationParameter]::new($Name,$DataType,$This.ResourceParameters[$ValueKey],$This.Recommendation.DSCTitle)
                    $This.ResourceParameters[$ValueKey] = $Name
                }
            }
        }
    }

    [string]GenerateTextBlock(){
        [string[]]$ResourceParametersString = @()
        foreach($Key in $This.ResourceParameters.keys){
            $ResourceParametersString += "           $Key = $($This.ResourceParameters[$Key])"
        }

        <# Example of formatted definition
            if($ExcludeList -notcontains '1.1.3' -and $LevelOne){
                AccountPolicy "(L1) Ensure Minimum password age is set to 1 or more day(s)"
                {
                    Minimum_Password_Age = $113MinimumPasswordAge
                    Name = 'Minimum_Password_Age'
                }
            }
        #>

        $blankDefinition = @'
    if($ExcludeList -notcontains '{0}' -and ${1}){{
        {2} "{3}"
        {{
{4}
        }}
    }}
'@

        [string]$Title = $This.Recommendation.DSCTitle

        #Some recommendations result in multiple settings being changed. Since DSC requires unique titles a (#) is appended to what would otherwise be breaking duplicates in the resource.
        [int]$TitleCount = ($script:UsedResourceTitles | Where-Object -FilterScript {$_ -eq $Title} | Measure-Object).count
        if($TitleCount -gt 1){
            $Title = "$($Title) ($($TitleCount))"
        }

        $Replacements = @(
            $This.Recommendation.RecommendationNum,
            $This.Recommendation.Level,
            $This.ResourceType,
            $Title,
            ($ResourceParametersString -join "`n")
        )

        return ($blankDefinition -f $Replacements)
    }
}

$script:BenchmarkRecommendations = @{}
$script:StaticCorrections = @{}
[string[]]$script:UsedResourceTitles = @()
[int]$script:ServiceSection = 0
[int]$script:UserSection = 0

$script:DSCConfigurationParameters = @(
    [DSCConfigurationParameter]::new('$ExcludeList','[string[]]','@()','blank'),
    [DSCConfigurationParameter]::new('$LevelOne','[boolean]','$true','blank'),
    [DSCConfigurationParameter]::new('$LevelTwo','[boolean]','$false','blank'),
    [DSCConfigurationParameter]::new('$BitLocker','[boolean]','$false','blank'),
    [DSCConfigurationParameter]::new('$NextGenerationWindowsSecurity','[boolean]','$false','blank')
)

[System.Collections.ArrayList]$script:ScaffoldingBlocks = @()

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