function ConvertFrom-RegistryPolGPORaw {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$KeyName,

        [Parameter(Mandatory = $true)]
        [string]$ValueName,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$ValueData,

        [Parameter(Mandatory = $true)]
        [string]$ValueType
    )

    begin {

    }

    process {
        $regHash = @{
            'Key' = "HKLM:\$($KeyName)"
            'ValueName' = $ValueName
            'ValueType' = $script:RegistryDataType[$ValueType.ToString()]
            'Ensure' = "'Present'"
            'ValueData' = $ValueData
            'ResourceType' = 'Registry'
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

        $regHash = Resolve-RegistryValueSpecialCases -regHash $regHash
        $RecommendationNum = Get-RecommendationFromGPOHash -GPOHash $regHash -Type 'Registry'

        if($regHash['ValueType'] -in ('ExpandString','String') -and $regHash['ValueData']){
            $regHash['ValueData'] = "'$($regHash['ValueData'])'"
        }

        if($regHash['ValueType']){
            $regHash['ValueType'] = "'$($regHash['ValueType'])'"
        }

        $regHash['key'] = "'$($regHash['key'])'"
        $regHash['ValueName'] = "'$($regHash['ValueName'])'"

        if($RecommendationNum){
            $script:BenchmarkRecommendations["$RecommendationNum"].ResourceParameters += $regHash
        }
    }

    end {

    }
}