function ConvertTo-DSC {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$BenchmarkPath,

        [Parameter(Mandatory=$true)]
        [string]$GPOPath
    )

    begin {

    }

    process {
        Update-CISBenchmarkData -Path $BenchmarkPath

        Get-ChildItem -Path $GPOPath -Filter 'GptTmpl.inf' -Recurse | Foreach-Object -Process {
            $ini = Get-IniContent -Path $_.fullname

            foreach($key in $ini.Keys){
                foreach($subKey in $ini[$key].Keys){
                    switch($key){
                        "Registry Values" {$RegistrySettings += Get-GPORegistryINFData -Key $subkey -ValueData $ini[$key][$subKey]}
                        "Privilege Rights" { $ConfigString += Write-GPOPrivilegeINFData -Privilege $subkey -PrivilegeData $ini[$key][$subKey] } #ToDo
                        Default {Write-Warning -Message "$($Key) not yet supported."}
                    }
                }
            }
        }
    }

    end {

    }
}