function Find-RecommendationErrors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$OutputPath
    )

    begin {

    }

    process {
        $RecommendationErrors = $script:ScaffoldingBlocks | Where-Object -FilterScript {($_.Recommendation | Measure-Object).count -ne 1}

        if($RecommendationErrors){
            [string]$RecommendationErrorsPath = Join-Path -Path $OutputPath -ChildPath 'RecommendationErrors.ps1'
            Set-Content -Path $RecommendationErrorsPath -Value "$($RecommendationErrors.count) errors found. The bellow blocks where not able to be automatically matched to a Recommendation in '$($RecommendationErrorsPath)'.`n" -Force
            Add-Content -Path $RecommendationErrorsPath -Value (($RecommendationErrors).TextBlock -join "`n")
            Write-Warning -Message "$($RecommendationErrors.count) errors found. Settings that require manual intervention can be found at '$($RecommendationErrorsPath)'"
        }
    }

    end {

    }
}