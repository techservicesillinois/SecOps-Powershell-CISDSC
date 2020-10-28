[String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src\CISDSC'
Import-Module -Name $ModuleRoot

Describe 'Module Manifest Tests' {
    It 'Module: Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\CISDSC\CISDSC.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }

    It 'DSCResources: Passes Test-ModuleManifest' {
        $ResourcePath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\CISDSC\dscresources'
        Get-ChildItem -Path $ResourcePath -Filter "*.psd1" | ForEach-Object -Process {
            Test-ModuleManifest -Path $_.FullName | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Class: CISService' {
    InModuleScope -ModuleName 'CISDSC' {
        It 'Fails a running service' {
            . "$($PSScriptRoot)\New-PSClassInstance.ps1"
            $Class = New-PSClassinstance -TypeName 'CISService'
            $Class.Name = (Get-Service | Where-Object -FilterScript {$_.status -eq 'running'})[0].Name
            $Class.Test() | Should -Be $False
        }

        It 'Passes a non-existent service' {
            . "$($PSScriptRoot)\New-PSClassInstance.ps1"
            $Class = New-PSClassinstance -TypeName 'CISService'
            $Class.Name = 'fake-service'
            $Class.Test() | Should -Be $True
        }

        It 'Passes a stopped and disabled service'{
            . "$($PSScriptRoot)\New-PSClassInstance.ps1"
            $Class = New-PSClassinstance -TypeName 'CISService'
            $Class.Name = (Get-Service | Where-Object -FilterScript {$_.status -eq 'stopped' -and $_.StartType -eq 'Disabled'})[0].Name
            $Class.Test() | Should -Be $True
        }
    }
}