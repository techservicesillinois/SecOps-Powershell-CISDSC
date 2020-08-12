Configuration Win10_1909
{
    Import-DSCResource -ModuleName 'CISDSC'

    node 'localhost'
    {
        CIS_Microsoft_Windows_10_Enterprise_Release_1909 'CIS Benchmarks'
        {
            '2315AccountsRenameadministratoraccount' = 'CISAdmin'
            '2316AccountsRenameguestaccount' = 'CISGuest'
            '2375LegalNoticeText' = 'Legal says only we can use these machines.'
            '2376LegalNoticeCaption' = 'Legal Notice'
        }
    }
}

Win10_1909