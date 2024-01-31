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
        if(!($script:UserRights.ContainsKey($Policy))){
            Write-Error "$($Policy) key missing from UserRights dictionary in CISDSCResourceGeneration.psm1"
        }

        [string[]]$SortedIdentity = ($Identity -split ',') | Sort-Object
        $privilegeHash = @{
            'Policy' = $script:UserRights[$Policy]
            # The sort-object ensures consistent ordering of SIDs for the same settings accross resources to make comparisons easier.
            'Identity' = $SortedIdentity
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