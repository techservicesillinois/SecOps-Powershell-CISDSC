function ConvertFrom-SystemAccessRawGPO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [string]$SecurityData
    )

    begin {

    }

    process {
        $SecurityData = $SecurityData.trim()

        if($script:SecurityOptionSettings.ContainsKey($Key)){
            $SecuritySetting = $script:SecurityOptionSettings[$key]
            $ResourceName = "SecurityOption"
        }
        elseif($script:AccountPolicySettings.ContainsKey($Key)){
            $SecuritySetting = $script:AccountPolicySettings[$key]
            $ResourceName = "AccountPolicy"
        }

        if(!($SecuritySetting)){
            Write-Error "$($key) key missing from SecurityOptionSettings or AccountPolicySettings dictionary in CISDSCResourceGeneration.psm1"
        }

        [int]$ValueData = 1
        if (![int]::TryParse($SecurityData, [ref]$ValueData)){
            [string]$ValueData = $SecurityData
        }
        elseif ($ValueData -eq -1){
            Write-Warning "$($Key) is set to -1 which means 'Not Configured'"
        }
        else{
            if ($SecuritySetting -in $script:SecuritySettingsWEnabledDisabled){
                [string]$ValueData = "'$($script:EnabledDisabled[$ValueData])'"
            }
        }

        $SystemAccessHash = @{
            'Name' = $SecuritySetting
            $SecuritySetting = $ValueData
            'ResourceType' = $ResourceName
        }

        $RecommendationNum = Get-RecommendationFromGPOHash -GPOHash $SystemAccessHash -Type 'SystemAccess'

        $SystemAccessHash['Name'] = "'$($SystemAccessHash['Name'])'"

        if($RecommendationNum){
            $script:BenchmarkRecommendations["$RecommendationNum"].ResourceParameters += $SystemAccessHash
        }
    }

    end {

    }
}