Configuration CIS_<%=$PLASTER_PARAM_OS%>_Release_<%=$PLASTER_PARAM_OSBuild%>
{
    param
    (
        [string[]]
        $ExcludeList,

        [boolean]
        $LevelTwo = $false,

        [boolean]
        $BitLocker = $false,

        [boolean]
        $NextGenerationWindowsSecurity = $false,

        [String]
        $LocalAdminNewName = 'CISADMIN',

        [string]
        $LocalGuestNewName = 'CISGUEST',

        [string]
        $LegalNoticeText = 'ADD TEXT HERE',

        [string]
        $LegalNoticeCaption = 'ADD TEXT HERE'

        <#
        Some benchmarks have multiple valid values or a value that is atleast/at most a value.
        These are examples about how to implement

        [int]
        [ValidateRange(1,15)]
        $2391AutoDisconnectIdleTime = 15,

        [string]
        [ValidateSet("Lock Workstation","Force Logoff","Disconnect if a Remote Desktop Services session")]
        $2379ScRemoveOption = "Lock Workstation"
        #>
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion '1.4.0.0'
    Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion '2.10.0.0'

}