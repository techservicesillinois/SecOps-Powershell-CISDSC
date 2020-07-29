[String]$SourceRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src'
[String]$ModuleRoot = Join-Path -Path $SourceRoot -ChildPath 'CISDSCResourceGeneration'
Import-Module -Name "$($ModuleRoot)\CISDSCResourceGeneration.psd1"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}

Describe 'Class: Recommendation' {
    InModuleScope -ModuleName 'CISDSCResourceGeneration' {
        It 'Constructs from an Excel recommendation row' {
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\test_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.Title -like "(L1)*"})[0]
            {[Recommendation]::New($ExcelExample)} | Should -Not -Throw
        }

        It 'Correctly translates all known levels from the title' -TestCases @(
            @{ Prefix = '(L1)'; Translation = 'LevelOne' },
            @{ Prefix = '(L2)'; Translation = 'LevelTwo' },
            @{ Prefix = '(BL)'; Translation = 'BitLocker' },
            @{ Prefix = '(NG)'; Translation = 'NextGenerationWindowsSecurity' }
        ){
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\test_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
                Where-Object -FilterScript {$_.Title -like "(L1)*"})[0]
            $ExcelExample.Title = $ExcelExample.Title.replace('(L1)',$Prefix)
            ([Recommendation]::New($ExcelExample)).Level | Should -Be $Translation
        }

        It 'Converts the recommendation numbers to versions' -TestCases @(
            @{ num = '1.1.1'; version = [version]'1.1.1'},
            @{ num = '1.1.1.1'; version = [version]'1.1.1.1' }
            @{ num = '1.1.1.1.1.1'; version = [version]'1.1.1.111' }
        ){
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\test_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
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
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\test_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
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
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\test_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
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
            $ExcelExample = (Import-Excel -Path "$($PSScriptRoot)\example_files\test_examples.xlsx" -WorksheetName 'Level 1 (L1) - Corporate_Enter' |
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