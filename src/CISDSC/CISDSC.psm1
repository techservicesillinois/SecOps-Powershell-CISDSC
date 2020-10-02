#This resource is used to more accurately reflect the spirit of the CIS benchmarks for services. The recommendations are considered passed if the service is disabled or absent and this is not possible with the standard service resource.
[DscResource()]
class CISService
{
    [DscProperty(Key)]
    [string]
    $Name

    [DscProperty(NotConfigurable)]
    [string]
    $StartType

    [DscProperty(NotConfigurable)]
    [string]
    $Status

    [CISService]Get()
    {
        $Service = $This.GetService()
        $This.StartType = $Service.StartType
        $This.Status = $Service.Status
        return $This
    }

    [bool]Test()
    {
        $Service = $This.GetService()
        # Is the service abscent or disabled + stopped. Abscent is considered desired state.
        $Test = ($null -eq $Service -or ($Service.StartType -eq 'Disabled' -and $Service.Status -eq 'Stopped'))
        return $Test
    }

    [void]Set()
    {
        Stop-Service -Name $This.Name -Force
        Get-Service -Name $This.Name | Set-Service -StartupType 'Disabled'
    }

    [Object]GetService()
    {
        if($Service = Get-Service -Name $This.Name -ErrorAction SilentlyContinue){
            $result = $Service
        }
        else{
            $result = $null
        }

        return $result
    }
}