[String]$SourceRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src'
[String]$ModuleRoot = Join-Path -Path $SourceRoot -ChildPath 'CISDSC'
($ENV:PSModulePath.split(';')) + $SourceRoot -join ';'
Import-Module -Name 'CISCDSC'

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\CISDSC\CISDSC.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }

    It 'Exports all of its DSCResources' {
        $CompareSplat = @{
            ReferenceObject = (Get-Module -Name 'CISDSC' -ListAvailable).ExportedDscResources
            DifferenceObject = (Get-ChildItem -Path "$($ModuleRoot)\dscresources" -Directory).Name
        }
        Compare-Object @CompareSplat | Should -Be $null
    }
}