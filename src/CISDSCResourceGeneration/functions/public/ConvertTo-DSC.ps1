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
.PARAMETER ParameterValidationsPath
    Path to the CSV file containing known parameter validation blocks.
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
        ParameterValidationsPath = '.\parameter_validations.csv'
        OS = 'Microsoft Windows Server 2016 Member Server'
        OSBuild = '1607'
    }
    ConvertTo-DSC @Splat
#>
function ConvertTo-DSC {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$BenchmarkPath,

        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$GPOPath,

        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$StaticCorrectionsPath,

        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$ParameterValidationsPath,

        [ValidateScript({Test-FilePathParameter -Path $_ })]
        [string]$ParameterOverridesPath,

        [string]$OutputPath = (Join-Path -Path $PWD -ChildPath 'Output'),

        [Parameter(Mandatory = $true,
            ParameterSetName = 'OS')]
        [ValidateSet(
            'Microsoft Windows 10 Enterprise',
            'Microsoft Windows Server 2016 Member Server',
            'Microsoft Windows Server 2016 Domain Controller',
            'Microsoft Windows Server 2019 Member Server',
            'Microsoft Windows Server 2019 Domain Controller'
        )]
        [string]$OS,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'OS')]
        [string]$OSBuild,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Browser')]
        [ValidateSet(
            'Microsoft Edge',
            'Google Chrome',
            'Mozilla FireFox'
        )]
        [string]$Browser,

        [Parameter(Mandatory = $true)]
        [version]$BenchmarkVersion
    )

    begin {
        $script:RecommendationErrors.Clear()
    }

    process {
        #The use of get-variable here is a little hack to avoid needing a switch statement.
        #It assumes the value we care about is stored in a variable of the same name as the parameter set.
        $System = (Get-Variable -Name $PSCmdlet.ParameterSetName).Value
        Import-CISBenchmarkData -Path $BenchmarkPath -System $System

        if($StaticCorrectionsPath){
            Import-StaticCorrections -Path $StaticCorrectionsPath
        }

        if($ParameterValidationsPath){
            Import-ParameterValidations -Path $ParameterValidationsPath
        }

        if($ParameterOverridesPath){
            Import-ParameterOverrides -Path $ParameterOverridesPath
        }

        if(!(Test-Path -Path $OutputPath)){
            New-Item -Path $OutputPath -ItemType 'Directory' | Out-Null
        }

        Import-GptTmpl -GPOPath $GPOPath -System $System
        Import-AuditCsv -GPOPath $GPOPath -System $System
        Import-RegistryPol -GPOPath $GPOPath -System $System

        Export-RecommendationErrors -OutputPath $OutputPath
        Export-MissingRecommendations -OutputPath $OutputPath
        $FoundRecommendations = ($script:BenchmarkRecommendations).Values | Where-Object -FilterScript {$_.ResourceParameters}

        if($FoundRecommendations){
            $FoundRecommendations | ForEach-Object -Process {
                $_.GenerateTextBlock()
            }

            #Setting this inside the splat loses data. I assume because script scope variables cannot be read by invoke-plaster.
            [string[]]$Levels = @()
            $Levels += Get-ApplicableLevels -Recommendations $FoundRecommendations
            $DSCConfigurationParameters = Get-DSCParameterTextBlocks -Recommendations $FoundRecommendations -Levels $Levels
            $DocumentationPropertyBlock = Get-DSCDocumentationPropertyTable -Recommendations $FoundRecommendations -Levels $Levels
            $DocumentationSyntaxBlock = Get-DSCDocumentationSyntax -Recommendations $FoundRecommendations -Levels $Levels

            switch ($PSCmdlet.ParameterSetName) {
                'OS' {
                    [string]$ResourceName = "CIS_$($OS.replace(' ','_'))_Release_$($OSBuild)"
                    [string]$Template = 'NewOSBenchmarkCompositeResource'

                    $PlasterSplat = @{
                        'OS' = $OS
                        'OSWithUnderscores' = $OS.replace(' ','_')
                        'OSBuild' = $OSBuild
                        'AccountsRenameadministratoraccountNum' = $script:AccountsRenameadministratoraccountNum
                        'AccountsRenameadministratoraccountNumNoDots' = $script:AccountsRenameadministratoraccountNum.replace('.','')
                        'AccountsRenameguestaccountNum' = $script:AccountsRenameguestaccountNum
                        'AccountsRenameguestaccountNumNoDots' = $script:AccountsRenameguestaccountNum.replace('.','')
                        'LegalNoticeTextNum' = $script:LegalNoticeTextNum
                        'LegalNoticeTextNumNoDots' = $script:LegalNoticeTextNum.replace('.','')
                        'LegalNoticeCaptionNum' = $script:LegalNoticeCaptionNum
                        'LegalNoticeCaptionNumNoDots' = $script:LegalNoticeCaptionNum.replace('.','')
                    }
                }
                'Browser' {
                    [string]$ResourceName = "CIS_$($Browser.replace(' ','_'))_Windows"
                    [string]$Template = 'NewBrowserBenchmarkCompositeResource'

                    $PlasterSplat = @{
                        'Browser' = $Browser
                        'BrowserWithUnderscores' = $Browser.replace(' ','_')
                    }
                }
            }

            [string]$ResourcePath = Join-Path -Path $OutputPath -ChildPath $ResourceName
            [string]$ScaffoldingPath = Join-Path -Path $ResourcePath -ChildPath "$($ResourceName).schema.psm1"
            New-Item -Path $ResourcePath -ItemType 'Directory' | Out-Null

            # Common plaster template parameters. These should be present on every template.
            $PlasterSplat.Add('NoLogo', $true)
            $PlasterSplat.Add('DestinationPath', $ResourcePath)
            $PlasterSplat.Add('BenchmarkVersion', $BenchmarkVersion.ToString())
            $PlasterSplat.Add('TemplatePath', (Join-Path -Path $script:PlasterTemplatePath -ChildPath $Template))
            $PlasterSplat.Add('DSCParameters', ($DSCConfigurationParameters -join ",`n"))
            $PlasterSplat.Add('DSCScaffolding', (($FoundRecommendations | Sort-Object -Property 'RecommendationVersioned').DSCTextBlock -join "`n"))
            $PlasterSplat.Add('DocumentationPropertyTable', ($DocumentationPropertyBlock -join "`n"))
            $PlasterSplat.Add('DocumentationSyntax', ($DocumentationSyntaxBlock -join "`n"))
            Invoke-Plaster @PlasterSplat | Out-Null

            Write-Verbose -Message "Generated scaffolding can be found at '$($ScaffoldingPath)'."
        }
    }

    end {

    }
}
