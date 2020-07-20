function Get-SystemAccessReccomendation {
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
        $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
            $_.title -like "*'$($searchString)'*"
        })

        $Reccomendation
    }

    end {

    }
}