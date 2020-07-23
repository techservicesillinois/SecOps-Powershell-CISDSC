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

        if($script:StaticCorrections[$searchString]){
            $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
                $_.'recommendation #' -eq $script:StaticCorrections[$searchString]
            })
        }
        else{
            $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
                $_.title -like "*$($searchString)*" -and
                $_.TopLevelSection -eq $script:ServiceSection
            })
        }

        $Reccomendation
    }

    end {

    }
}