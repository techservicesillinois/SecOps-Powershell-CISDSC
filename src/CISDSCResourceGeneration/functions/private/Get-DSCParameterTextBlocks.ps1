<#
.Synopsis
    Returns the paramblock enteries for the generated DSC resource. Applicable default parameters such as levels are checked for relevance and the rest are imported from generated code blocks.
.DESCRIPTION
    Returns the paramblock enteries for the generated DSC resource. Applicable default parameters such as levels are checked for relevance and the rest are imported from generated code blocks.
.PARAMETER Recommendations
    Recommendation objects.
.PARAMETER Levels
    Relevant benchmark levels
#>
function Get-DSCParameterTextBlocks {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns',
            Justification = 'This always deals with multiples')]
    [OutputType('System.String')]
    param (
        [Recommendation[]]$Recommendations,
        [System.String[]]$Levels
    )

    begin {
    }

    process {
        [System.Collections.ArrayList]$DSCConfigurationParameters = @()
        $DSCConfigurationParameters += '        [String[]]$ExcludeList = @()'

        if($Levels -contains 'LevelOne'){
            $DSCConfigurationParameters += '        [Boolean]$LevelOne = $true'
        }
        if($Levels -contains 'LevelTwo'){
            $DSCConfigurationParameters += '        [Boolean]$LevelTwo = $false'
        }
        if($Levels -contains 'BitLocker'){
            $DSCConfigurationParameters += '        [Boolean]$BitLocker = $false'
        }
        if($Levels -contains 'NextGenerationWindowsSecurity'){
            $DSCConfigurationParameters += '        [Boolean]$NextGenerationWindowsSecurity = $false'
        }

        #Something somewhere causes a blank line to make it's way in here and the Where-Object filters it out.
        $DSCConfigurationParameters += (($Recommendations).DSCConfigParameter | Sort-Object -Property 'Name').TextBlock | Where-Object -FilterScript { $_ }

        Return $DSCConfigurationParameters
    }

    end {

    }
}
