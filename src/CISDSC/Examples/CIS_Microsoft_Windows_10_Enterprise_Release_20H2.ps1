#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft Windows 10 Enterprise build 20H2 with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
#>

Configuration Microsoft_Windows_10_Enterprise_20H2_CIS_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_10_Enterprise_Release_20H2'

    node 'localhost'
    {
        CIS_Microsoft_Windows_10_Enterprise_Release_20H2 'CIS Benchmarks'
        {
            cis2375LegalNoticeTextAccountsRenameadministratoraccountNumNoDots%>AccountsRenameadministratoraccount = 'CISAdmin'
            cis2375LegalNoticeTextAccountsRenameguestaccountNumNoDots%>AccountsRenameguestaccount = 'CISGuest'
            cis2375LegalNoticeTextLegalNoticeCaptionNumNoDots%>LegalNoticeCaption = 'Legal Notice'
            cis2375LegalNoticeTextLegalNoticeTextNumNoDots%>LegalNoticeText = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
        }
    }
}

Microsoft_Windows_10_Enterprise_20H2_CIS_L1
Start-DscConfiguration -Path '.\Microsoft_Windows_10_Enterprise_20H2_CIS_L1' -Verbose -Wait
