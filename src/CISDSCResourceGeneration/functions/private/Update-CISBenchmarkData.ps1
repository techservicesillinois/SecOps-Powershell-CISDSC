<#
.Synopsis
   Takes a CIS Excel benchmark and converts the contents into [Recommendation] objects stored in $script:BenchmarkRecommendations
   This will also set values for $script:ServiceSection and $script:UserSection that are useful for some detections.
.DESCRIPTION
   Takes a CIS Excel benchmark and converts the contents into [Recommendation] objects stored in $script:BenchmarkRecommendations
   This will also set values for $script:ServiceSection and $script:UserSection that are useful for some detections.
.PARAMETER Path
    Path to the excel document from CIS for the benchmark documentation.
.PARAMETER OS
    The operating system the benchmark is written for. This will seperate member server and domain controller worksheets.
.EXAMPLE
    Update-CISBenchmarkData -Path '.\CIS_Microsoft_Windows_10_Enterprise_Release_1909_Benchmark_v1.8.1.xlsx' -OS 'Microsoft Windows 10 Enterprise'
#>
function Update-CISBenchmarkData {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$OS
    )

    begin {

    }

    process {
        switch($OS){
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

        Get-ExcelSheetInfo -Path $Path | Where-Object -FilterScript $FilterScript | ForEach-Object -Process {
            Import-Excel -Path $Path -DataOnly -WorksheetName $_.Name | ForEach-Object -Process {
                try{
                    if($_.'recommendation #'){
                        $script:BenchmarkRecommendations.add($_.'recommendation #',([Recommendation]::New($_)))
                    }
                    else{
                        switch($_.title){
                            'System Services'{$script:ServiceSection = $_.'section #'}
                            'Administrative Templates (User)'{$script:UserSection = $_.'section #'}
                            Default{}
                        }
                    }
                }
                catch [System.Management.Automation.MethodInvocationException]{
                    #Recommendations are commonly duplicated between worksheets for different combinations of benchmarks so we ignore duplicate key exceptions.
                    if($_.ToString() -notlike "*`"Add`" with `"2`" argument(s): `"Item has already been added. Key in dictionary: '*'  Key being added: '*'`""){
                        throw $_
                    }
                }
            }
        }
    }

    end {

    }
}