#This resource is used to more accurately reflect the spirit of the CIS benchmarks for services. The recommendations are considered passed if the service is disabled or absent and this is not possible with the standard service resource.
[DscResource()]
class CISService
{
    [DscProperty(Key)]
    [String]$Name

    [DscProperty(NotConfigurable)]
    [String]$StartType

    [DscProperty(NotConfigurable)]
    [String]$Status

    [CISService]Get(){
        $Service = $This.GetService()
        $This.StartType = $Service.StartType
        $This.Status = $Service.Status
        return $This
    }

    [Boolean]Test(){
        $Service = $This.GetService()
        # Is the service absent or disabled? Eiher of these are desired state.
        $Test = ($null -eq $Service -or ($Service.StartType -eq 'Disabled' -and $Service.Status -eq 'Stopped'))
        return $Test
    }

    [Void]Set(){
        Stop-Service -Name $This.Name -Force
        Get-Service -Name $This.Name | Set-Service -StartupType 'Disabled'
    }

    [Object]GetService(){
        if($Service = Get-Service -Name $This.Name -ErrorAction 'SilentlyContinue'){
            $result = $Service
        }
        else{
            $result = $null
        }

        return $result
    }
}