Function Resolve-RegistryValueSpecialCases
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns',
            Justification = 'This always deals with multiples')]
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
            #There is conflicting documentation on this keys value type but more sources say string and that's what CIS-CAT looks for as well.
            #The buildkit sets this to 5 but the title recommends 0 so the value is overridden.
            $regHash.ValueData = '0'
            $regHash.ValueType = 'String'
        }

        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText'{
            #This value is set as a multi string value but needs to be a standard string.
            $regHash.ValueData = '"ADD TEXT HERE"'
            $regHash.ValueType = '1'
        }
    }

    return $regHash
}
