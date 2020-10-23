#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft_Windows_Server_2019_Member_Server build 1809 with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
#>

Configuration Microsoft_Windows_Server_2019_Member_Server_1809_CIS_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_Server_2019_Member_Server_Release_1809'

    node 'localhost'
    {
        CIS_Microsoft_Windows_Server_2019_Member_Server_Release_1809 'CIS Benchmarks'
        {
            '2315AccountsRenameadministratoraccount' = 'CISAdmin'
            '2316AccountsRenameguestaccount' = 'CISGuest'
            '2375LegalNoticeCaption' = 'Legal Notice'
            '2374LegalNoticeText' = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
        }
    }
}

Microsoft_Windows_Server_2019_Member_Server_1809_CIS_L1
Start-DscConfiguration -Path '.\Microsoft_Windows_Server_2019_Member_Server_1809_CIS_L1' -Verbose -Wait
