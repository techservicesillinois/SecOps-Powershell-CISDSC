[String]$SourceRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src'
[String]$ModuleRoot = Join-Path -Path $SourceRoot -ChildPath 'CISDSCResourceGeneration'
($ENV:PSModulePath.split(';')) + $SourceRoot -join ';'
Import-Module -Name 'CISDSCResourceGeneration'

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}
