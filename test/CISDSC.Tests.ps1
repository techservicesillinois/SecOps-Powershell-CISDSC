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
