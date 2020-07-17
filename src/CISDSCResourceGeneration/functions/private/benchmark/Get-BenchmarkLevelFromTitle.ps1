function Get-BenchmarkLevelFromTitle {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
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