function Get-ApplicableLevels {
    [CmdletBinding()]
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