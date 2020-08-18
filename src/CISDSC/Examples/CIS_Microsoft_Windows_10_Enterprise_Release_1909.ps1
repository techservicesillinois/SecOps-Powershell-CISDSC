Configuration Win10_1909_L1
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_10_Enterprise_Release_1909'

    node 'localhost'
    {
        CIS_Microsoft_Windows_10_Enterprise_Release_1909 'CIS Benchmarks'
        {
            #These exclusions are services that are not in default installs of Windows. Remove the exlusions if they are applicable to your envrionment.
            'ExcludeList' = @('5.6','5.7','5.10','5.11','5.14','5.28','5.32','5.40')
            '2315AccountsRenameadministratoraccount' = 'CISAdmin'
            '2316AccountsRenameguestaccount' = 'CISGuest'
            '2376LegalNoticeCaption' = 'Legal Notice'
            '2375LegalNoticeText' = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
        }
    }
}

Win10_1909_L1
#Uncomment the following line to also apply the configuration on the localmachine
#Start-DscConfiguration -Path '.\Win10_1909_L1' -Verbose -Wait -Force
#This version will capture errors and verbose to a log file
#Start-DscConfiguration -Path '.\Win10_1909_L1' -Verbose -Wait -Force 4>&1 2>&1 > 'c:\DSC.log'