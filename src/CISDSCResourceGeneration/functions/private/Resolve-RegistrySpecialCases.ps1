Function Resolve-RegistrySpecialCases
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        $regHash
    )

    # Special Cases.
    switch -regex ((Join-Path -Path $regHash.Key -ChildPath $regHash.ValueName))
    {
        "HKLM:\\System\\CurrentControlSet\\Control\\SecurePipeServers\\Winreg\\(AllowedExactPaths|AllowedPaths)\\Machine"
        {
            # $regHash.ValueData = $regHash.ValueData -split ","
        }

        "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\\LegalNoticeText"
        {
            #Special case LegalNoticeText, written as a REG_MULTI_SZ by Group Policy Editor but written to registry as REG_SZ
            #Replacing comma with LF (line feed) and CR (Carriage Return)
            $values = $regHash.ValueData -split ","
            $regHash.ValueData = ""
            $values[0..($values.count-2)] | ForEach-Object{$regHash.ValueData += $_ +"`r`n"}
            $regHash.ValueData += $values[($values.count-1)]
            #Change the type to REG_SZ
            $regHash.ValueType = "String"
        }

    }
}