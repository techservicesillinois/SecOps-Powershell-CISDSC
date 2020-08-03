function Find-MissingRecommendations {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$OutputPath
    )

    begin {

    }

    process {
        $CompareSplat = @{
            'ReferenceObject' = ($script:BenchmarkRecommendations.Values | Where-Object -FilterScript {$_.TopLevelSection -ne $script:UserSection}).RecommendationNum
            'DifferenceObject' = (($script:ScaffoldingBlocks).Recommendation.RecommendationNum | Get-Unique)
        }

        $MissingRecommendations = @()
        $MissingRecommendations += (Compare-Object @CompareSplat | Where-Object -FilterScript {$_.SideIndicator -eq '<='}).InputObject
        [int]$MissingRecommendationsCount = ($MissingRecommendations | Measure-Object).count

        if($MissingRecommendationsCount -gt 0){
            [string]$MissingRecommendationsPath = Join-Path -Path $OutputPath -ChildPath 'MissingRecommendations.txt'
            $MissingRecommendations | Out-File -FilePath $MissingRecommendationsPath -Force
            Write-Warning -Message "$($MissingRecommendationsCount) Missing Recommendations found. List can be found at '$($MissingRecommendationsPath)'"
        }
    }

    end {

    }
}