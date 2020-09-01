function ConvertFrom-ServiceRawGPO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Service,

        [Parameter(Mandatory = $true)]
        [string]$ServiceData
    )

    begin {

    }

    process {
        $serviceHash = @{
            'Name' = $Service
            'ResourceType' = 'Service'
        }

        switch (($ServiceData -split ',')[0]){
            '2' {$serviceHash.Add('State',"'Running'")}
            '3' {$serviceHash.Add('StartupType',"'Manual'")}
            '4' {$serviceHash.Add('State',"'Stopped'")}
            Default {Write-Warning -Message "Invalid ServiceData of $($values[0])) for $($Service)"}
        }

        $RecommendationNum = Get-RecommendationFromGPOHash -GPOHash $serviceHash -Type 'Service'

        $serviceHash['Name'] = "'$($serviceHash['Name'])'"

        if($RecommendationNum){
            $script:BenchmarkRecommendations["$RecommendationNum"].ResourceParameters += $serviceHash
        }
    }

    end {

    }
}