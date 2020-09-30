function Get-DSCDocumentationPropertyTable {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Recommendation[]]$Recommendations,
        [string[]]$Levels
    )

    begin {
    }

    process {
        [string[]]$Documentation = @()
        $Documentation += '|ExcludeList | | |Excludes the provided recommendation IDs from the configuration |'

        if($Levels -contains 'LevelOne'){
            $Documentation += '|LevelOne |`$true` | |Applies level one recommendations |'
        }
        if($Levels -contains 'LevelTwo'){
            $Documentation += '|LevelTwo |`$false` | |Applies level two recommendations. Does not include level one, both must be set to `$true`. |'
        }
        if($Levels -contains 'BitLocker'){
            $Documentation += '|BitLocker |`$false` | |Applies bitlocker recommendations |'
        }
        if($Levels -contains 'NextGenerationWindowsSecurity'){
            $Documentation += '|NextGenerationWindowsSecurity |`$false` | |Applies Next Generation Windows Security recommendations |'
        }

        $Documentation += (($Recommendations).DSCConfigParameter | Sort-Object -Property 'Name').DocumentationPropertyBlock

        Return $Documentation
    }

    end {
    }
}