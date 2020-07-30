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
        }

        $Recommendation = Get-RecommendationFromGPOHash -GPOHash $privilegeHash -Type 'PrivilegeRight'

        $privilegeHash['Policy'] = "'$($privilegeHash['Policy'])'"
        $privilegeHash['Identity'] = "@('$($privilegeHash['Identity'] -join "','")')"

        return [ScaffoldingBlock]::new($Recommendation,'UserRightsAssignment',$privilegeHash)
    }

    end {

    }
}