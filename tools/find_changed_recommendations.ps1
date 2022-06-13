<#
.Synopsis
    Imports two Excel benchmarks and detects drift in recommendation numbers
.DESCRIPTION
    Imports two Excel benchmarks and detects drift in recommendation numbers
.PARAMETER PreviousPath
    Path to the previous version of the Excel file.
.PARAMETER NewPath
    Path to the new version of the Excel file.
.PARAMETER System
    Type of benchmark. Ex: Workstation, Member Server, Domain Controller
.PARAMETER CSVPrefix
    Starting text of the CSVs IE: "Server2019_20H2", "Win10_1809"
.PARAMETER ForkCSVs
    If provided it will make new CSVs with the changed IDs updated
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$PreviousPath,
    [Parameter(Mandatory=$true)]
    [string]$NewPath,
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        'Workstation',
        'Member Server',
        'Domain Controller'
    )]
    [string]$System,
    [string]$CSVPrefix,
    [switch]$ForkCSVs
)

Import-Module '..\src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1' -Force
Import-Module -Name 'ImportExcel'

# We're going to import the contents of each excel file
$PreviousBenchmark = @()
Get-CISBenchmarkValidWorksheets -Path $PreviousPath -System $System | ForEach-Object -Process {
    $PreviousBenchmark += Import-Excel -Path $PreviousPath -WorksheetName $_.Name
}

$NewBenchmark = @()
Get-CISBenchmarkValidWorksheets -Path $NewPath -System $System | ForEach-Object -Process {
    $NewBenchmark += Import-Excel -Path $NewPath -WorksheetName $_.Name
}

$Properties = @(
    'name',
    @{
        Name = 'OldNumber'
        Expression = {
            ($_.group | Where-Object -FilterScript { $_.SideIndicator -eq '<='}).'Recommendation #'
        }
    },
    @{
        Name = 'NewNumber'
        Expression = {
            ($_.group | Where-Object -FilterScript { $_.SideIndicator -eq '=>'}).'Recommendation #'
        }
    }
)

$Changes = Compare-Object -ReferenceObject $PreviousBenchmark -DifferenceObject $NewBenchmark -Property ('title','Recommendation #') |
    Group-Object -Property 'title' |
    Select-Object -Property $Properties |
    Where-Object -FilterScript {$_.OldNumber -and $_.NewNumber}

if($ForkCSVs.IsPresent){
    Get-ChildItem -Path "..\csvs" -Recurse -Filter "$($CSVPrefix)*.csv" | ForEach-Object -Process {
        $NewName = "$($_.Name)_UPDATED.csv"
        Copy-Item -Path $_.FullName -Destination $NewName
        $Content = Get-Content -Path $NewName
        $Changes | Where-Object -FilterScript { ($_.NewNumber | Measure-Object).count -eq 1 } | ForEach-Object -Process {
            $Content = $Content.replace($_.OldNumber,$_.NewNumber)
        }
        Set-Content -Path $NewName -Value $Content
    }

    $ManualChecks = $Changes | Where-Object -FilterScript { ($_.NewNumber | Measure-Object).count -gt 1 }
    if($ManualChecks){
        Write-Output -InputObject 'The following need manual intervention because they had multiple matches'
        $ManualChecks
    }
}
else{
    $Changes
}
