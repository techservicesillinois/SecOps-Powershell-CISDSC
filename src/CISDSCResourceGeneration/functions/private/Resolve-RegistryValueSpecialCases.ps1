Function Resolve-RegistryValueSpecialCases
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        $regHash
    )

    # Special Cases.
    switch -regex ((Join-Path -Path $regHash['Key'] -ChildPath $regHash.ValueName)){
        "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\\LegalNoticeText"{
            #Special case LegalNoticeText, written as a REG_MULTI_SZ by Group Policy Editor but written to registry as REG_SZ
            #Replacing comma with LF (line feed) and CR (Carriage Return)
            $regHash.ValueData = '"ADD TEXT HERE"'
            #Change the type to REG_SZ
            $regHash.ValueType = '1'
        }

        "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\PauseFeatureUpdatesStartTime"{
            #There is an encoding error on registry.pol that makes this a mystery character instead of the intended '0'.
            $regHash.ValueData = "'0'"
        }

        "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\PauseQualityUpdatesStartTime"{
            #There is an encoding error on registry.pol that makes this a mystery character instead of the intended '0'.
            $regHash.ValueData = "'0'"
        }

        "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\ScreenSaverGracePeriod"{
            #This comes through as a string for some reason but should be a DWORD per https://getadmx.com/?Category=SecurityBaseline&Policy=Microsoft.Policies.MSS::Pol_MSS_ScreenSaverGracePeriod
            $regHash.ValueData = 0
            $regHash.ValueType = '4'
        }
    }
}