Function Get-GPORegistryINFData
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ValueData
    )

    $regHash = @{}
    $regHash.ValueType = "None"
    $regHash.ValueName = ""
    $regHash.ValueData = ""
    $regHash.Key = ""

    $CommentOUT = $false

    Try
    {
        if ($ValueData -match "^(\d),")
        {
            $valueType = $Matches.1
            $values = ($ValueData -split "^\d,")[1]
            $values = $values -replace '","', '&,'
            $values = $values -split '(?=[^&]),'
            for ($i = 0; $i -lt $values.count;$i++)
            {
                $values[$i] = $values[$i] -replace '&,', ","
            }

            $regHash.ValueData = $values
        }
        else
        {
            throw "Malformed data"
        }
    }
    catch
    {
        $regHash.ValueData = $null
        continue
    }

    $KeyPath = $Key

    $ValueName = Split-Path -Leaf $KeyPath
    $regHash.ValueName = $ValueName -replace "[^\u0020-\u007E]", ""
    $regHash.Key = Split-Path -Parent $KeyPath
    $regHash.Key = $regHash.Key -replace "MACHINE\\", "HKLM:\"
    if (!$regHash.Key.StartsWith("HKLM"))
    {
        Write-Warning "Write-GPORegistryINFData: Current User Registry settings are not yet supported."
        $CommentOUT = $true
    }

    $typeHash = @{"1" = "REG_SZ"; "7" = "REG_MULTI_SZ"; "4" = "REG_DWORD"; "3" = "REG_BINARY"}
    if ($typeHash.ContainsKey($valueType))
    {
        $regHash.ValueType = $typeHash[$valueType]
    }
    else
    {
        Write-Warning "Write-GPORegistryINFData: $($values[0]) ValueType is not yet supported"
        # Add this resource to the processing history.
        #Add-ProcessingHistory -Type Registry -Name "Registry(INF): $(Join-Path -Path $regHash.Key -ChildPath $regHash.ValueName)" -ParsingError
        $CommentOUT = $true
    }

    Update-RegistryHashtable $regHash
    if ($regHash.ContainsKey("CommentOut"))
    {
        $CommentOUT = $true
        $regHash.Remove("CommentOut")
    }

    $regHash
}