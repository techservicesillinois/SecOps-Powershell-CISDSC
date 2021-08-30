<#
.Synopsis
    Imports static corrections from the provided CSV. Expects the headers "Key" & "Recommendation" key syntax varies based on resource type and is documented in the static_corrections.md file of the repository.
.DESCRIPTION
    Imports static corrections from the provided CSV. Expects the headers "Key" & "Recommendation" key syntax varies based on resource type and is documented in the static_corrections.md file of the repository.
.PARAMETER Path
    Path to the CSV file.
.EXAMPLE
    Import-StaticCorrections -Path '.\static_corrections.csv'
#>
function Import-StaticCorrections {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This always deals with multiples')]
    param (
        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$Path
    )

    begin {
        $script:StaticCorrections.Clear()
    }

    process {
        Import-Csv -Path $Path | ForEach-Object -Process {
            $script:StaticCorrections.add($_.Key,$_.Recommendation)
        }
    }

    end {

    }
}
