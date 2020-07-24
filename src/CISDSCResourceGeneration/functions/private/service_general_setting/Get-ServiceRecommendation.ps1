function Get-ServiceRecommendation {
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
            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                $_.'recommendation #' -eq $script:StaticCorrections[$searchString]
            })
        }
        else{
            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                $_.title -like "*$($searchString)*" -and
                $_.TopLevelSection -eq $script:ServiceSection
            })
        }

        $Recommendation
    }

    end {

    }
}