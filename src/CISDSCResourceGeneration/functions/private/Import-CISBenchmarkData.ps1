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
    Import-CISBenchmarkData -Path '.\CIS_Microsoft_Windows_10_Enterprise_Release_1909_Benchmark_v1.8.1.xlsx' -OS 'Microsoft Windows 10 Enterprise'
#>
function Import-CISBenchmarkData {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$System
    )

    begin {
        $script:BenchmarkRecommendations.Clear()
    }

    process {
        Get-CISBenchmarkValidWorksheets -Path $Path -System $System | ForEach-Object -Process {
            Import-Excel -Path $Path -DataOnly -WorksheetName $_.Name | ForEach-Object -Process {
                try{
                    if($_.'recommendation #'){
                        # For some reason I do not understand a switch statement here just does not work.
                        if($_.title -eq "(L1) Configure 'Interactive logon: Message text for users attempting to log on'"){
                            $script:LegalNoticeTextNum = $_.'recommendation #'
                        }
                        elseif($_.title -eq "(L1) Configure 'Interactive logon: Message title for users attempting to log on'"){
                            $script:LegalNoticeCaptionNum = $_.'recommendation #'
                        }
                        elseif($_.title -eq "(L1) Configure 'Accounts: Rename administrator account'"){
                            $script:AccountsRenameadministratoraccountNum = $_.'recommendation #'
                        }
                        elseif($_.title -eq "(L1) Configure 'Accounts: Rename guest account'"){
                            $script:AccountsRenameguestaccountNum = $_.'recommendation #'
                        }

                        $script:BenchmarkRecommendations.add($_.'recommendation #',([Recommendation]::New($_)))
                    }
                    else{
                        if($_.title -eq 'System Services'){
                            $script:ServiceSection = $_.'section #'
                        }
                        elseif($_.title -eq 'Administrative Templates (User)'){
                            $script:UserSection = $_.'section #'
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