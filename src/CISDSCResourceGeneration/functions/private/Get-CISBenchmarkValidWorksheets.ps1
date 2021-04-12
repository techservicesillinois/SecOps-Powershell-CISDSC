<#
.Synopsis
    Takes a CIS Excel benchmark and operating system name to determine what worksheets inside the benchmark are relevant.
    Primairly filters out the License and the opposite worksheets for member server and domain controller.
.DESCRIPTION
    Takes a CIS Excel benchmark and operating system name to determine what worksheets inside the benchmark are relevant.
    Primairly filters out the License and the opposite worksheets for member server and domain controller.
.PARAMETER Path
    Path to the excel document from CIS for the benchmark documentation.
.PARAMETER System
    The operating system or software the benchmark is written for. This will determine which worksheets are valid to import.
.EXAMPLE
    Get-CISBenchmarkValidWorksheet -Path '.\CIS_Microsoft_Windows_10_Enterprise_Release_1909_Benchmark_v1.8.1.xlsx' -OS 'Microsoft Windows 10 Enterprise'
#>
function Get-CISBenchmarkValidWorksheets {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$System
    )

    begin {
    }

    process {
        switch($System){
            {$_ -like '*Member Server'}{
                $FilterScript = {$_.Name -like "*Member Server"}
            }

            {$_ -like '*Domain Controller'}{
                $FilterScript = {$_.Name -like"*Member Server"}
            }

            Default{
                $FilterScript = {$_.Name -notin ('License','Overview - Glossary') -and $_.Name -notlike "MITRE*" }
            }
        }

        Get-ExcelSheetInfo -Path $Path | Where-Object -FilterScript $FilterScript
    }

    end {
    }
}
