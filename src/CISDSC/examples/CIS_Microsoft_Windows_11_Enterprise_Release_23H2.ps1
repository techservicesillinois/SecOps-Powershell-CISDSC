#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft Windows 11 Enterprise build 23H2 with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
#>

Configuration Microsoft_Windows_11_Enterprise_23H2_CIS_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_11_Enterprise_Release_23H2'

    node 'localhost'
    {
        CIS_Microsoft_Windows_11_Enterprise_Release_23H2 'CIS Benchmarks'
        {
            cis2314AccountsRenameadministratoraccount = 'CISAdmin'
            cis2315AccountsRenameguestaccount = 'CISGuest'
            cis2376LegalNoticeCaption = 'Legal Notice'
            cis2375LegalNoticeText = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
        }
    }
}

Microsoft_Windows_11_Enterprise_23H2_CIS_L1
Start-DscConfiguration -Path '.\Microsoft_Windows_11_Enterprise_23H2_CIS_L1' -Verbose -Wait
