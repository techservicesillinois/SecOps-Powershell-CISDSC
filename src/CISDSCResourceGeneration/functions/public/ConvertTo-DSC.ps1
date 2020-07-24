function ConvertTo-DSC {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$BenchmarkPath,

        [Parameter(Mandatory=$true)]
        [string]$GPOPath,

        [string]$StaticCorrectionsPath,

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

    }

    process {
        Update-CISBenchmarkData -Path $BenchmarkPath -OS $OS

        if($StaticCorrectionsPath){
            Import-Csv -Path $StaticCorrectionsPath -ErrorAction Stop | ForEach-Object -Process {
                $script:StaticCorrections.add($_.Key,$_.Recommendation)
            }
        }

        [System.Collections.ArrayList]$ScaffoldingBlocks = @()

        Get-ChildItem -Path $GPOPath -Filter 'GptTmpl.inf' -Recurse | Foreach-Object -Process {
            $ini = Get-IniContent -Path $_.fullname

            foreach($key in $ini.Keys){
                foreach($subKey in $ini[$key].Keys){
                    switch($key){
                        'Unicode' {Write-Verbose -Message 'Skipping Unicode section'}
                        'Version' {Write-Verbose -Message 'Skipping Version section'}
                        'Registry Values' {$ScaffoldingBlocks += ConvertFrom-RegistryValueRawGPO -Key $subkey -ValueData $ini[$key][$subKey]}
                        'Privilege Rights' {$ScaffoldingBlocks += ConvertFrom-PrivilegeRightRawGPO -Policy $subkey -Identity $ini[$key][$subKey]}
                        'System Access' {$ScaffoldingBlocks += ConvertFrom-SystemAccessRawGPO -Key $subkey -SecurityData $ini[$key][$subKey]}
                        'Service General Setting' {$ScaffoldingBlocks += ConvertFrom-ServiceRawGPO -Service $subkey -ServiceData $ini[$key][$subKey]}
                        Default {Write-Warning -Message "Inf: $($Key) not yet supported."}
                    }
                }
            }
        }

        Get-ChildItem -Path $GPOPath -Filter 'Audit.csv' -Recurse | ForEach-Object -Process {
            $CSV = Import-CSV -Path $_.FullName

            foreach($Row in $CSV){
                switch ($Row){
                    {!([string]::IsNullOrEmpty($Row.'Subcategory GUID'))} {$ScaffoldingBlocks += ConvertFrom-AuditPolicySubcategoryRawGPO -Entry $Row}
                    Default { Write-Warning -Message "Audit: $($CSV.SubCategory) is not currently supported"}
                }
            }
        }

        Get-ChildItem -Path $GPOPath -Filter 'registry.pol' -Recurse | ForEach-Object -Process {
            $PolicyData = Parse-PolFile -Path $_.FullName

            Foreach($Policy in $PolicyData){
                switch($_.Directory.BaseName){
                    'Machine' {$ScaffoldingBlocks += ConvertFrom-RegistryPolGPORaw -Policy $Policy}
                    'User' {Write-Warning -Message "Registry POL: User hive is not currently supported"}
                    Default {Write-Warning -Message "Registry POL: Unknown Registry hive $($_)."}
                }
            }
        }

        $RecommendationErrors = $ScaffoldingBlocks | Where-Object -FilterScript {($_.Recommendation | Measure-Object).count -ne 1}
        $ScaffoldingBlocks = $ScaffoldingBlocks | Where-Object -FilterScript {($_.Recommendation | Measure-Object).count -eq 1 -and $_.Recommendation.TopLevelSection -ne $script:UserSection}

        $CompareSplat = @{
            'ReferenceObject' = ($script:BenchmarkRecommendations.Values | Where-Object -FilterScript {$_.TopLevelSection -ne $script:UserSection}).'recommendation #'
            'DifferenceObject' = (($ScaffoldingBlocks).Recommendation.'recommendation #' | Get-Unique)
        }
        $MissingRecommendations = @()
        $MissingRecommendations += (Compare-Object @CompareSplat | Where-Object -FilterScript {$_.SideIndicator -eq '<='}).InputObject

        if($MissingRecommendations.count -gt 0){
            [string]$MissingRecommendationsPath = Join-Path -Path $OutputPath -ChildPath 'MissingRecommendations.txt'
            $MissingRecommendations | Out-File -FilePath $MissingRecommendationsPath -Force
            Write-Warning -Message "$($MissingRecommendationsPath.count) Missing Recommendations found. List can be found at '$($MissingRecommendationsPath)'"
        }

        if($RecommendationErrors){
            [string]$RecommendationErrorsPath = Join-Path -Path $OutputPath -ChildPath 'RecommendationErrors.ps1'
            Set-Content -Path $RecommendationErrorsPath -Value "$($RecommendationErrors.count) errors found. The bellow blocks where not able to be automatically matched to a Recommendation in '$($BenchmarkPath)'.`n" -Force
            Add-Content -Path $RecommendationErrorsPath -Value (($RecommendationErrors).TextBlock -join "`n")
            Write-Warning -Message "$($RecommendationErrors.count) errors found. Settings that require manual intervention can be found at '$($RecommendationErrorsPath)'"
        }

        if($ScaffoldingBlocks){
            [string]$ResourceName = "CIS_$($OS.replace(' ','_'))_Release_$($OSBuild)"
            [string]$ResourcePath = Join-Path -Path $OutputPath -ChildPath $ResourceName
            New-Item -Path $ResourcePath -ItemType Directory | Out-Null
            [string]$ScaffoldingPath = Join-Path -Path $ResourcePath -ChildPath "$($ResourceName).schema.psm1"

            Set-Content -Path $ScaffoldingPath -Value (Get-ConfigurationHeader -ResourceName $ResourceName)
            Add-Content -Path $ScaffoldingPath -Value (($ScaffoldingBlocks | Sort-Object -Property 'RecommendationVersioned').TextBlock -join "`n") -Force
            Add-Content -Path $ScaffoldingPath -Value '}' -Force
            Write-Verbose -Message "Generated scaffolding can be found at '$($ScaffoldingPath)'."

            $PlasterSplat = @{
                'TemplatePath' = (Join-Path -Path $script:PlasterTemplatePath -ChildPath 'NewCompositeResourceManifest')
                'DestinationPath' = $ResourcePath
                'NoLogo' = $true
                'OS' = $OS.replace(' ','_')
                'OSBuild' = $OSBuild
                'BenchmarkVersion' = $BenchmarkVersion.ToString()
            }
            Invoke-Plaster @PlasterSplat | Out-Null
        }
    }

    end {

    }
}
