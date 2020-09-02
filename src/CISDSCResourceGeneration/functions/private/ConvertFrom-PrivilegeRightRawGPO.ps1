function ConvertFrom-PrivilegeRightRawGPO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Policy,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Identity
    )

    begin {

    }

    process {
        $privilegeHash = @{
            'Policy' = $script:UserRights[$Policy]
            'Identity' = ($Identity -split ',')
            'Force' = '$true'
            'ResourceType' = 'UserRightsAssignment'
        }

        $RecommendationNum = Get-RecommendationFromGPOHash -GPOHash $privilegeHash -Type 'PrivilegeRight'

        $privilegeHash['Policy'] = "'$($privilegeHash['Policy'])'"
        $privilegeHash['Identity'] = "@('$($privilegeHash['Identity'] -join "','")')"

        if($RecommendationNum){
            $script:BenchmarkRecommendations["$RecommendationNum"].ResourceParameters += $privilegeHash
        }
    }

    end {

    }
}