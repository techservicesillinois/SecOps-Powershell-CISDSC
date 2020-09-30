<#
.Synopsis
   This function generates the properties section of the markdown documentation for resource parameters.
   Based on Microsoft's template https://github.com/MicrosoftDocs/PowerShell-Docs/blob/staging/reference/docs-conceptual/dsc/reference/resources/windows/registryResource.md
.DESCRIPTION
   This function generates the properties section of the markdown documentation for resource parameters.
   Based on Microsoft's template https://github.com/MicrosoftDocs/PowerShell-Docs/blob/staging/reference/docs-conceptual/dsc/reference/resources/windows/registryResource.md
.PARAMETER Recommendations
    Recommendations to pull the text from. This is generated as part of the DSCConfigParameter property.
.PARAMETER Levels
    All applicable levels from the provided recommendations. Value is provided by Get-ApplicableLevels
.EXAMPLE
    [string[]]$Levels = @()
    $Levels += Get-ApplicableLevels -Recommendations $FoundRecommendations
    $DocumentationPropertyBlock = Get-DSCDocumentationPropertyTable -Recommendations $FoundRecommendations -Levels $Levels
#>
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