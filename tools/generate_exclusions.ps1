<#
.Synopsis
    Imports a CSV export from CISCAT to generate an exclusion list for CISDSC to match your existing configuration. This allows for you to slowly introduce changes to your system.
    This is created by using the "-csv" option when running CISCAT. The resulting output file can be copy/pasted into the exclusion list of your configuration.
.DESCRIPTION
    Imports a CSV export from CISCAT to generate an exclusion list for CISDSC to match your existing configuration. This allows for you to slowly introduce changes to your system.
    This is created by using the "-csv" option when running CISCAT. The resulting output file can be copy/pasted into the exclusion list of your configuration.
.PARAMETER Path
    Path to the CISDSC csv.
.PARAMETER OutPath
    Path to export a text file of the exclusions.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [Parameter(Mandatory=$true)]
    [string]$OutPath
)

# The CSV exported by CISCAT does not have headers so they have to be explictly set here.
$Headers = (
    'Date',
    'ComputerName',
    'Ignore1',
    'Ignore2',
    'BenchmarkVer',
    'Ignore3',
    'BenchmarkName',
    'Ignore4',
    'BenchmarkLevel',
    'Ignore5',
    'Ignore6',
    'Recommendation',
    'Title',
    'State',
    'Ignore7'
)

[string[]]$Exclusions = @()
# Section 19 is the out of scope user registry settings. So they are ignored.
Import-Csv -Path $Path -Header $Headers | Where-Object -FilterScript {$_.state -eq 'fail' -and $_.recommendation -notlike "19.*"} | ForEach-Object -Process {
    $Exclusions += "'$($_.recommendation)', # $($_.title)"
}

$Exclusions | Out-File -FilePath $OutPath -Force
