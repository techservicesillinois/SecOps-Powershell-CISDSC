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

        if($script:StaticCorrections[$searchString]){
            $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
                $_.'recommendation #' -eq $script:StaticCorrections[$searchString]
            })
        }
        else{
            $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
                $_.title -like "*'$($searchString)'*"
            })
        }

        $Reccomendation
    }

    end {

    }
}