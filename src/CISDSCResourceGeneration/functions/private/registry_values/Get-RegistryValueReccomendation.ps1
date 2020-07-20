function Get-RegistryValueReccomendation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$regHash
    )

    begin {

    }

    process {
        #A regex pattern is generated to find an exact match for the registry key since occasionally some keys only differ in the last few characters so wrapping it in wildcards can return false results.
        $patternString = "(?i)^($($regHash['Key'] -replace 'HKLM:','HKEY_LOCAL_MACHINE'):$($regHash['ValueName']))$".replace("\","\\")
        $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
            ($_.'audit procedure' -split "`n") -match $patternString
        })

        $Reccomendation
    }

    end {

    }
}