<#
.Synopsis
   Audits the scaffoldingblocks to identify any GPO settings that did not locate a match in the CIS benchmarks.
   Common situations for these are:
    1) The registry key or setting name has changed and was only updated in the GPO
    2) The recommendation broke a formating standard
    3) The GPO setting is slightly off. IE: Enables success/failure auditing when the benchmark only says success.

    This is used to idenfity settings that will require an entry in the static corrections file.
    Any errors found will be exported in a file at the $OutputPath named 'RecommendationErrors.ps1'
.DESCRIPTION
   Audits the scaffoldingblocks to identify any GPO settings that did not locate a match in the CIS benchmarks.
   Common situations for these are:
    1) The registry key or setting name has changed and was only updated in the GPO
    2) The recommendation broke a formating standard
    3) The GPO setting is slightly off. IE: Enables success/failure auditing when the benchmark only says success.

    This is used to idenfity settings that will require an entry in the static corrections file.
    Any errors found will be exported in a file at the $OutputPath named 'RecommendationErrors.ps1'
.PARAMETER OutputPath
    Output directory for the files generated.
.EXAMPLE
#>
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