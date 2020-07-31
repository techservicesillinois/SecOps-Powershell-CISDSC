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
    }
}