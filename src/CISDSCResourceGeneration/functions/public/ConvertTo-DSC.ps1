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

        [System.Collections.ArrayList]$ScaffoldingBlocks = @()

        Get-ChildItem -Path $GPOPath -Filter 'GptTmpl.inf' -Recurse | Foreach-Object -Process {
            $ini = Get-IniContent -Path $_.fullname

            foreach($key in $ini.Keys){
                foreach($subKey in $ini[$key].Keys){
                    switch($key){
                        'Unicode' {Write-Verbose -Message 'Skipping Unicode section'}
                        'Version' {Write-Verbose -Message 'Skipping Version section'}
                        'Registry Values' {$ScaffoldingBlocks += ConvertFrom-RegistryValueRawGPO -Key $subkey -ValueData $ini[$key][$subKey]}
                        'Privilege Rights' {$ScaffoldingBlocks += ConvertFrom-PrivilegeRightRawGPO -Policy $subkey -Identity $ini[$key][$subKey]}
                        'System Access' {$ScaffoldingBlocks += ConvertFrom-SystemAccessRawGPO -Key $subkey -SecurityData $ini[$key][$subKey]}
                        Default {Write-Warning -Message "$($Key) not yet supported."}
                    }
                }
            }
        }

        $ScaffoldingBlocks
    }

    end {

    }
}