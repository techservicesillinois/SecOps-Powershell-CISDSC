<#
.Synopsis
   Recursively finds all 'GptTmpl.inf' files in the provided directory that contain misc. settings.
   Some information on these files can be found here: http://techgenix.com/group-policy-settings-part1/
   Ex: Registry Values, Privilege Rights, System Access, and Service General Setting.
.DESCRIPTION
   Recursively finds all 'GptTmpl.inf' files in the provided directory that contain misc. settings.
   Some information on these files can be found here: http://techgenix.com/group-policy-settings-part1/
   Ex: Registry Values, Privilege Rights, System Access, and Service General Setting.
.PARAMETER GPOPath
    Path to the GPO files (build kit) from CIS containing the benchmarks settings.
.EXAMPLE
#>
function Import-GptTmpl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$GPOPath
    )

    begin {

    }

    process {
        Get-ChildItem -Path $GPOPath -Filter 'GptTmpl.inf' -Recurse | Foreach-Object -Process {
            Write-Verbose -Message "Importing $($_.FullName)"
            $ini = Get-IniContent -Path $_.fullname

            foreach($key in $ini.Keys){
                foreach($subKey in $ini[$key].Keys){
                    switch($key){
                        #Encoding statement for the file that we don't care about.
                        'Unicode' {Write-Debug -Message 'Skipping Unicode section'}
                        #Version statement for the file that we also don't care about.
                        'Version' {Write-Debug -Message 'Skipping Version section'}
                        'Registry Values' {ConvertFrom-RegistryValueRawGPO -Key $subkey -ValueData $ini[$key][$subKey]}
                        'Privilege Rights' {ConvertFrom-PrivilegeRightRawGPO -Policy $subkey -Identity $ini[$key][$subKey]}
                        'System Access' {ConvertFrom-SystemAccessRawGPO -Key $subkey -SecurityData $ini[$key][$subKey]}
                        'Service General Setting' {ConvertFrom-ServiceRawGPO -Service $subkey}
                        Default {Write-Warning -Message "Inf: $($Key) not yet supported."}
                    }
                }
            }
        }
    }

    end {

    }
}