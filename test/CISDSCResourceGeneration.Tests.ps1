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
            @{ Title = "(L1) Ensure 'Enforce password history' is set to '24 or more password(s)'"; Expectation = "(L1) Ensure Enforce password history is set to 24 or more password(s)"},
            @{ Title = "(L1) Ensure 'Interactive logon: Do not require CTRL+ALT+DEL' is set to 'Disabled'"; Expectation = "(L1) Ensure Interactive logon Do not require CTRLALTDEL is set to Disabled"},
            @{ Title = @"
(L1) Ensure 'Remove access to “Pause updates” feature' is set to 'Enabled''
"@; Expectation = "(L1) Ensure Remove access to Pause updates feature is set to Enabled" }
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
            $Name = '2373MaxDevicePasswordFailedAttempts'
            $DataType = "'[Int32]'"
            $DefaultValue = "10"
            $Title = "(BL) Ensure Interactive logon Machine account lockout threshold is set to 10 or fewer invalid logon attempts but not 0"
            {[DSCConfigurationParameter]::New($Name,$DataType,$DefaultValue,$Title)} | Should -Not -Throw
        }

        It 'Creates validation blocks properly' -TestCases @(
            @{ Title = "(BL) Ensure Interactive logon Machine account lockout threshold is set to 10 or fewer invalid logon attempts but not 0"; Expectation = "[ValidateRange(1,10)]" },
            @{ Title = "(BL) Ensure Interactive logon Machine account lockout threshold is set to 10 or fewer invalid logon attempts"; Expectation = "[ValidateRange(0,10)]" },
            @{ Title = "(BL) Ensure Interactive logon Machine account lockout threshold is set to 10 or more invalid logon attempts"; Expectation = "[ValidateRange(10,$([int32]::MaxValue))]" },
            @{ Title = "(BL) Ensure Interactive logon Machine account lockout threshold is set to between 10 and 20 invalid logon attempts"; Expectation = "[ValidateRange(10,20)]" },
            @{ Title = "(BL) Ensure Interactive logon Machine account lockout threshold is set to whatever I'm not your boss invalid logon attempts"; Expectation = [string]::Empty }
        ){
            $Name = '2373MaxDevicePasswordFailedAttempts'
            $DataType = "'[Int32]'"
            $DefaultValue = "10"
            $Title = $Title
            ([DSCConfigurationParameter]::New($Name,$DataType,$DefaultValue,$Title)).validation | Should -Be $Expectation
        }
    }
}

Describe 'Class: ScaffoldingBlock' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Adjusts for detected parameters' {
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.'Recommendation #' -eq '1.1.1'})

            $Recommendation1 = [Recommendation]::New($ExcelExample)
            $Recommendation2 = [Recommendation]::New($ExcelExample)
            $Recommendation2.DSCParameter = $False
            $ResourceParameters = @{
                'Name' = 'Enforce_password_history'
                'Enforce_password_history' = 24
            }

            $script:UsedResourceTitles.clear()
            $Block2 = [ScaffoldingBlock]::New($Recommendation2, 'AccountPolicy', $ResourceParameters)
            $script:UsedResourceTitles.clear()
            $Block1 = [ScaffoldingBlock]::New($Recommendation1, 'AccountPolicy', $ResourceParameters)

            $Block1.TextBlock | Should -Not -Be $Block2.TextBlock
        }

        It 'Adjusts title name if its a repeat' {
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.'Recommendation #' -eq '1.1.1'})

            $Recommendation = [Recommendation]::New($ExcelExample)
            $ResourceParameters = @{
                'Name' = 'Enforce_password_history'
                'Enforce_password_history' = 24
            }
            $script:UsedResourceTitles.clear()
            $Block1 = [ScaffoldingBlock]::New($Recommendation, 'AccountPolicy', $ResourceParameters)
            $Block2 = [ScaffoldingBlock]::New($Recommendation, 'AccountPolicy', $ResourceParameters)

            $script:UsedResourceTitles[0] | Should -Be $script:UsedResourceTitles[1]
            $Block1.TextBlock | Should -Not -Be $Block2.TextBlock
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

        It 'Finds all the caegories' {
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

Describe 'Helper: Update-CISBenchmarkData' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Stores [Recommendation] objects in script scope' {
            $script:BenchmarkRecommendations.Clear()
            Update-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            $script:BenchmarkRecommendations.Values[0] -is [Recommendation]
        }

        It 'Updates the unique section values' {
            Update-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'

            $script:ServiceSection | Should -Be 5
            $script:UserSection | Should -Be 19
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
            Update-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            (Get-RecommendationFromGPOHash -GPOHash $GPOHash -Type $Type | Measure-Object).count | Should -Be 1
        }

        It 'Writes a warning for zero recommendations returned' {
            Update-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            Get-RecommendationFromGPOHash -GPOHash @{'Name' = 'NotReal'} -Type 'Service' 3>&1 | Should -Be 'Failed to find a recommendation for Service NotReal.'
        }

        It 'Writes a warning for multiple recommendations returned' {
            Update-CISBenchmarkData -Path "$($PSScriptRoot)\example_files\desktop_examples.xlsx" -OS 'Microsoft Windows 10 Enterprise'
            Get-RecommendationFromGPOHash -GPOHash @{'Name' = 'a'} -Type 'Service' 3>&1 | Should -Be 'Found multiple recommendation matches for Service a.'
        }
    }
}