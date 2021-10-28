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
    [string]$System
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

Compare-Object -ReferenceObject $PreviousBenchmark -DifferenceObject $NewBenchmark -Property ('title','Recommendation #') |
    Group-Object -Property 'title' |
    Select-Object -Property $Properties
