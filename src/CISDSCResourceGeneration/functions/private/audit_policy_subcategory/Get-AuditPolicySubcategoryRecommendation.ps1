function Get-AuditPolicySubcategoryRecommendation {
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
            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                $_.'recommendation #' -eq $script:StaticCorrections[$Subcategory]
            })
        }
        else{
            $SearchString = "Ensure '$($Subcategory)'*'$($InclusionSetting)'"

            $Recommendation = $script:BenchmarkRecommendations.Values.Where({
                $_.title -like "*$($SearchString)"
            })
        }

        $Recommendation
    }

    end {

    }
}