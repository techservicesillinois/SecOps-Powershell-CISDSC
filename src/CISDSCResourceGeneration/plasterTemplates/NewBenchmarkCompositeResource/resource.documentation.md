---
date: <%=$PLASTER_Date%>
keywords: dsc,powershell,configuration,setup,cis,security,<%=$PLASTER_PARAM_OSBuild%>
title: CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%>
---
# DSC CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%> Resource

> Applies To: Windows PowerShell 5.1 and higher

The **CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%>** resource in Windows PowerShell Desired State Configuration (DSC) provides a
mechanism to apply CIS benchmarks on a target node running <%=$PLASTER_PARAM_OS%> release <%=$PLASTER_PARAM_OSBuild%>.

## Syntax

```Syntax
CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%> [String] #ResourceName
{
<%=$PLASTER_PARAM_DocumentationSyntax%>
    [ DependsOn = [String[]] ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
```
> [!NOTE]
> `[String]` parameters with a number range specifies valid lengths.

> [!NOTE]
> The following parameters are mandatory if not added to the ExclusionList. This is because these values will always be organization specific so a default value is not appropriate.
> `<%=$PLASTER_PARAM_AccountsRenameadministratoraccountNumNoDots%>AccountsRenameadministratoraccount`,
> `<%=$PLASTER_PARAM_AccountsRenameguestaccountNumNoDots%>AccountsRenameguestaccount`,
> `<%=$PLASTER_PARAM_LegalNoticeCaptionNumNoDots%>LegalNoticeCaption`,
> `<%=$PLASTER_PARAM_LegalNoticeTextNumNoDots%>LegalNoticeText`
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

## Examples

### Example 1: Apply benchmarks with no exclusions

```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%>'

    CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%> 'CISBenchmarks'
    {
        '<%=$PLASTER_PARAM_AccountsRenameadministratoraccountNumNoDots%>AccountsRenameadministratoraccount' = 'CISAdmin'
        '<%=$PLASTER_PARAM_AccountsRenameguestaccountNumNoDots%>AccountsRenameguestaccount' = 'CISGuest'
        '<%=$PLASTER_PARAM_LegalNoticeCaptionNumNoDots%>LegalNoticeCaption' = 'Legal Notice'
        '<%=$PLASTER_PARAM_LegalNoticeTextNumNoDots%>LegalNoticeText' = @"
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
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%>'

    CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%> 'CISBenchmarks'
    {
        'ExcludeList' = @(
            '<%=$PLASTER_PARAM_LegalNoticeTextNum%>', # LegalNoticeText
            '<%=$PLASTER_PARAM_LegalNoticeCaptionNum%>', # LegalNoticeCaption
            '5.6' # IIS Admin Service (IISADMIN)
        )
        '<%=$PLASTER_PARAM_AccountsRenameadministratoraccountNumNoDots%>AccountsRenameadministratoraccount' = 'CISAdmin'
        '<%=$PLASTER_PARAM_AccountsRenameguestaccountNumNoDots%>AccountsRenameguestaccount' = 'CISGuest'
    }
}
```

### Example 3: Apply benchmarks with a dependency on LAPS
```powershell
Configuration MyConfiguration
{
    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%>'

    node 'localhost'
    {
        Package 'InstallLAPS'
        {
            Name  = 'Local Administrator Password Solution'
            Path = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
            ProductId = 'EA8CB806-C109-4700-96B4-F1F268E5036C'
        }

        CIS_<%=$PLASTER_PARAM_OSWithUnderscores%>_Release_<%=$PLASTER_PARAM_OSBuild%> 'CISBenchmarks'
        {
            'ExcludeList' = @(
                '<%=$PLASTER_PARAM_LegalNoticeTextNum%>', # LegalNoticeText
                '<%=$PLASTER_PARAM_LegalNoticeCaptionNum%>', # LegalNoticeCaption
                '5.6' # IIS Admin Service (IISADMIN)
            )
            '<%=$PLASTER_PARAM_AccountsRenameadministratoraccountNumNoDots%>AccountsRenameadministratoraccount' = 'CISAdmin'
            '<%=$PLASTER_PARAM_AccountsRenameguestaccountNumNoDots%>AccountsRenameguestaccount' = 'CISGuest'
            'DependsOn' = '[Package]InstallLAPS'
        }
    }
}
```