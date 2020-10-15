function Get-DSCParameterTextBlocks {
    [CmdletBinding()]
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

        $DSCConfigurationParameters += (($Recommendations).DSCConfigParameter | Sort-Object -Property 'Name').TextBlock

        Return $DSCConfigurationParameters
    }

    end {

    }
}