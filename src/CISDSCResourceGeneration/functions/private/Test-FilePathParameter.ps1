function Test-FilePathParameter {
    [CmdletBinding()]
    [OutputType('System.Boolean')]
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
            $false
            Throw "Invalid path given: $($Path)"
        }
    }

    end {

    }
}