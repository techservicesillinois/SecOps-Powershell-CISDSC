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

        #Something somewhere causes a blank line to make it's way in here and the Where-Object filters it out.
        $DSCConfigurationParameters += (($Recommendations).DSCConfigParameter | Sort-Object -Property 'Name').TextBlock | Where-Object -FilterScript { $_ }

        Return $DSCConfigurationParameters
    }

    end {

    }
}