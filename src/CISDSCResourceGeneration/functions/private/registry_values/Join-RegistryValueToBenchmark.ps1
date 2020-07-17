function Join-RegistryValueToBenchmark {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$regHash
    )

    begin {

    }

    process {

        [string]$CISKey = "$($regHash['Key'] -replace 'HKLM:','HKEY_LOCAL_MACHINE'):$($regHash['ValueName'])"
        $Reccomendation = $script:BenchmarkReccomendations.Values.Where({$_.'audit procedure' -like "*$($CISKey)*"})

        @{
            'Reccomendation' = $Reccomendation
            'DSCParameters' = $regHash
            'DSCResourceType' = 'Registry'
        }
    }

    end {

    }
}