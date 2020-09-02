Function ConvertFrom-RegistryValueRawGPO {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ValueData
    )

    $ValueName = Split-Path -Leaf $Key

    $regHash = @{
        'ValueType' = 'None'
        'ValueName' = $ValueName -replace "[^\u0020-\u007E]", ''
        'ValueData' = ''
        'Key' = "$(Split-Path -Parent $Key)" -replace "MACHINE\\", "HKLM:\"
        'ResourceType' = 'Registry'
    }

    if ([string]::IsNullOrEmpty($regHash.ValueName)){
        $regHash.Remove("ValueData")
    }
    else{
        try{
            if($ValueData -match "^(\d),"){
                $regHash['ValueType'] = $Matches.1
                $values = ($ValueData -split "^\d,")[1]
                $values = $values -replace '","', '&,'
                $values = $values -split '(?=[^&]),'

                for ($i = 0; $i -lt $values.count;$i++){
                    $values[$i] = $values[$i] -replace '&,', ","
                }

                $regHash.ValueData = $values
            }
            else{
                throw "Malformed data"
            }
        }
        catch{
            $regHash.ValueData = $null
            continue
        }
    }

    switch($regHash['ValueType']){
        '1' {
            $regHash['ValueType'] = "'String'"
        }
        '3' {
            $regHash['ValueType'] = "'Binary'"

            if ($regHash.ContainsKey("ValueData")){
                if ($regHash['ValueData'].Count -gt 1){
                    Try{
                        $regHash['ValueData'] = [string]($regHash.ValueData | ForEach-Object ToString X2) -join ''
                    }
                    Catch{
                        Write-Error "Error Processing Binary Data for Key ($(Join-Path -Path $regHash.Key -ChildPath $regHash.ValueName))"
                    }
                }
                else{
                    $regHash.ValueData = "$($regHash.ValueData)"
                }
            }
        }
        '4' {
            $regHash['ValueType'] = "'Dword'"

            $ValueData = 1
            if ($regHash['ValueData'] -match "(Disabled|Enabled|Not Defined|True|False)" -or $ValueData -eq "''"){
                # This is supposed to be an INT and it's a String
                [int]$regHash['ValueData'] = @{"Disabled" = 0; "Enabled" = 1; "Not Defined" = 0; "True" = 1; "False" = 0; '' = 0}.$ValueData
            }
            elseif (([int]::TryParse($regHash['ValueData'], [ref]$ValueData))){
                [int]$regHash['ValueData'] = $ValueData
            }
            else{
                # If it doesn't parse as an integer, try parsing as hexadecimal.
                Try{
                    [int]$regHash['ValueData'] = [Convert]::ToInt32($regHash['ValueData'], 16)
                }
                Catch{
                    # Other wise fail over for now until a better option comes along.
                    $regHash.Remove("ValueData") | Out-Null
                }
            }
        }
        '7' {
            $regHash['ValueType'] = "'MultiString'"
            $regHash['ValueData'] = "@('$($regHash['ValueData'] -join "','")')"

        }
        default {
            $regHash.Remove("ValueType")
        }
    }

    $RecommendationNum = Get-RecommendationFromGPOHash -GPOHash $regHash -Type 'Registry'

    $regHash['Key'] = "'$($regHash['Key'])'"
    $regHash['ValueName'] = "'$($regHash['ValueName'])'"

    if($RecommendationNum){
        $script:BenchmarkRecommendations["$RecommendationNum"].ResourceParameters += $regHash
    }
}