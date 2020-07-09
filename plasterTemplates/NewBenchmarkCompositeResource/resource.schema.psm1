Configuration CIS_<%=$PLASTER_PARAM_OS%>_Release_<%=$PLASTER_PARAM_OSBuild%>
{
    param
    (
        [string[]]
        $ExcludeList,

        [int]
        [ValidateRange(1,2)]
        $Level = 1,

        [boolean]
        $BitLocker = $false,

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

    #region 1 Category name

    #region 1.1 Section name
    if($ExcludeList -notcontains '1.1.1'){
    }
    #endregion

    #endregion

    #region 2 Category name

    #region 2.1 Section name
    if($ExcludeList -notcontains '2.1.1'){
    }

    if($ExcludeList -notcontains '2.1.2' -and $Level -eq 2){
        #Benchmarks contain two levels of settings. Level two is more intense so we assume one but have level two settings available.
    }

    if($ExcludeList -notcontains '2.2.1' -and $BitLocker){
        #Benchmarks have a small amount of settings that are related to bitlocker but bitlocker itself is not required for the benchmark so they are optional extensions.
    }
    #endregion

    #endregion

    #region 3 Category name
        #This section is intentionally blank and exists to ensure the structure of Windows benchmarks is consistent.
    #endregion
}