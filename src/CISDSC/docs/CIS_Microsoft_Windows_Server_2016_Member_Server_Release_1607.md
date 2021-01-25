---
date: 10/19/2020
keywords: dsc,powershell,configuration,setup,cis,security,1607
title: CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607
---
# DSC CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607 Resource

> Applies To: Windows PowerShell 5.1 and higher

The **CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607** resource in Windows PowerShell Desired State Configuration (DSC) provides a
mechanism to apply CIS benchmarks on a target node running Microsoft Windows Server 2016 Member Server release 1607.

## Syntax

```Syntax
CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607 [String] #ResourceName
{
    [ ExclusionList = [String[]] ]
    [ LevelOne = [Boolean] ]
    [ LevelTwo = [Boolean] ]
    [ NextGenerationWindowsSecurity = [Boolean] ]
    [ a112MaximumPasswordAge = [Int32] { 60-999 } ]
    [ a113MinimumPasswordAge = [Int32] { 1-998 } ]
    [ a121Accountlockoutduration = [Int32] { 15-99999 } ]
    [ a122Accountlockoutthreshold = [Int32] { 10-999 } ]
    [ a123Resetaccountlockoutcounterafter = [Int32] { 15-99999 } ]
    [ a1825PasswordLength = [Int32] { 15-64 } ]
    [ a1826PasswordAgeDays = [Int32] { 30-365 } ]
    [ a18412WarningLevel = [Int32] { 0-90 } ]
    [ a1849ScreenSaverGracePeriod = [String] { '0' | '1' | '2' | '3' | '4' | '5' } ]
    [ a18910212DeferFeatureUpdatesPeriodInDays = [Int32] { 180-365 } ]
    [ a1892612MaxSize = [Int32] { 32768-2147483647 } ]
    [ a1892622MaxSize = [Int32] { 196608-2147483647 } ]
    [ a1892632MaxSize = [Int32] { 32768-2147483647 } ]
    [ a1892642MaxSize = [Int32] { 32768-2147483647 } ]
    [ a189593101MaxIdleTime = [Int32] { 60000-900000 } ]
    [ a2315AccountsRenameadministratoraccount = [String] { 1-256 } ]
    [ a2316AccountsRenameguestaccount = [String] { 1-256 } ]
    [ a2365MaximumPasswordAge = [Int32] { 1-30 } ]
    [ a2373InactivityTimeoutSecs = [Int32] { 1-900 } ]
    [ a2374LegalNoticeText = [String] { 1-2048 } ]
    [ a2375LegalNoticeCaption = [String] { 1-512 } ]
    [ a2376CachedLogonsCount = [String] { '0' | '1' | '2' | '3' | '4' } ]
    [ a2391AutoDisconnect = [Int32] { 1-15 } ]
    [ a916LogFileSize = [Int32] { 16384-2147483647 } ]
    [ a926LogFileSize = [Int32] { 16384-2147483647 } ]
    [ a938LogFileSize = [Int32] { 16384-2147483647 } ]
    [ DependsOn = [String[]] ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
```
> [!NOTE]
> `[String]` parameters with a number range specifies valid lengths.

> [!NOTE]
> The following parameters are mandatory if not added to the ExclusionList. This is because these values will always be organization specific so a default value is not appropriate.
> `a2315AccountsRenameadministratoraccount`,
> `a2316AccountsRenameguestaccount`,
> `a2376LegalNoticeCaption`,
> `a2375LegalNoticeText`
## Properties

|Property |DefaultValue | Recommendation ID|Recommendation
|---|---|---|---|
|ExcludeList | | |Excludes the provided recommendation IDs from the configuration |
|LevelOne |`$true` | |Applies level one recommendations |
|LevelTwo |`$false` | |Applies level two recommendations. Does not include level one, both must be set to `$true`. |
|NextGenerationWindowsSecurity |`$false` | |Applies Next Generation Windows Security recommendations |
|a112MaximumPasswordAge |60 |1.1.2 |(L1) Ensure 'Maximum password age' is set to '60 or fewer days, but not 0' |
|a113MinimumPasswordAge |1 |1.1.3 |(L1) Ensure 'Minimum password age' is set to '1 or more day(s)' |
|a121Accountlockoutduration |15 |1.2.1 |(L1) Ensure 'Account lockout duration' is set to '15 or more minute(s)' |
|a122Accountlockoutthreshold |10 |1.2.2 |(L1) Ensure 'Account lockout threshold' is set to '10 or fewer invalid logon attempt(s), but not 0' |
|a123Resetaccountlockoutcounterafter |15 |1.2.3 |(L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)' |
|a1825PasswordLength |15 |18.2.5 |(L1) Ensure 'Password Settings: Password Length' is set to 'Enabled: 15 or more' (MS only) |
|a1826PasswordAgeDays |30 |18.2.6 |(L1) Ensure 'Password Settings: Password Age (Days)' is set to 'Enabled: 30 or fewer' (MS only) |
|a18412WarningLevel |90 |18.4.12 |(L1) Ensure 'MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning' is set to 'Enabled: 90% or less' |
|a1849ScreenSaverGracePeriod |'0' |18.4.9 |(L1) Ensure 'MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 recommended)' is set to 'Enabled: 5 or fewer seconds' |
|a18910212DeferFeatureUpdatesPeriodInDays |180 |18.9.102.1.2 |(L1) Ensure 'Select when Preview Builds and Feature Updates are received' is set to 'Enabled: Semi-Annual Channel, 180 or more days' |
|a1892612MaxSize |32768 |18.9.26.1.2 |(L1) Ensure 'Application: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater' |
|a1892622MaxSize |196608 |18.9.26.2.2 |(L1) Ensure 'Security: Specify the maximum log file size (KB)' is set to 'Enabled: 196,608 or greater' |
|a1892632MaxSize |32768 |18.9.26.3.2 |(L1) Ensure 'Setup: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater' |
|a1892642MaxSize |32768 |18.9.26.4.2 |(L1) Ensure 'System: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater' |
|a189593101MaxIdleTime |900000 |18.9.59.3.10.1 |(L2) Ensure 'Set time limit for active but idle Remote Desktop Services sessions' is set to 'Enabled: 15 minutes or less' |
|a2315AccountsRenameadministratoraccount | |2.3.1.5 |(L1) Configure 'Accounts: Rename administrator account' |
|a2316AccountsRenameguestaccount | |2.3.1.6 |(L1) Configure 'Accounts: Rename guest account' |
|a2365MaximumPasswordAge |30 |2.3.6.5 |(L1) Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0' |
|a2373InactivityTimeoutSecs |900 |2.3.7.3 |(L1) Ensure 'Interactive logon: Machine inactivity limit' is set to '900 or fewer second(s), but not 0' |
|a2374LegalNoticeText | |2.3.7.4 |(L1) Configure 'Interactive logon: Message text for users attempting to log on' |
|a2375LegalNoticeCaption | |2.3.7.5 |(L1) Configure 'Interactive logon: Message title for users attempting to log on' |
|a2376CachedLogonsCount |'4' |2.3.7.6 |(L2) Ensure 'Interactive logon: Number of previous logons to cache (in case domain controller is not available)' is set to '4 or fewer logon(s)' (MS only) |
|a2391AutoDisconnect |15 |2.3.9.1 |(L1) Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)' |
|a916LogFileSize |16384 |9.1.6 |(L1) Ensure 'Windows Firewall: Domain: Logging: Size limit (KB)' is set to '16,384 KB or greater' |
|a926LogFileSize |16384 |9.2.6 |(L1) Ensure 'Windows Firewall: Private: Logging: Size limit (KB)' is set to '16,384 KB or greater' |
|a938LogFileSize |16384 |9.3.8 |(L1) Ensure 'Windows Firewall: Public: Logging: Size limit (KB)' is set to '16,384 KB or greater' |

## Common properties

|Property |Description |
|---|---|
|DependsOn |Indicates that the configuration of another resource must run before this resource is configured. For example, if the ID of the resource configuration script block that you want to run first is ResourceName and its type is ResourceType, the syntax for using this property is `DependsOn = "[ResourceType]ResourceName"`. |
|PsDscRunAsCredential |Sets the credential for running the entire resource as. |

> [!NOTE]
> The **PsDscRunAsCredential** common property was added in WMF 5.0 to allow running any DSC
> resource in the context of other credentials. For more information, see [Use Credentials with DSC Resources](https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/runasuser?view=powershell-7).

## Examples

### Example 1: Apply benchmarks with no exclusions

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607'

    CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607 'CISBenchmarks'
    {
        'a2315AccountsRenameadministratoraccount' = 'CISAdmin'
        'a2316AccountsRenameguestaccount' = 'CISGuest'
        'a2376LegalNoticeCaption' = 'Legal Notice'
        'a2375LegalNoticeText' = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
    }
}
```

### Example 2: Apply benchmarks with exclusions

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607'

    CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607 'CISBenchmarks'
    {
        'ExcludeList' = @(
            '2.3.7.5', # LegalNoticeText
            '2.3.7.6', # LegalNoticeCaption
            '5.6' # IIS Admin Service (IISADMIN)
        )
        'a2315AccountsRenameadministratoraccount' = 'CISAdmin'
        'a2316AccountsRenameguestaccount' = 'CISGuest'
    }
}
```

### Example 3: Apply benchmarks with a dependency on LAPS
```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607'

    node 'localhost'
    {
        Package 'InstallLAPS'
        {
            Name  = 'Local Administrator Password Solution'
            Path = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
            ProductId = 'EA8CB806-C109-4700-96B4-F1F268E5036C'
        }

        CIS_Microsoft_Windows_Server_2016_Member_Server_Release_1607 'CISBenchmarks'
        {
            'ExcludeList' = @(
                '2.3.7.5', # LegalNoticeText
                '2.3.7.6', # LegalNoticeCaption
                '5.6' # IIS Admin Service (IISADMIN)
            )
            'a2315AccountsRenameadministratoraccount' = 'CISAdmin'
            'a2316AccountsRenameguestaccount' = 'CISGuest'
            'DependsOn' = '[Package]InstallLAPS'
        }
    }
}
```
