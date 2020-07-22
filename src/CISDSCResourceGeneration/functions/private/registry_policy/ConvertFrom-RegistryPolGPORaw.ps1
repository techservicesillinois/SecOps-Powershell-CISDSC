function ConvertFrom-RegistryPolGPORaw {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$Policy
    )

    begin {

    }

    process {
        $regHash = @{
            'Key' = "HKLM:\$($Policy.KeyName)"
            'ValueName' = $Policy.ValueName
            'ValueType' = $script:RegistryDataType[$Policy.ValueType.ToString()]
            'Ensure' = "'Present'"
            'ValueData' = $Policy.ValueData
        }

        if($regHash['ValueName'].StartsWith('**del.')){
            $regHash['Ensure'] = "'Absent'"
            $regHash['ValueName'] = ($regHash['ValueName'] -split 'del.')[1]
            $regHash.Remove('ValueData')
            $regHash.Remove('ValueType')
        }
        elseif($regHash['ValueName'] -eq '**delvals.'){
            $regHash['Ensure'] = "'Absent'"
            $regHash['ValueName'] = ''
            $regHash.Remove('ValueData')
            $regHash.Remove('ValueType')
        }

        $Reccomendation = Get-RegistryValueReccomendation -regHash $regHash

        if($regHash['ValueType'] -in ('ExpandString','String') -and $regHash['ValueData']){
            $regHash['ValueData'] = "'$($regHash['ValueData'])'"
        }

        if($regHash['ValueType']){
            $regHash['ValueType'] = "'$($regHash['ValueType'])'"
        }

        $regHash['key'] = "'$($regHash['key'])'"
        $regHash['ValueName'] = "'$($regHash['ValueName'])'"

        [ScaffoldingBlock]::new($Reccomendation,'Registry',$reghash)
    }

    end {

    }
}