<#
.Synopsis
   Recursively finds all 'registry.pol' files in the provided directory that contain abstracted registry settings.
   These are settings defined by admx templates that result in registry settings. They differ from a GptTmpl.inf registry values
   because they are not explictly configured within group policy as registry keys.

   This function relies on the GPRegistryPolicyParser module by MicroSoft. https://github.com/PowerShell/GPRegistryPolicyParser
.DESCRIPTION
   Recursively finds all 'registry.pol' files in the provided directory that contain abstracted registry settings.
   These are settings defined by admx templates that result in registry settings. They differ from a GptTmpl.inf registry values
   because they are not explictly configured within group policy as registry keys.

   This function relies on the GPRegistryPolicyParser module by MicroSoft. https://github.com/PowerShell/GPRegistryPolicyParser
.PARAMETER GPOPath
    Path to the GPO files (build kit) from CIS containing the benchmarks settings.
.EXAMPLE
#>
function Import-RegistryPol {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$GPOPath
    )

    begin {

    }

    process {
        Get-ChildItem -Path $GPOPath -Filter 'registry.pol' -Recurse | ForEach-Object -Process {
            Write-Verbose -Message "Importing $($_.FullName)"
            $PolicyData = Read-PolFile -Path $_.FullName

            Foreach ($Policy in $PolicyData) {
                switch ($_.Directory.BaseName) {
                    'Machine' { ConvertFrom-RegistryPolGPORaw -KeyName $Policy.KeyName -ValueName $Policy.ValueName -ValueData $Policy.ValueData -ValueType $Policy.ValueType }
                    'User' { Write-Debug -Message 'Registry POL: Skipping user hive.' }
                    Default { Write-Warning -Message "Registry POL: Unknown Registry hive $($_)." }
                }
            }
        }
    }

    end {

    }
}