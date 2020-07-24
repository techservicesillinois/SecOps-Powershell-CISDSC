function Get-RegistryValueRecommendation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$regHash
    )

    begin {

    }

    process {
        [string]$Key = "$($regHash['Key'] -replace 'HKLM:','HKEY_LOCAL_MACHINE'):$($regHash['ValueName'])"

        if($script:StaticCorrections[$Key]){
            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                $_.'recommendation #' -eq $script:StaticCorrections[$Key]
            })
        }
        else{
            #A regex pattern is generated to find an exact match for the registry key since occasionally some keys only differ in the last few characters so wrapping it in wildcards can return false results.
            $patternString = "(?i)^($($Key))$".replace("\","\\")
            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                ($_.'audit procedure' -split "`n") -match $patternString
            })
        }

        $Recommendation
    }

    end {

    }
}