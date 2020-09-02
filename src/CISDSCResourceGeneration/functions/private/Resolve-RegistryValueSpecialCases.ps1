Function Resolve-RegistryValueSpecialCases
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Collections.Hashtable]$regHash
    )

    [string]$RegistryPath = Join-Path -Path $regHash['Key'] -ChildPath $regHash['ValueName']
    # Special Cases.
    switch($RegistryPath){
        'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\PauseFeatureUpdatesStartTime'{
            #There is an encoding error on registry.pol that makes this a mystery character
            #According to MS this is a Dword that needs to be any value but 1 to be disabled https://docs.microsoft.com/en-us/windows/deployment/update/waas-configure-wufb
            $regHash.ValueData = 0
            $regHash.ValueType = 'Dword'
        }

        'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\PauseQualityUpdatesStartTime'{
            #There is an encoding error on registry.pol that makes this a mystery character
            #According to MS this is a Dword that needs to be any value but 1 to be disabled https://docs.microsoft.com/en-us/windows/deployment/update/waas-configure-wufb
            $regHash.ValueData = 0
            $regHash.ValueType = 'Dword'
        }

        'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\ScreenSaverGracePeriod'{
            #This comes through as a string for some reason but should be a DWORD per https://getadmx.com/?Category=SecurityBaseline&Policy=Microsoft.Policies.MSS::Pol_MSS_ScreenSaverGracePeriod
            $regHash.ValueData = 0
            $regHash.ValueType = 'Dword'
        }
    }

    return $regHash
}