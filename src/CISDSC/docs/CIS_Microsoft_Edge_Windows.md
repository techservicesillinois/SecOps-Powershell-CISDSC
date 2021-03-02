---
date: 3/1/2021
keywords: dsc,powershell,configuration,setup,cis,security,Microsoft Edge
title: CIS_Microsoft_Edge_Windows
---
# DSC CIS_Microsoft_Edge_Windows Resource

> Applies To: Windows PowerShell 5.1 and higher

The **CIS_Microsoft_Edge_Windows** resource in Windows PowerShell Desired State Configuration (DSC) provides a
mechanism to apply CIS benchmarks on a target node for Microsoft Edge.

## Syntax

```Syntax
CIS_Microsoft_Edge_Windows [String] #ResourceName
{
    [ ExcludeList = [String[]] ]
    [ LevelOne = [Boolean] ]
    [ LevelTwo = [Boolean] ]

    [ DependsOn = [String[]] ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
```
> [!NOTE]
> `[String]` parameters with a number range specifies valid lengths.

## Properties

|Property |DefaultValue | Recommendation ID|Recommendation
|---|---|---|---|
|ExcludeList | | |Excludes the provided recommendation IDs from the configuration |
|LevelOne |`$true` | |Applies level one recommendations |
|LevelTwo |`$false` | |Applies level two recommendations. Does not include level one, both must be set to `$true`. |


## Common properties

|Property |Description |
|---|---|
|DependsOn |Indicates that the configuration of another resource must run before this resource is configured. For example, if the ID of the resource configuration script block that you want to run first is ResourceName and its type is ResourceType, the syntax for using this property is `DependsOn = "[ResourceType]ResourceName"`. |
|PsDscRunAsCredential |Sets the credential for running the entire resource as. |

> [!NOTE]
> The **PsDscRunAsCredential** common property was added in WMF 5.0 to allow running any DSC
> resource in the context of other credentials. For more information, see [Use Credentials with DSC Resources](https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/runasuser?view=powershell-7).

> [!NOTE]
> Microsoft Edge should be installed prior to running the benchmarks or settings risk being overwritten by the installer.

## Examples

### Example 1: Apply benchmarks with no exclusions

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Edge_Windows'

    CIS_Microsoft_Edge_Windows 'Microsoft Edge CISBenchmarks'
    {
    }
}
```

### Example 2: Apply benchmarks with exclusions

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_Microsoft_Edge_Windows'

    CIS_Microsoft_Edge_Windows 'Microsoft Edge CISBenchmarks'
    {
        ExcludeList = @(
            '1.1.51', # (L1) Ensure 'Enable Proactive Authentication' is set to 'Disabled'
            '1.1.60' # (L1) Ensure 'Enable use of ephemeral profiles' is set to 'Disabled'
        )
    }
}
```

### Example 3: Apply both browser and Windows benchmarks

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC'

    # CIS_Microsoft_Windows_10_Enterprise_Release_20H2 is used for example purposes. Use the resource applicable to your system's build.
    CIS_Microsoft_Windows_10_Enterprise_Release_20H2 'System CISBenchmarks'
    {
        cis2315AccountsRenameadministratoraccount = 'CISAdmin'
        cis2316AccountsRenameguestaccount = 'CISGuest'
        cis2376LegalNoticeCaption = 'Legal Notice'
        cis2375LegalNoticeText = @"
This is a super secure device that we don't want bad people using.
I'm even making sure to put this as a literal string so that I can cleanly
use multiple lines to tell you how super secure it is.
"@
    }

    CIS_Microsoft_Edge_Windows 'Microsoft Edge CISBenchmarks'
    {
    }
}
```

