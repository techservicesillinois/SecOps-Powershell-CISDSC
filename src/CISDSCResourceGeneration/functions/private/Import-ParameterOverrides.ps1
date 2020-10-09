<#
.Synopsis
   Imports parameter overrides from the provided CSV. Expects the headers "Recommendation" & "HasParameter". HasParameter is a "0" or "1" value specifying if it should (1) or should not (0) be given a parameter.
.DESCRIPTION
   Imports parameter overrides from the provided CSV. Expects the headers "Recommendation" & "HasParameter". HasParameter is a "0" or "1" value specifying if it should (1) or should not (0) be given a parameter.
.PARAMETER Path
    Path to the CSV file.
.EXAMPLE
    Import-ParameterOverrides -Path '.\Parameter_Overrides.csv'
#>
function Import-ParameterOverrides {
    [CmdletBinding()]
    param (
        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$Path
    )

    begin {
        $script:ParameterOverrides.Clear()
    }

    process {
        Import-Csv -Path $Path | ForEach-Object -Process {
            # Has parameter is double cast because Import-CSV will import the 0/1 value as a string and a non-empty string will always be true.
            # Converting to int then bool solves this problem.
            $script:ParameterOverrides.add($_.Recommendation,[Boolean][int]$_.HasParameter)
        }
    }

    end {
    }
}