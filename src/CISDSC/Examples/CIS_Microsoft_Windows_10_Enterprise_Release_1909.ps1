Configuration Win10_1909_L1
{
    Import-DSCResource -ModuleName 'CISDSC'

    node 'localhost'
    {
        CIS_Microsoft_Windows_10_Enterprise_Release_1909 'CIS Benchmarks'
        {
            #These exclusions are services that are not in default installs of Windows. Remove the exlusions if they are applicable to your envrionment.
            'ExcludeList' = @('5.6','5.7','5.10','5.11','5.14','5.28','5.32','5.40')
            '2315AccountsRenameadministratoraccount' = 'CISAdmin'
            '2316AccountsRenameguestaccount' = 'CISGuest'
            '2375LegalNoticeText' = 'Legal says only we can use these machines.'
            '2376LegalNoticeCaption' = 'Legal Notice'
        }
    }
}

Win10_1909_L1
#Uncomment the following line to also apply the configuration on the localmachine
#Start-DscConfiguration -Path '.\Win10_1909_L1' -Verbose -Wait