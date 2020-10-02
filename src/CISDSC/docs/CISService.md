---
date: 9/30/2020
keywords: dsc,powershell,configuration,setup,cis,security,service
title: CISService
---
# DSC CISService

> Applies To: Windows PowerShell 5.1 and higher

The **CISService** resource in Windows PowerShell Desired State Configuration (DSC) provides a
mechanism to configure services based on CIS guidelines. This differs from the default service resource in that it will consider disabled or absent a pass. This removes the need to exclude non-existent service from your configurations. If the specified service exists it will be stopped and disabled.

## Syntax

```Syntax
CISService [string] #ResourceName
{
    Name = [string]
    [ DependsOn = [string[]] ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
```

## Properties

|Property |Description |
|---|---|
|Name |Name of the service. |

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
Configuration CISService
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CISService'

    CISService "5.3 - (L1) Ensure Computer Browser (Browser) is set to Disabled or Not Installed" {
        Name = 'Browser'
    }
}