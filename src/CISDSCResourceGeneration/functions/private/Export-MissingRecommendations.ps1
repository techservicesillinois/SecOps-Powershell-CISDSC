<#
.Synopsis
    Exports a list of imported recommendations that did not have a setting identified in the provided GPOs.
    The user section of the benchmark and 18.2.1 (L1) Ensure LAPS AdmPwd GPO Extension / CSE is installed are ignored by this check.
.DESCRIPTION
    Exports a list of imported recommendations that did not have a setting identified in the provided GPOs.
    The user section of the benchmark and 18.2.1 (L1) Ensure LAPS AdmPwd GPO Extension / CSE is installed are ignored by this check.
.PARAMETER OutputPath
    Output directory for the files generated.
#>
function Export-MissingRecommendations {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This always deals with multiples')]
    param (
        [Parameter(Mandatory=$true)]
        [string]$OutputPath
    )

    begin {

    }

    process {
        [System.Collections.ArrayList]$MissingRecommendations = @()
        #The user section is ignored for this check because user based settings are not possible via DSC and will always be blank.
        #18.2.1 (L1) Ensure LAPS AdmPwd GPO Extension / CSE is installed is explictly ignored because this is a software installation that won't be supported at this time.
        $MissingRecommendations += ($script:BenchmarkRecommendations).Values | Where-Object -FilterScript {!$_.ResourceParameters -and $_.TopLevelSection -ne $script:UserSection -and $_.RecommendationNum -ne '18.2.1'}

        if($MissingRecommendations){
            [string]$RecommendationErrorsPath = Join-Path -Path $OutputPath -ChildPath 'MissingRecommendation.csv'
            $MissingRecommendations | Export-Csv -Path $RecommendationErrorsPath -NoTypeInformation -Force
        }
    }

    end {

    }
}
