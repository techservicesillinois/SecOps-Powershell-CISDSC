[String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src\CISDSC'
Import-Module -Name $ModuleRoot

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\CISDSC\CISDSC.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}
