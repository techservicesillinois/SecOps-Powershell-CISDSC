function Get-BenchmarkLevelFromTitle {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Title
    )

    begin {

    }

    process {
        [regex]$LevelPattern = '^\(.{2}\)'

        switch($LevelPattern.Match($Title).Value){
            '(L1)'{'LevelOne'}
            '(L2)'{'LevelTwo'}
            '(BL)'{'BitLocker'}
            '(NG)'{'NextGenerationWindowsSecurity'}
            default {[string]::Empty}
        }
    }

    end {

    }
}