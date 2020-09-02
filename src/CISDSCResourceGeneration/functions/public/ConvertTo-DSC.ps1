<#
.Synopsis
   Converts provided CIS benchmark materials and converts them to a DSC composite resource.
.DESCRIPTION
   Converts provided CIS benchmark materials and converts them to a DSC composite resource.
.PARAMETER BenchmarkPath
    Path to the excel document from CIS for the benchmark documentation.
.PARAMETER GPOPath
    Path to the GPO files (build kit) from CIS containing the benchmarks settings.
.PARAMETER StaticCorrectionsPath
    Path to the CSV file containing known static corrections for GPO -> Excel mismatchs.
.PARAMETER OutputPath
    Output directory for the files generated. This will default to .\Output
.PARAMETER OS
    The operating system the benchmark is written for. Supported values are the known Windows desktop and server versions.
.PARAMETER OSBuild
    The build number of the operating system. Ex: the 1909 in 'Microsoft Windows 10 Enterprise version 1909'
.PARAMETER BenchmarkVersion
    The version number of the CIS benchmark. This will become the version number of the composite resource to show what version of the benchmark it's based off of.
.EXAMPLE
    $Splat = @{
        BenchmarkPath = '.\CIS_Microsoft_Windows_Server_2016_RTM_Release_1607_Benchmark_v1.2.0.xlsx'
        BenchmarkVersion = 1.2.0
        GPOPath = '.\Server2016v1.2.0'
        OutputPath = '.\CISDSC\dscresources'
        StaticCorrectionsPath = '.\static_corrections.csv'
        OS = 'Microsoft Windows Server 2016 Member Server'
        OSBuild = '1607'
    }
    ConvertTo-DSC @Splat
#>
function ConvertTo-DSC {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$BenchmarkPath,

        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$GPOPath,

        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$StaticCorrectionsPath,

        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$ParameterValidationsPath,

        [string]$OutputPath = (Join-Path -Path $PWD -ChildPath 'Output'),

        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'Microsoft Windows 10 Enterprise',
            'Microsoft Windows Server 2016 Member Server',
            'Microsoft Windows Server 2016 Domain Controller',
            'Microsoft Windows Server 2019 Member Server',
            'Microsoft Windows Server 2019 Domain Controller'
        )]
        [string]$OS,

        [Parameter(Mandatory=$true)]
        [string]$OSBuild,

        [Parameter(Mandatory=$true)]
        [version]$BenchmarkVersion
    )

    begin {
        $script:RecommendationErrors.Clear()
        $script:BenchmarkRecommendations.Clear()
        $script:StaticCorrections.Clear()
        $script:ParameterValidations.Clear()
        $script:DSCConfigurationParameters.Clear()
        $script:DSCConfigurationParameters += @(
            '        [string[]]$ExcludeList = @()',
            '        [boolean]$LevelOne = $true',
            '        [boolean]$LevelTwo = $false',
            '        [boolean]$BitLocker = $false',
            '        [boolean]$NextGenerationWindowsSecurity = $false'
        )
    }

    process {
        Update-CISBenchmarkData -Path $BenchmarkPath -OS $OS

        if($StaticCorrectionsPath){
            Import-Csv -Path $StaticCorrectionsPath | ForEach-Object -Process {
                $script:StaticCorrections.add($_.Key,$_.Recommendation)
            }
        }

        if($ParameterValidationsPath){
            Import-Csv -Path $ParameterValidationsPath | ForEach-Object -Process {
                $script:ParameterValidations.add($_.Recommendation,$_.ValidationString)
            }
        }

        if(!(Test-Path -Path $OutputPath)){
            New-Item -Path $OutputPath -ItemType Directory | Out-Null
        }

        Import-GptTmpl -GPOPath $GPOPath
        Import-AudicCsv -GPOPath $GPOPath
        Import-RegistryPol -GPOPath $GPOPath

        Export-RecommendationErrors -OutputPath $OutputPath
        $FoundRecommendations = ($script:BenchmarkRecommendations).Values | Where-Object -FilterScript {$_.ResourceParameters}
        $FoundRecommendations | ForEach-Object -Process {
            $_.GenerateTextBlock()
        }

        if($FoundRecommendations){
            [string]$ResourceName = "CIS_$($OS.replace(' ','_'))_Release_$($OSBuild)"
            [string]$ResourcePath = Join-Path -Path $OutputPath -ChildPath $ResourceName
            [string]$ScaffoldingPath = Join-Path -Path $ResourcePath -ChildPath "$($ResourceName).schema.psm1"
            New-Item -Path $ResourcePath -ItemType Directory | Out-Null
            #Setting this inside the splat loses data. I assume because script scope variables cannot be read by invoke-plaster.
            $script:DSCConfigurationParameters += (($FoundRecommendations).DSCConfigParameter | Sort-Object -Property 'Name').TextBlock

            $PlasterSplat = @{
                'TemplatePath' = (Join-Path -Path $script:PlasterTemplatePath -ChildPath 'NewBenchmarkCompositeResource')
                'DestinationPath' = $ResourcePath
                'NoLogo' = $true
                'OS' = $OS.replace(' ','_')
                'OSBuild' = $OSBuild
                'BenchmarkVersion' = $BenchmarkVersion.ToString()
                'DSCParameters' = ($script:DSCConfigurationParameters -join ",`n")
                'DSCScaffolding' = (($FoundRecommendations | Sort-Object -Property 'RecommendationVersioned').DSCTextBlock -join "`n")
            }
            Invoke-Plaster @PlasterSplat | Out-Null

            Write-Verbose -Message "Generated scaffolding can be found at '$($ScaffoldingPath)'."
        }
    }

    end {

    }
}