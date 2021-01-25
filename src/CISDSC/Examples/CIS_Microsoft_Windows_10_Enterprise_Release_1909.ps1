#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Windows 10 build 1909 with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
#>

Configuration Win10_1909_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_10_Enterprise_Release_1909'

    node 'localhost'
    {
        CIS_Microsoft_Windows_10_Enterprise_Release_1909 'CIS Benchmarks'
        {
            'a2315AccountsRenameadministratoraccount' = 'CISAdmin'
            'a2316AccountsRenameguestaccount' = 'CISGuest'
            'a2376LegalNoticeCaption' = 'Legal Notice'
            'a2375LegalNoticeText' = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
        }
    }
}

Win10_1909_L1
Start-DscConfiguration -Path '.\Win10_1909_L1'-Verbose -Wait