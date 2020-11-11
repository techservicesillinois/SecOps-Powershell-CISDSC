# Auditing
DSC has the ability to operate in an audit only capacity. It notably will not tell you the current state of the setting just a true/false value for it the setting is in your desired state.
This can be used to get a baseline of your system to see where you're at in accordance with the CIS benchmarks.

## Example
Any of the provided [examples](/src/CISDSC/Examples) can be altered to work in an audit only capacity. Below is an example of how to export your system's baseline to CSV.

In your system's applicable example remove the last line which should look something like this
```powershell
Start-DscConfiguration -Path '.\Microsoft_Windows_Server_2019_Member_Server_1809_CIS_L1' -Verbose -Wait
```

and replace it with this
```powershell
$Report = Test-DscConfiguration -Path '.\Microsoft_Windows_Server_2019_Member_Server_1809_CIS_L1' -Verbose
$Report.ResourcesInDesiredState | Select-Object -Property 'ResourceId','InDesiredState' | Export-CSV -Path '.\ResourcesInDesiredState.csv'
$Report.ResourcesNotInDesiredState | Select-Object -Property 'ResourceId','InDesiredState' | Export-CSV -Path '.\ResourcesNotInDesiredState.csv'
```

This should have your script looking similar to the following
```powershell
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
$Report = Test-DscConfiguration -Path '.\Microsoft_Windows_Server_2019_Member_Server_1809_CIS_L1' -Verbose
$Report.ResourcesInDesiredState | Select-Object -Property 'ResourceId','InDesiredState' | Export-CSV -Path '.\ResourcesInDesiredState.csv' -NoTypeInformation
$Report.ResourcesNotInDesiredState | Select-Object -Property 'ResourceId','InDesiredState' | Export-CSV -Path '.\ResourcesNotInDesiredState.csv' -NoTypeInformation
```

You will now have two CSV files at your shell's working directory.
- ResourcesInDesiredState.csv: System settings that meet the benchmark's recommendation
- ResourcesNotInDesiredState.csv: System settings that do not meet the benchmark's recommendation

Using the ResourceId column of the reports you can easily correlate the settings to their [CIS](./cis.md) documentation.