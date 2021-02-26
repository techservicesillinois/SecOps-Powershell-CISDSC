<#
.Synopsis
   Takes a CIS Excel benchmark and operating system name to determine what worksheets inside the benchmark are relevant.
   Primairly filters out the License and the opposite worksheets for member server and domain controller.
.DESCRIPTION
   Takes a CIS Excel benchmark and operating system name to determine what worksheets inside the benchmark are relevant.
   Primairly filters out the License and the opposite worksheets for member server and domain controller.
.PARAMETER Path
    Path to the excel document from CIS for the benchmark documentation.
.PARAMETER OS
    The operating system the benchmark is written for. This will seperate member server and domain controller worksheets.
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
                $FilterScript = {$_.Name -ne 'License' -and $_.Name -notlike "*Domain Controller"}
            }

            {$_ -like '*Domain Controller'}{
                $FilterScript = {$_.Name -ne 'License' -and $_.Name -notlike "*Member Server"}
            }

            Default{
                $FilterScript = {$_.Name -ne 'License'}
            }
        }

        Get-ExcelSheetInfo -Path $Path | Where-Object -FilterScript $FilterScript
    }

    end {

    }
}