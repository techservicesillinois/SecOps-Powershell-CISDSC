<#
.Synopsis
    Gets the unique list of levels from a collection of recommendation objects. This is utilized by multiple functions to ensure this operation is centralized and only executed once.
.DESCRIPTION
    Gets the unique list of levels from a collection of recommendation objects. This is utilized by multiple functions to ensure this operation is centralized and only executed once.
.PARAMETER Recommendations
    Recommendations to get the level information from
.EXAMPLE
    [string[]]$Levels = @()
    $Levels += Get-ApplicableLevels -Recommendations $FoundRecommendations
#>
function Get-ApplicableLevels {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns',
            Justification = 'This always deals with multiples')]
    [OutputType('System.String')]
    param (
        [Recommendation[]]$Recommendations
    )

    begin {
    }

    process {
        [string[]]$Levels = @()
        $Levels += ($Recommendations).Level | Select-Object -Unique

        Return $Levels
    }

    end {
    }
}
