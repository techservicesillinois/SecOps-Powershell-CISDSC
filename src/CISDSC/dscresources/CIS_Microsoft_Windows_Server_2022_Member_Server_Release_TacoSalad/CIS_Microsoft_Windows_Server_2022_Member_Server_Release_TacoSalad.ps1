#Requires -module CISDSC
#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Applies CIS Level one benchmarks for Microsoft Windows Server 2022 Member Server build TacoSalad with no exclusions.
    Exclusion documentation can be found in the docs folder of this module.
#>

Configuration Microsoft_Windows_Server_2022_Member_Server_TacoSalad_CIS_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_Server_2022_Member_Server_Release_TacoSalad'

    node 'localhost'
    {
        CIS_Microsoft_Windows_Server_2022_Member_Server_Release_TacoSalad 'CIS Benchmarks'
        {
            cis2315AccountsRenameadministratoraccount = 'CISAdmin'
            cis2316AccountsRenameguestaccount = 'CISGuest'
            cis2375LegalNoticeCaption = 'Legal Notice'
            cis2374LegalNoticeText = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
        }
    }
}

Microsoft_Windows_Server_2022_Member_Server_TacoSalad_CIS_L1
Start-DscConfiguration -Path '.\Microsoft_Windows_Server_2022_Member_Server_TacoSalad_CIS_L1' -Verbose -Wait
