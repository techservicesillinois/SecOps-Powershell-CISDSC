#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft Windows Server 2016 Member Server build 1607 with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
#>

Configuration Microsoft_Windows_Server_2016_Member_Server_1607_CIS_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607'

    node 'localhost'
    {
        CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607 'CIS Benchmarks'
        {
            a2315AccountsRenameadministratoraccount = 'CISAdmin'
            a2316AccountsRenameguestaccount = 'CISGuest'
            a2375LegalNoticeCaption = 'Legal Notice'
            a2374LegalNoticeText = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
        }
    }
}

Microsoft_Windows_Server_2016_Member_Server_1607_CIS_L1
Start-DscConfiguration -Path '.\Microsoft_Windows_Server_2016_Member_Server_1607_CIS_L1' -Verbose -Wait
