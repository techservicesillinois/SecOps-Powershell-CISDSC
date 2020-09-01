function Export-RecommendationErrors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )

    begin {

    }

    process {
        if($script:RecommendationErrors){
            [string]$RecommendationErrorsPath = Join-Path -Path $OutputPath -ChildPath 'RecommendationErrors.txt'
            $script:RecommendationErrors | Out-File -FilePath $RecommendationErrorsPath
        }
    }

    end {

    }
}