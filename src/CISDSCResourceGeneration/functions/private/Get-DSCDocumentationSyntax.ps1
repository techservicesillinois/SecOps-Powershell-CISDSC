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
        $Documentation += '    [ ExclusionList = [string[]] ]'

        if($Levels -contains 'LevelOne'){
            $Documentation += '    [ LevelOne = [boolean] ]'
        }
        if($Levels -contains 'LevelTwo'){
            $Documentation += '    [ LevelTwo = [boolean] ]'
        }
        if($Levels -contains 'BitLocker'){
            $Documentation += '    [ BitLocker = [boolean] ]'
        }
        if($Levels -contains 'NextGenerationWindowsSecurity'){
            $Documentation += '    [ NextGenerationWindowsSecurity = [boolean] ]'
        }

        $Documentation += (($Recommendations).DSCConfigParameter | Sort-Object -Property 'Name').DocumentationSyntaxBlock

        Return $Documentation
    }

    end {
    }
}