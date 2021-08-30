<#
.Synopsis
    Exports a list of imported GPO settings that failed to find a match in the documentation.
.DESCRIPTION
    Exports a list of imported GPO settings that failed to find a match in the documentation.
.PARAMETER OutputPath
    Output directory for the files generated.
#>
function Export-RecommendationErrors {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns',
            Justification = 'This always deals with multiples')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )

    begin {

    }

    process {
        if($script:RecommendationErrors){
            [string]$RecommendationErrorsPath = Join-Path -Path $OutputPath -ChildPath 'RecommendationErrors.txt'
            if(Test-Path -Path $RecommendationErrorsPath){
                Remove-Item -Path $RecommendationErrorsPath -Force
            }
            "$($script:RecommendationErrors.Count) recommendation errors found." | Out-File -FilePath $RecommendationErrorsPath

            $script:RecommendationErrors | ForEach-Object -Process {
                #Each hash is written seperatly with a dividing line to make it more human readable. Out-Fileing the whole array runs them all together.
                $_ | Out-File -FilePath $RecommendationErrorsPath -Append
                '------------------------------------------' | Out-File -FilePath $RecommendationErrorsPath -Append
            }
        }
    }

    end {

    }
}
