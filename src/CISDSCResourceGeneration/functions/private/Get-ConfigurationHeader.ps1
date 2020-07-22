function Get-ConfigurationHeader {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ResourceName
    )

    begin {

    }

    process {
        [string]$RawConfiguration = @'
Configuration {0}
{{
    param
    (
{1}
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion '1.4.0.0'
    Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion '2.10.0.0'

'@

        $RawConfiguration -f $ResourceName,(($script:DSCConfigurationParameters).TextBlock -join ",`n")
    }

    end {

    }
}