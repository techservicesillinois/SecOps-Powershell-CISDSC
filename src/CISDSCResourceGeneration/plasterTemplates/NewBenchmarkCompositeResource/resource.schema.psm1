CIS_<%=$PLASTER_PARAM_OS%>_Release_<%=$PLASTER_PARAM_OSBuild%>
{
    param
    (
        <%=$PLASTER_PARAM_DSCParameters%>
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion '1.4.0.0'
    Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion '2.10.0.0'

<%=$PLASTER_PARAM_DSCScaffolding%>
}