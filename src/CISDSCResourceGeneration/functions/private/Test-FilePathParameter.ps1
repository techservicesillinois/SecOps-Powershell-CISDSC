function Test-FilePathParameter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    begin {

    }

    process {
        If(Test-Path -Path $Path){
            $true
        }
        else{
            Throw "Invalid path given: $($Path)"
        }
    }

    end {

    }
}