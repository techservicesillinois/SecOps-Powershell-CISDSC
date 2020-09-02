<#
.Synopsis
   Imports parameter validations from the provided CSV. Expects the headers "Recommendation" & "ValidationString" with an example row of "1.2.1","[ValidateRange(15,99999)]"
.DESCRIPTION
   Imports parameter validations from the provided CSV. Expects the headers "Recommendation" & "ValidationString" with an example row of "1.2.1","[ValidateRange(15,99999)]"
.PARAMETER Path
    Path to the CSV file.
.EXAMPLE
    Import-ParameterValidations -Path '.\parameter_validations.csv'
#>
function Import-ParameterValidations {
    [CmdletBinding()]
    param (
        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$Path
    )

    begin {
        $script:ParameterValidations.Clear()
    }

    process {
        Import-Csv -Path $Path | ForEach-Object -Process {
            $script:ParameterValidations.add($_.Recommendation,$_.ValidationString)
        }
    }

    end {

    }
}