[String]$SourceRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src'
[String]$ModuleRoot = Join-Path -Path $SourceRoot -ChildPath 'CISDSCResourceGeneration'
Import-Module -Name "$($ModuleRoot)\CISDSCResourceGeneration.psd1" -Force
Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}

Describe 'Class: Recommendation' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Constructs from an Excel recommendation row' {
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.Title -like "(L1)*"})[0]
            {[Recommendation]::New($ExcelExample)} | Should -Not -Throw
        }

        It 'Correctly translates all known levels from the title' -TestCases @(
            @{ Prefix = '(L1)'; Translation = 'LevelOne' },
            @{ Prefix = '(L2)'; Translation = 'LevelTwo' },
            @{ Prefix = '(BL)'; Translation = 'BitLocker' },
            @{ Prefix = '(NG)'; Translation = 'NextGenerationWindowsSecurity' }
        ){
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.Title -like "(L1)*"})[0]
            $ExcelExample.Title = $ExcelExample.Title.replace('(L1)',$Prefix)
            ([Recommendation]::New($ExcelExample)).Level | Should -Be $Translation
        }

        It 'Converts the recommendation numbers to versions' -TestCases @(
            @{ num = '1.1.1'; version = [version]'1.1.1'},
            @{ num = '1.1.1.1'; version = [version]'1.1.1.1' }
            @{ num = '1.1.1.1.1.1'; version = [version]'1.1.1.111' }
        ){
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.Title -like "(L1)*"})[0]

            $ExcelExample.'Recommendation #' = $Num
            ([Recommendation]::New($ExcelExample)).RecommendationVersioned | Should -Be $Version
        }

        It 'Sanitizes the title for the resulting DSC' -TestCases @(
            @{ Title = "(L1) Ensure 'Enforce password history' is set to '24 or more password(s)'"; Expectation = "1.1.1 - (L1) Ensure Enforce password history is set to 24 or more password(s)"},
            @{ Title = "(L1) Ensure 'Interactive logon: Do not require CTRL+ALT+DEL' is set to 'Disabled'"; Expectation = "1.1.1 - (L1) Ensure Interactive logon Do not require CTRLALTDEL is set to Disabled"},
            @{ Title = @"
(L1) Ensure 'Remove access to “Pause updates” feature' is set to 'Enabled''
"@; Expectation = "1.1.1 - (L1) Ensure Remove access to Pause updates feature is set to Enabled" }
        ){
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.Title -like "(L1)*"})[0]

            $ExcelExample.Title = $Title
            ([Recommendation]::New($ExcelExample)).DSCTitle | Should -Be $Expectation
        }
    }
}

Describe 'Class: DSCConfigurationParameter' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Constructs under normal circumstances' {
            $RecommendationNum = '2.3.7.3'
            $Name = 'MaxDevicePasswordFailedAttempts'
            $DataType = "'[Int32]'"
            $DefaultValue = "10"
            {[DSCConfigurationParameter]::New($RecommendationNum,$Name,$DataType,$DefaultValue)} | Should -Not -Throw
        }

        It 'Adds a validation block if appropriate' {
            Import-ParameterValidations -Path "$($PSScriptRoot)\example_files\parameter_validations.csv"

            $RecommendationNum = '1.1.2'
            $Name = 'MaximumPasswordAge'
            $DataType = "'[Int32]'"
            $DefaultValue = "60"
            $Param = [DSCConfigurationParameter]::New($RecommendationNum,$Name,$DataType,$DefaultValue)
            $Param.Textblock -like "*[ValidateRange(60,999)]*" | Should -Be $True
        }
    }
}

Describe 'Helper: Get-IniContent' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Returns a hashtable with hashtable values' {
            $Ini = Get-IniContent -Path "$($PSScriptRoot)\example_files\GptTmpl.inf"
            $Ini -is [System.Collections.Hashtable] | Should -Be $True
            $Ini['Version'] -is [System.Collections.Hashtable] | Should -Be $True
            $Ini['Version']['Revision'] | Should -Be 1
        }

        It 'Finds all the categories' {
            $Ini = Get-IniContent -Path "$($PSScriptRoot)\example_files\GptTmpl.inf"
            [string[]]$ExpectedKeys = @('Unicode','System Access','Privilege Rights','Registry Values','Version')
            $ExpectedKeys | Where-Object -FilterScript {$_ -notin $Ini.keys} | Should -Be $null
        }
    }
}

Describe 'Helper: Get-CISBenchmarkValidWorksheets' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Returns the correctly filtered workseets' -TestCases @(
            @{Workbook = 'desktop_examples.xlsx'; OS = 'Microsoft Windows 10 Enterprise'; Expectation = ('Level 1 (L1) - Corporate_Enter','BitLocker (BL) - Level 1 (L1)','Next Generation - Level 1 (L1)','BitLocker (BL) 1 - Level 1 (L1)','Level 2 (L2) - High Security_S','BitLocker (BL) - Level 2 (L2)','Next Generation - Level 2 (L2)','BitLocker (BL) 1 - Level 2 (L2)','BitLocker (BL) - optional add','Next Generation Windows Securi')},
            @{Workbook = 'server_examples.xlsx'; OS = 'Microsoft Windows Server 2019 Member Server'; Expectation = ('Level 1 - Member Server','Level 2 - Member Server','Next Generation Windows Securi','Next Generation Windows Secur 1')},
            @{Workbook = 'server_examples.xlsx'; OS = 'Microsoft Windows Server 2019 Domain Controller'; Expectation = ('Level 1 - Domain Controller','Level 2 - Domain Controller','Next Generation Windows Securi','Next Generation Windows Secur 1')}
        ){
            [string]$Path = "$($PSScriptRoot)\example_files\$($Workbook)"
            Get-CISBenchmarkValidWorksheets -Path $Path -OS $OS | Where-Object {$_.Name -notin $Expectation} | Should -Be $Null
        }
    }
}

Describe 'Helper: Import-CISBenchmarkData' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Stores [Recommendation] objects in script scope' {
            $script:BenchmarkRecommendations.Clear()
            Import-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            $script:BenchmarkRecommendations.Values[0] -is [Recommendation]
        }

        It 'Updates the unique section values' {
            Import-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'

            $script:ServiceSection | Should -Be 5
            $script:UserSection | Should -Be 19
        }
    }
}

Describe 'Helper: Import-StaticCorrections' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Populates the hashtable of static corrections' {
            Import-StaticCorrections -Path "$($PSScriptRoot)\example_files\static_corrections.csv"
            $script:StaticCorrections | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Helper: Get-RecommendationFromGPOHash' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Finds exactly one result under normal circumstances' -TestCases @(
            @{'Type' = 'AuditPolicy'; 'GPOHash' = @{'Subcategory' = 'Audit Security Group Management'; 'InclusionSetting' = 'Success'}},
            @{'Type' = 'PrivilegeRight'; 'GPOHash' = @{'Policy' = 'Force_shutdown_from_a_remote_system'}},
            @{'Type' = 'Service'; 'GPOHash' = @{'Name' = 'bthserv'}},
            @{'Type' = 'SystemAccess'; 'GPOHash' = @{'Name' = 'Accounts_Administrator_account_status'}},
            @{'Type' = 'Registry'; 'GPOHash' = @{'Key' = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'; 'ValueName' = 'NoConnectedUser'}}
        ){
            Import-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            (Get-RecommendationFromGPOHash -GPOHash $GPOHash -Type $Type | Measure-Object).count | Should -Be 1
        }

        It 'Writes a warning for zero recommendations returned' {
            Import-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            Get-RecommendationFromGPOHash -GPOHash @{'Name' = 'NotReal'} -Type 'Service' 3>&1 | Should -Be 'Failed to find a recommendation for Service NotReal.'
        }

        It 'Writes a warning for multiple recommendations returned' {
            Import-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            Get-RecommendationFromGPOHash -GPOHash @{'Name' = 'a'} -Type 'Service' 3>&1 | Should -Be 'Found multiple recommendation matches for Service a.'
        }

        It 'Applies static corrections' {
            $script:StaticCorrections.Clear()
            Get-RecommendationFromGPOHash -GPOHash @{'Subcategory' = 'Audit Logoff'; 'InclusionSetting' = 'AuditPolicy'} -Type 'AuditPolicy' 3>&1 | Should -Be 'Failed to find a recommendation for AuditPolicy Audit Logoff.'
            Import-StaticCorrections -Path "$($PSScriptRoot)\example_files\static_corrections.csv"
            Get-RecommendationFromGPOHash -GPOHash @{'Subcategory' = 'Audit Logoff'; 'InclusionSetting' = 'AuditPolicy'} -Type 'AuditPolicy' | Should -Be '17.5.3'
        }
    }
}

Describe 'Helper: Conversion functions' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        Import-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'

        It 'ConvertFrom-AuditPolicySubcategoryRawGPO returns valid objects' {
            ConvertFrom-AuditPolicySubcategoryRawGPO -SubcategoryGUID '{0cce9248-69ae-11d9-bed3-505054503030}' -Subcategory 'Audit PNP Activity' -InclusionSetting 'Success'
            ($script:BenchmarkRecommendations['17.3.1'].ResourceParameters | Measure-Object).Count | Should -Not -Be 0
            $script:BenchmarkRecommendations['17.3.1'].ResourceParameters[0].keys | Where-Object -FilterScript {$_ -notin ('Name','Ensure','AuditFlag','ResourceType')} | Should -Be $null
            $script:BenchmarkRecommendations['17.3.1'].ResourceParameters[1].keys | Where-Object -FilterScript {$_ -notin ('Name','Ensure','AuditFlag','ResourceType')} | Should -Be $null
        }

        It 'ConvertFrom-PrivilegeRightRawGPO returns valid objects' {
            ConvertFrom-PrivilegeRightRawGPO -Policy 'SeCreateGlobalPrivilege' -Identity '*S-1-5-6,*S-1-5-20,*S-1-5-19,*S-1-5-32-544'
            ($script:BenchmarkRecommendations['2.2.12'].ResourceParameters | Measure-Object).Count | Should -Not -Be 0
            $script:BenchmarkRecommendations['2.2.12'].ResourceParameters[0].keys | Where-Object -FilterScript {$_ -notin ('Policy','Identity','Force','ResourceType')} | Should -Be $null
        }

        It 'ConvertFrom-RegistryPolGPORaw returns valid objects for creates' {
            ConvertFrom-RegistryPolGPORaw -KeyName 'SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -ValueName 'LogFileSize' -ValueType 'REG_DWORD' -ValueData '16384'
            ($script:BenchmarkRecommendations['9.3.8'].ResourceParameters | Measure-Object).Count | Should -Not -Be 0
            $script:BenchmarkRecommendations['9.3.8'].ResourceParameters[0].keys | Where-Object -FilterScript {$_ -notin ('ValueType','ValueName','ValueData','Key','Ensure','ResourceType')} | Should -Be $null
        }

        It 'ConvertFrom-RegistryPolGPORaw returns valid objects for deletes' {
            ConvertFrom-RegistryPolGPORaw -KeyName 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -ValueName '**del.DisableBkGndGroupPolicy' -ValueType 'REG_DWord' -ValueData ''
            ($script:BenchmarkRecommendations['18.8.21.5'].ResourceParameters | Measure-Object).Count | Should -Not -Be 0
            $script:BenchmarkRecommendations['18.8.21.5'].ResourceParameters[0].keys | Where-Object -FilterScript {$_ -notin ('ValueName','Key','Ensure','ResourceType')} | Should -Be $null
        }

        It 'ConvertFrom-RegistryValueRawGPO returns valid objects' {
            ConvertFrom-RegistryValueRawGPO -Key 'MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\PasswordExpiryWarning' -ValueData '4,14'
            ($script:BenchmarkRecommendations['2.3.7.8'].ResourceParameters | Measure-Object).Count | Should -Not -Be 0
            $script:BenchmarkRecommendations['2.3.7.8'].ResourceParameters[0].keys | Where-Object -FilterScript {$_ -notin ('ValueType','ValueName','ValueData','Key','ResourceType')} | Should -Be $null
        }

        It 'ConvertFrom-ServiceRawGPO returns valid objects' {
            ConvertFrom-ServiceRawGPO -Service 'IISADMIN'
            ($script:BenchmarkRecommendations['5.6'].ResourceParameters | Measure-Object).Count | Should -Not -Be 0
            $script:BenchmarkRecommendations['5.6'].ResourceParameters[0].keys | Where-Object -FilterScript {$_ -notin ('Name','ResourceType')} | Should -Be $null
        }

        It 'ConvertFrom-SystemAccessRawGPO returns valid objects' {
            ConvertFrom-SystemAccessRawGPO -Key 'EnableAdminAccount' -SecurityData '0'
            ($script:BenchmarkRecommendations['2.3.1.1'].ResourceParameters | Measure-Object).Count | Should -Not -Be 0
            ($script:BenchmarkRecommendations['2.3.1.1'].ResourceParameters[0].keys | Measure-Object).count | Should -Be 3
        }
    }
}

Describe 'Helper: File import functions' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Import-AudicCsv returns objects from a valid Audit.csv' {
            [string]$GPOPath = "$($PSScriptRoot)\example_files"
            {Import-AudicCsv -GPOPath $GPOPath -WarningAction SilentlyContinue} | Should -Not -Throw
        }

        It 'Import-GptTmpl returns objects from a valid GptTmpl.inf' {
            [string]$GPOPath = "$($PSScriptRoot)\example_files"
            {Import-GptTmpl -GPOPath $GPOPath -WarningAction SilentlyContinue} | Should -Not -Throw
        }

        It 'Import-RegistryPol returns objects from a valid registry.pol' {
            [string]$GPOPath = "$($PSScriptRoot)\example_files"
            {Import-RegistryPol -GPOPath $GPOPath -WarningAction SilentlyContinue} | Should -Not -Throw
        }
    }
}

Describe 'Helper: Test-FilePathParameter' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Errors if the file does not exist' {
            {Test-FilePathParameter -Path "$($PSScriptRoot)\not_real.xlsx"} | Should -Throw
        }

        It 'Returns true is the file exists' {
            Test-FilePathParameter -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" | Should -Be $True
        }
    }
}

Describe 'Helper: Import-ParameterValidations' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Populates the hashtable of validation blocks' {
            Import-ParameterValidations -Path "$($PSScriptRoot)\example_files\parameter_validations.csv"
            $script:ParameterValidations | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Helper: Text block generation' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        Import-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
        Import-GptTmpl -GPOPath "$($PSScriptRoot)\example_files"
        Import-AudicCsv -GPOPath "$($PSScriptRoot)\example_files"
        Import-RegistryPol -GPOPath "$($PSScriptRoot)\example_files"

        It 'Lists the appropriate levels' {
            (Get-ApplicableLevels -Recommendations ($script:BenchmarkRecommendations).Values | Measure-Object).Count | Should -be 4
        }

        It 'Generates parameters correctly' {
            [string[]]$Levels = @()
            $Levels += Get-ApplicableLevels -Recommendations ($script:BenchmarkRecommendations).Values
            (Get-DSCParameterTextBlocks -Recommendations $Nothing -Levels $Levels)[0] | Should -Be '        [string[]]$ExcludeList = @()'
            (Get-DSCParameterTextBlocks -Recommendations ($script:BenchmarkRecommendations).Values -Levels $Levels) | Should -Contain '        [boolean]$LevelOne = $true'
            (Get-DSCParameterTextBlocks -Recommendations ($script:BenchmarkRecommendations).Values -Levels $Levels) | Should -Contain '        [boolean]$LevelTwo = $false'
        }

        It 'Generates parameter documentation correctly' {
            [string[]]$Levels = @()
            $Levels += Get-ApplicableLevels -Recommendations ($script:BenchmarkRecommendations).Values
            (Get-DSCDocumentationPropertyTable -Recommendations $Nothing -Levels $Levels)[0] | Should -Be '|ExcludeList | | |Excludes the provided recommendation IDs from the configuration |'
            (Get-DSCDocumentationPropertyTable -Recommendations ($script:BenchmarkRecommendations).Values -Levels $Levels) | Should -Contain '|LevelOne |`$true` | |Applies level one recommendations |'
            (Get-DSCDocumentationPropertyTable -Recommendations ($script:BenchmarkRecommendations).Values -Levels $Levels) | Should -Contain '|LevelTwo |`$false` | |Applies level two recommendations. Does not include level one, both must be set to `$true`. |'
        }

        It 'Generates parameter syntax documentation correction' {
            [string[]]$Levels = @()
            $Levels += Get-ApplicableLevels -Recommendations ($script:BenchmarkRecommendations).Values
            (Get-DSCDocumentationSyntax -Recommendations $Nothing -Levels $Levels)[0] | Should -Be '    [ ExclusionList = [string[]] ]'
            (Get-DSCDocumentationSyntax -Recommendations ($script:BenchmarkRecommendations).Values -Levels $Levels) | Should -Contain '    [ LevelOne = [boolean] ]'
            (Get-DSCDocumentationSyntax -Recommendations ($script:BenchmarkRecommendations).Values -Levels $Levels) | Should -Contain '    [ LevelTwo = [boolean] ]'
        }
    }
}

Describe 'ConvertTo-DSC' {
    It 'Exports files' {
        $Splat = @{
            BenchmarkPath = "$($PSScriptRoot)\example_files\desktop_examples.xlsx"
            BenchmarkVersion = '1.8.1'
            GPOPath = "$($PSScriptRoot)\example_files"
            OutputPath = '.\Output'
            OS = 'Microsoft Windows 10 Enterprise'
            OSBuild = '1909'
            WarningAction = 'SilentlyContinue'
        }
        ConvertTo-DSC @Splat

        Test-Path -Path '.\Output\CIS_Microsoft_Windows_10_Enterprise_Release_1909\CIS_Microsoft_Windows_10_Enterprise_Release_1909.psd1' | Should -Be $True
        Test-Path -Path '.\Output\CIS_Microsoft_Windows_10_Enterprise_Release_1909\CIS_Microsoft_Windows_10_Enterprise_Release_1909.schema.psm1' | Should -Be $True
        Test-Path -Path '.\Output\CIS_Microsoft_Windows_10_Enterprise_Release_1909\CIS_Microsoft_Windows_10_Enterprise_Release_1909.md' | Should -Be $True
    }

    #ToDo find a way to actually test the composite resource can be used in a configuration successfully.
}