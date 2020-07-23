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
        if($script:StaticCorrections[$Subcategory]){
            $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
                $_.'recommendation #' -eq $script:StaticCorrections[$Subcategory]
            })
        }
        else{
            $SearchString = "Ensure '$($Subcategory)'*'$($InclusionSetting)'"

            $Reccomendation = $script:BenchmarkReccomendations.Values.Where({
                $_.title -like "*$($SearchString)"
            })
        }

        $Reccomendation
    }

    end {

    }
}