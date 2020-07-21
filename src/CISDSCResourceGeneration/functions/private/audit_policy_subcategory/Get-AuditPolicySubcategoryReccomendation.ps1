function Get-AuditPolicySubcategoryReccomendation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Subcategory,

        [Parameter(Mandatory = $true)]
        [string]$InclusionSetting
    )

    begin {

    }

    process {

        $SearchString = "'$($Subcategory)'*'$($InclusionSetting)'"
        $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
            $_.title -like "*$($SearchString)"
        })

        $Reccomendation
    }

    end {

    }
}