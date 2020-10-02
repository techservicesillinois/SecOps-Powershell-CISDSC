#Requires -module CISDSC

<#
    .DESCRIPTION
    CISService will consider disabled or absent to be desired state for a given service. If the service is found not be in desired state it will be stopped and disabled.
#>

Configuration MyService
{
    Import-DSCResource -ModuleName 'CISDSC' -Name 'CISService'

    node 'localhost'
    {
        CISService 'Disable browser service'
        {
            Name = 'browser'
        }
    }
}

MyService
Start-DscConfiguration -Path '.\MyService'-Verbose -Wait