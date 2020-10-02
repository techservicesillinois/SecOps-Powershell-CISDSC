function ConvertFrom-ServiceRawGPO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Service
    )

    begin {

    }

    process {
        $serviceHash = @{
            'Name' = $Service
            'ResourceType' = 'CISService'
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