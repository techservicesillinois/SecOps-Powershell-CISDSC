function Get-PrivilegeRightReccomendation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$privilegeHash
    )

    begin {

    }

    process {
        $searchString = $privilegeHash['Policy'].replace('_',' ')
        $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
            $_.title -like "*'$($searchString)'*"
        })

        $Reccomendation
    }

    end {

    }
}