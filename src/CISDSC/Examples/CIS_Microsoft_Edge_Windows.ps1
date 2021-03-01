#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft Edge with no exclusions on Windows.
    Exclusion documentation can be found in the docs folder of this module.
#>

Configuration Microsoft_Edge_CIS_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Edge_Windows'

    node 'localhost'
    {
        Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Edge_Windows'

        CIS_Microsoft_Edge_Windows 'Microsoft Edge CISBenchmarks'
        {
        }
    }
}

Microsoft_Edge_CIS_L1
Start-DscConfiguration -Path '.\Microsoft_Edge_CIS_L1' -Verbose -Wait

