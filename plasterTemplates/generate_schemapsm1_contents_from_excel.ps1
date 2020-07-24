<#
.SYNOPSIS
This script will take an xlsx file provided by CIS and generate the scaffolding for DSC. Intended to be used with the provided plaster template.

.DESCRIPTION
This script will take an xlsx file provided by CIS and generate the scaffolding for DSC. Intended to be used with the provided plaster template.

.PARAMETER Path
Path to the xlsx file.

.PARAMETER TargetSchemaPsm1
Path to the resource schema file generated with the plaster template

.PARAMETER UserSettingsSection
CIS benchmarks contain some user specific settings that DSC cannot interact with. These are typically in a dedicated section (usually 19) and should be excluded.

.EXAMPLE

PS> .\plasterTemplates\generate_schemapsm1_contents_from_excel.ps1 -Path '.\CIS_Microsoft_Windows_10_Enterprise_Release_1909_Benchmark_v1.8.1.xlsx' -TargetSchemaPsm1 '.\src\CISDSC\dscresources\CIS_Microsoft_Windows_10_Enterprise_Release_1909\CIS_Microsoft_Windows_10_Enterprise_Release_1909.schema.psm1' -UserSettingsSection 19

#>

#Requires -Modules ImportExcel

[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [string]
    $Path,

    [Parameter(Mandatory=$True)]
    [string]
    $TargetSchemaPsm1,

    [Parameter(Mandatory=$True)]
    [int]
    $UserSettingsSection
)

Import-Module -Name 'ImportExcel'

function Get-VersionFromString([string]$String){
    function Get-DotCount([string]$String){
        ($string.length - $string.replace('.','').length)
    }

    [string]$VerString = $String
    [int]$Dotcount = Get-DotCount -String $VerString

    if($Dotcount -eq 0){
        $VerString = "$($String).0"
    }
    elseif($Dotcount -ge 4) {
        do{
            $VerString = $VerString.Remove($VerString.LastIndexOf('.'),1)
        }
        until((Get-DotCount -String $VerString) -eq 3)
    }

    [version]$VerString
}

[System.Collections.ArrayList]$Benchmarks = @()
$Sections = @{}

Get-ExcelSheetInfo -Path $Path | Where-Object -FilterScript {$_.Name -ne 'License'} | ForEach-Object -Process {
    Import-Excel -Path $Path -DataOnly -WorksheetName $_.Name | ForEach-Object -Process {
        if($_.'recommendation #'){
            $Benchmarks += $_ | Select-Object -Property 'section #','recommendation #','title',@{ Name = 'Versioned';  Expression = {Get-VersionFromString -string $_.'recommendation #'}} |
                Sort-Object -Property 'Versioned'
        }
        else{
            try{
                $Sections.Add($_.'section #',$_.title)
            }
            catch{}
        }
    }
}

$Grouped = $Benchmarks | Select-Object -Unique 'section #','recommendation #','title','Versioned' | Group-Object -Property 'section #'

$Grouped | Add-Member -Name 'Versioned' -MemberType ScriptProperty -Value { Get-VersionFromString -string $This.Name }
$Grouped | Add-Member -Name 'ParentSection' -MemberType ScriptProperty -Value { $this.Versioned.Major }

[regex]$LevelPattern = '^\(.{2}\)'
[string[]]$Scaffolding = @()
$Grouped | Group-Object -Property 'ParentSection' | Where-Object -FilterScript {$_.ParentSection -ne $UserSettingsSection} | Sort-Object -Property 'ParentSection' | ForEach-Object -Process {
    $Scaffolding += "#region $($_.Name) $($Sections[$_.Name])"

    $_.Group | Sort-Object -Property 'Versioned' | ForEach-Object -Process {
        $Scaffolding += "#region $($_.Name) $($Sections[$_.Name])`n"

        $_.Group | Sort-Object -Property 'Versioned' | ForEach-Object -Process {
            $Start = "'$($_.'recommendation #')'"
            $Middle = switch($_.title){
                {$_ -like "*or more*"} {'# "or more" found in remediation. Potentially needs a parameter for customization.'}
                {$_ -like "*or fewer*"} {'# "or fewer" found in remediation. Potentially needs a parameter for customization.'}
                {$_ -like "*or greater*"} {'# "or greater" found in remediation. Potentially needs a parameter for customization.'}
                {$_ -like "*or less*"} {'# "or less" found in remediation. Potentially needs a parameter for customization.'}
                default {[string]::Empty}
            }
            $Close = switch($LevelPattern.Match($_.title).Value){
                '(L2)'{' -and $LevelTwo){'}
                '(BL)'{' -and $BitLocker){'}
                '(NG)'{' -and $NextGenerationWindowsSecurity){'}
                default {'){'}
            }
            $Scaffolding += "# $($_.title)"
            $Scaffolding += 'if($ExcludeList -notcontains {0}{1}' -f $Start,$Close
            $Scaffolding += $Middle
            $Scaffolding += "}`n"
        }

        $Scaffolding += "#endregion"
    }

    $Scaffolding += "#endregion`n"
}

[string[]]$Content = Get-Content -path $TargetSchemaPsm1
$Content += $Scaffolding
$Content += '}'
Set-Content -Path $TargetSchemaPsm1 -Value $Content