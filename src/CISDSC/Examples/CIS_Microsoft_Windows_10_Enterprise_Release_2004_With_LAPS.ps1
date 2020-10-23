#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft_Windows_10_Enterprise build 2004 with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
    This will also install LAPS (Local Administrator Password Solution) from the internet via download.microsoft.com unless the URL is changed to a network accesible path for your envrionment.
#>

Configuration Microsoft_Windows_10_Enterprise_2004_CIS_L1_with_LAPS
{
    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_10_Enterprise_Release_2004'

    node 'localhost'
    {
        Package 'InstallLAPS'
        {
            Name  = 'Local Administrator Password Solution'
            Path = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
            ProductId = 'EA8CB806-C109-4700-96B4-F1F268E5036C'
        }

        CIS_Microsoft_Windows_10_Enterprise_Release_2004 'CIS Benchmarks'
        {
            '2315AccountsRenameadministratoraccount' = 'CISAdmin'
            '2316AccountsRenameguestaccount' = 'CISGuest'
            '2376LegalNoticeCaption' = 'Legal Notice'
            '2375LegalNoticeText' = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
            'DependsOn' = '[Package]InstallLAPS'
        }
    }
}

Microsoft_Windows_10_Enterprise_2004_CIS_L1_with_LAPS
Start-DscConfiguration -Path '.\Microsoft_Windows_10_Enterprise_2004_CIS_L1_with_LAPS' -Verbose -Wait
