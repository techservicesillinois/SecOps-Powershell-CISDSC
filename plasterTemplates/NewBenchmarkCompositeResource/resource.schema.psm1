Configuration CIS_<%=$PLASTER_PARAM_Level%>_<%=$PLASTER_PARAM_OS%>_Release_<%=$PLASTER_PARAM_OSBuild%>
{
    param
    (
        [string]
        $Node = 'localhost',

        [string[]]
        $ExcludeList
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion '1.4.0.0'
	Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion '2.10.0.0'

    Node $Node
    {
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
        #endregion

        #endregion
    }
}