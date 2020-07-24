function Get-SystemAccessRecommendation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$SystemAccessHash
    )

    begin {

    }

    process {
        #Wildcards are used instead of spaces because CIS puts ':' in these policy names.
        $searchString = $SystemAccessHash['Name'].replace('_','*')
        $Recommendation = $script:BenchmarkRecommendations.Values.Where({
            $_.title -like "*'$($searchString)'*"
        })

        $Recommendation
    }

    end {

    }
}