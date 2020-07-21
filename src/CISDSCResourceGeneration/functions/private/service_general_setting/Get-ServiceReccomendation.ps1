function Get-ServiceReccomendation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$serviceHash
    )

    begin {

    }

    process {
        $searchString = "$($serviceHash['Name'])"
        $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
            $_.title -like "*$($searchString)*" -and
            $_.TopLevelSection -eq $script:ServiceSection
        })

        $Reccomendation
    }

    end {

    }
}