function Update-CISBenchmarkData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string]
        $Path
    )

    begin {

    }

    process {
        Get-ExcelSheetInfo -Path $Path | Where-Object -FilterScript {$_.Name -ne 'License'} | ForEach-Object -Process {
            Import-Excel -Path $Path -DataOnly -WorksheetName $_.Name | ForEach-Object -Process {
                try{
                    if($_.'recommendation #'){
                        $_ | Add-Member -Name 'Level' -MemberType ScriptProperty -Value {
                            [regex]$LevelPattern = '^\(.{2}\)'
                            switch($LevelPattern.Match($This.title).Value){
                                '(L1)'{'LevelOne'}
                                '(L2)'{'LevelTwo'}
                                '(BL)'{'BitLocker'}
                                '(NG)'{'NextGenerationWindowsSecurity'}
                                default {[string]::Empty}
                            }
                        }
                        $script:BenchmarkReccomendations.add($_.'recommendation #',$_)
                    }
                    else{
                        $script:BenchmarkSections.Add($_.'section #',$_.title)
                    }
                }
                catch [System.Management.Automation.MethodInvocationException]{
                    #reccomendations are commonly duplicated between worksheets for different combinations of benchmarks so we ignore duplicate key exceptions.
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