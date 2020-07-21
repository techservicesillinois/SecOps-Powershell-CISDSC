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
        [string[]]
        $ExcludeList,

        [boolean]
        $LevelOne = $true,

        [boolean]
        $LevelTwo = $false,

        [boolean]
        $BitLocker = $false,

        [boolean]
        $NextGenerationWindowsSecurity = $false
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion '1.4.0.0'
    Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion '2.10.0.0'

'@

        $RawConfiguration -f $ResourceName
    }

    end {

    }
}