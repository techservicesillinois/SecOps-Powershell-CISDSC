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
        $DSCConfigurationParameters += '        [string[]]$ExcludeList = @()'

        if($Levels -contains 'LevelOne'){
            $DSCConfigurationParameters += '        [boolean]$LevelOne = $true'
        }
        if($Levels -contains 'LevelTwo'){
            $DSCConfigurationParameters += '        [boolean]$LevelTwo = $false'
        }
        if($Levels -contains 'BitLocker'){
            $DSCConfigurationParameters += '        [boolean]$BitLocker = $false'
        }
        if($Levels -contains 'NextGenerationWindowsSecurity'){
            $DSCConfigurationParameters += '        [boolean]$NextGenerationWindowsSecurity = $false'
        }

        $DSCConfigurationParameters += (($Recommendations).DSCConfigParameter | Sort-Object -Property 'Name').TextBlock

        Return $DSCConfigurationParameters
    }

    end {

    }
}