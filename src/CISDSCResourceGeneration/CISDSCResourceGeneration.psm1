[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}

Class ScaffoldingBlock
{
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
        [string[]]$DSCBlock = @()
        [string]$IfClose = [string]::Empty

        if($This.Reccomendation.Level){
            $IfClose = ' -and ${0})' -f $This.Reccomendation.Level
        }
        $IfClose += '{'

        $DSCBlock += 'if($ExcludeList -notcontains ''{0}''{1}' -f $This.Reccomendation.'recommendation #',$IfClose
        $DSCBlock += "    $($This.DSCResourceType) '$($This.Reccomendation.title)'{"

        foreach($Key in $This.DSCParameters.Keys){
            $DSCBlock += "        $Key = $($This.DSCParameters[$Key])"
        }

        $DSCBlock += "    }"
        $DSCBlock += "}"

        return ($DSCBlock -join "`n")
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