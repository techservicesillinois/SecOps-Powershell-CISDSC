function Get-PrivilegeRightRecommendation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$privilegeHash
    )

    begin {

    }

    process {
        $searchString = $privilegeHash['Policy'].replace('_',' ')

        if($script:StaticCorrections[$searchString]){
            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                $_.'recommendation #' -eq $script:StaticCorrections[$searchString]
            })
        }
        else{
            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                $_.title -like "*'$($searchString)'*"
            })
        }

        $Recommendation
    }

    end {

    }
}