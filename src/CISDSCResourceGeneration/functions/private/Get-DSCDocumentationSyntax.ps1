<#
.Synopsis
   This function generates the syntax section of the markdown documentation for resource parameters.
   Based on Microsoft's template https://github.com/MicrosoftDocs/PowerShell-Docs/blob/staging/reference/docs-conceptual/dsc/reference/resources/windows/registryResource.md
.DESCRIPTION
   This function generates the syntax section of the markdown documentation for resource parameters.
   Based on Microsoft's template https://github.com/MicrosoftDocs/PowerShell-Docs/blob/staging/reference/docs-conceptual/dsc/reference/resources/windows/registryResource.md
.PARAMETER Recommendations
    Recommendations to pull the text from. This is generated as part of the DSCConfigParameter property.
.PARAMETER Levels
    All applicable levels from the provided recommendations. Value is provided by Get-ApplicableLevels
.EXAMPLE
    [string[]]$Levels = @()
    $Levels += Get-ApplicableLevels -Recommendations $FoundRecommendations
    $DocumentationSyntaxBlock = Get-DSCDocumentationSyntax -Recommendations $FoundRecommendations -Levels $Levels
#>
function Get-DSCDocumentationSyntax {
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
        $Documentation += '    [ ExclusionList = [String[]] ]'

        if($Levels -contains 'LevelOne'){
            $Documentation += '    [ LevelOne = [Boolean] ]'
        }
        if($Levels -contains 'LevelTwo'){
            $Documentation += '    [ LevelTwo = [Boolean] ]'
        }
        if($Levels -contains 'BitLocker'){
            $Documentation += '    [ BitLocker = [Boolean] ]'
        }
        if($Levels -contains 'NextGenerationWindowsSecurity'){
            $Documentation += '    [ NextGenerationWindowsSecurity = [Boolean] ]'
        }

        $Documentation += (($Recommendations).DSCConfigParameter | Sort-Object -Property 'Name').DocumentationSyntaxBlock

        Return $Documentation
    }

    end {
    }
}