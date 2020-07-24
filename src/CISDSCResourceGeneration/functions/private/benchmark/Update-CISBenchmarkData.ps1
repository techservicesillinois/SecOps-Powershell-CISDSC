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

                        $_ | Add-Member -Name 'Level' -MemberType ScriptProperty -Value {Get-BenchmarkLevelFromTitle -Title $this.title}
                        $_ | Add-Member -Name 'RecommendationVersioned' -MemberType ScriptProperty -Value {ConvertTo-Version -CISNumberString $this.'recommendation #'}
                        $_ | Add-Member -Name 'SectionVersioned' -MemberType ScriptProperty -Value {ConvertTo-Version -CISNumberString $this.'section #'}
                        $_ | Add-Member -Name 'TopLevelSection' -MemberType ScriptProperty -Value { $this.RecommendationVersioned.Major }
                        $_ | Add-Member -Name 'PotentialParameter' -MemberType ScriptProperty -Value {Get-RecommendationCustomizability -Title $this.title}

                        $_.title = ConvertTo-SingleQuotes -String $_.title

                        $script:BenchmarkRecommendations.add($_.'recommendation #',$_)
                    }
                    else{
                        $script:BenchmarkSections.Add($_.'section #',$_.title)
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