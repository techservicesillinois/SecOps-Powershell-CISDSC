---
date: <%=$PLASTER_Date%>
keywords: dsc,powershell,configuration,setup,cis,security,<%=$PLASTER_PARAM_Browser%>
title: CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows
---
# DSC CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows Resource

> Applies To: Windows PowerShell 5.1 and higher

The **CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows** resource in Windows PowerShell Desired State Configuration (DSC) provides a
mechanism to apply CIS benchmarks on a target node for <%=$PLASTER_PARAM_Browser%>.

## Syntax

```Syntax
CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows [String] #ResourceName
{
<%=$PLASTER_PARAM_DocumentationSyntax%>
    [ DependsOn = [String[]] ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
```
> [!NOTE]
> `[String]` parameters with a number range specifies valid lengths.

## Properties

|Property |DefaultValue | Recommendation ID|Recommendation
|---|---|---|---|
<%=$PLASTER_PARAM_DocumentationPropertyTable%>

## Common properties

|Property |Description |
|---|---|
|DependsOn |Indicates that the configuration of another resource must run before this resource is configured. For example, if the ID of the resource configuration script block that you want to run first is ResourceName and its type is ResourceType, the syntax for using this property is `DependsOn = "[ResourceType]ResourceName"`. |
|PsDscRunAsCredential |Sets the credential for running the entire resource as. |

> [!NOTE]
> The **PsDscRunAsCredential** common property was added in WMF 5.0 to allow running any DSC
> resource in the context of other credentials. For more information, see [Use Credentials with DSC Resources](https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/runasuser?view=powershell-7).

> [!NOTE]
> <%=$PLASTER_PARAM_Browser%> should be installed prior to running the benchmarks or settings risk being overwritten by the installer.

## Examples

### Example 1: Apply benchmarks with no exclusions

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows'

    CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows '<%=$PLASTER_PARAM_Browser%> CISBenchmarks'
    {
    }
}
```

### Example 2: Apply benchmarks with exclusions

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows'

    CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows '<%=$PLASTER_PARAM_Browser%> CISBenchmarks'
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

    CIS_<%=$PLASTER_PARAM_BrowserWithUnderscores%>_Windows '<%=$PLASTER_PARAM_Browser%> CISBenchmarks'
    {
    }
}
```
