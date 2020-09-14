Configuration Win10_2004_L1_With_LAPS
{
    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_10_Enterprise_Release_2004'

    node 'localhost'
    {
        Package 'InstallLAPS' {
            Name  = 'Local Administrator Password Solution'
            #Path can be substituted for a file path in your envrionment
            Path = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
            ProductId = 'EA8CB806-C109-4700-96B4-F1F268E5036C'
        }

        CIS_Microsoft_Windows_10_Enterprise_Release_2004 'CIS Benchmarks' {
            #These exclusions are services that are not in default installs of Windows. Remove the exlusions if they are applicable to your envrionment.
            'ExcludeList' = @(
                '5.6', # IIS Admin Service (IISADMIN)
                '5.7', # Infrared monitor service (irmon)
                '5.10',# LxssManager (LxssManager)
                '5.11',# Microsoft FTP Service (FTPSVC)
                '5.14',# OpenSSH SSH Server (sshd)
                '5.28',# Simple TCP/IP Services (simptcp)
                '5.32',# Web Management Service (WMSvc)
                '5.40' # World Wide Web Publishing Service (W3SVC)
            )
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

Win10_2004_L1_With_LAPS
#Uncomment the following line to also apply the configuration on the localmachine
#Start-DscConfiguration -Path '.\Win10_2004_L1_With_LAPS' -Verbose -Wait -Force
#This version will capture errors and verbose to a log file
#Start-DscConfiguration -Path '.\Win10_2004_L1_With_LAPS' -Verbose -Wait -Force 4>&1 2>&1 > 'c:\DSC.log'