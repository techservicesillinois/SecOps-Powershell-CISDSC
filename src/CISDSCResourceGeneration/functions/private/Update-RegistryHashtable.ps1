Function Update-RegistryHashtable
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        $regHash
    )

    $regHash.ValueName = $regHash.ValueName -replace "[^\u0020-\u007E]", ""

    if ([string]::IsNullOrEmpty($regHash.ValueName))
    {
        $regHash.Remove("ValueData")
    }
    $typeHash = @{"REG_SZ" = "String"; "REG_NONE" = "None"; "REG_DWORD" = "Dword"; "REG_EXPAND_SZ" = "ExpandString"; "REG_QWORD" = "Qword"; "REG_BINARY" = "Binary"; "REG_MULTI_SZ" = "MultiString"}

    if ($regHash.ValueType -in $typeHash.Keys)
    {
        $regHash.ValueType = $typeHash[$regHash.ValueType.ToString()]
    }
    else
    {
        $regHash.ValueType = "None"
    }

    if ($regHash.ContainsKey("ValueData") -and $regHash.ValueData -ne $null)
    {
        switch ($regHash.ValueType)
        {
            "String"
            {
                [string]$regHash.ValueData = "'$($regHash.ValueData)'"# -replace "[^\u0020-\u007E]", ""
            }

            "None"
            {
                $regHash.Remove("ValueData") | Out-Null
            }

            "ExpandString"
            {
                # Contains unexpanded Environment Paths. Should I expand them?
                [string]$regHash.ValueData = "'$($regHash.ValueData)'"# -replace "[^\u0020-\u007E]", ""
            }

            "Dword"
            {
                $ValueData = 1
                if ($regHash.ValueData -match "(Disabled|Enabled|Not Defined|True|False)" -or $ValueData -eq "''")
                {
                    # This is supposed to be an INT and it's a String
                    [int]$regHash.ValueData = @{"Disabled" = 0; "Enabled" = 1; "Not Defined" = 0; "True" = 1; "False" = 0; '' = 0}.$ValueData
                }
                elseif (([int]::TryParse($regHash.ValueData, [ref]$ValueData)))
                {
                    [int]$regHash.ValueData = $ValueData
                }
                else
                {
                    # If it doesn't parse as an integer, try parsing as hexadecimal.
                    Try
                    {
                        [int]$regHash.ValueData = [Convert]::ToInt32($regHash.ValueData, 16)
                    }
                    Catch
                    {
                        # Other wise fail over for now until a better option comes along.
                        $regHash.Remove("ValueData") | Out-Null
                    }
                }
            }

            "Qword"
            {

            }

            "Binary"
            {
                $reghash.ValueType = "Binary"
                if ($regHash.ContainsKey("ValueData"))
                {
                    if ($regHash.ValueData.Count -gt 1)
                    {
                        Try
                        {
                            [string]$hexified = ($regHash.ValueData | ForEach-Object ToString X2) -join ''
                            [string]$regHash.ValueData = $hexified
                        }
                        Catch
                        {
                            Write-Error "Error Processing Binary Data for Key ($(Join-Path -Path $regHash.Key -ChildPath $regHash.ValueName))"
                            $regHash.CommentOut = $true
                            Add-ProcessingHistory -Type Registry -Name "Registry(INF): $(Join-Path -Path $regHash.Key -ChildPath $regHash.ValueName)" -ParsingError
                        }
                    }
                    else
                    {
                        $regHash.ValueData = "$($regHash.ValueData)"
                    }
                }

                $regHash.ValueType = "Binary"
            }

            "MultiString"
            {
                if ($regHash.ValueData -isnot [System.Array])
                {
                     # Does this have to be done in the Calling Function instead?
                    $regHash.ValueData = @"
$($regHash.ValueData)
"@# -replace "[^\u0020-\u007E]", ""

                }

                $reghash.ValueType = "MultiString"
            }

            Default { $regHash.ValueType = "None" }
        }
    }

    if ($regHash.ValueType -eq "None")
    {
        # The REG_NONE is not allowed by the Registry resource.
        $regHash.Remove("ValueType")
    }

    if ([string]::IsNullOrEmpty($regHash.ValueName))
    {
        $regHash.Remove("ValueData")
    }

    Resolve-RegistrySpecialCases $reghash
}