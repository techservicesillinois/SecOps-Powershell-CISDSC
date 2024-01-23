function Get-RecommendationFromGPOHash {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]$GPOHash,

        [Parameter(Mandatory = $true)]
        [ValidateSet('AuditPolicy','PrivilegeRight','Service','SystemAccess','Registry')]
        [string]$Type
    )

    begin {

    }

    process {
        switch($Type){
            'AuditPolicy'{
                [string]$CorrectionKey = $GPOHash['Subcategory']
                [string]$SearchString = "*Ensure '$($GPOHash['Subcategory'])'*'$($GPOHash['InclusionSetting'])'*"
                [scriptblock]$FilterScript = {$_.title -like $SearchString}
            }

            'PrivilegeRight'{
                [string]$CorrectionKey = $GPOHash['Policy'].replace('_',' ')
                [string]$SearchString = "*'$($CorrectionKey)'*"
                [scriptblock]$FilterScript = {$_.title -like $SearchString}
            }

            'Service'{
                [string]$CorrectionKey = $GPOHash['Name']
                [string]$SearchString = "*$($GPOHash['Name'])*"
                [scriptblock]$FilterScript = {$_.title -like $SearchString -and $_.TopLevelSection -eq $script:ServiceSection}
            }

            'SystemAccess'{
                #Wildcards are used instead of spaces because CIS puts ':' in these policy names.
                [string]$CorrectionKey = $GPOHash['Name'].replace('_','*')
                [string]$SearchString = "*'$($CorrectionKey)'*"
                [scriptblock]$FilterScript = {$_.title -like $SearchString}
            }

            'Registry'{
                # Some values in the registry policy file have a vaule of the 'nul' unicode char.
                # It must be cleaned in order to match the static corrections file.
                # If ValueName contains the char 'nul', replace it with a space and trim it.
                if($GPOHash.Get_Item('ValueName') -eq (0x00 -as [char])){
                    $GPOHash['ValueName'] = $GPOHash['ValueName'].replace((0x00 -as [char]), ' ').trim()
                }

                [string]$CorrectionKey = Get-RegKeyExpandHKLM -KeyName $GPOHash['Key'] -ValueName $GPOHash['ValueName']
                [string]$patternString = "(?i)^($($CorrectionKey))$".replace("\","\\").Replace('*','[*]')
                [scriptblock]$FilterScript = {(($_.AuditProcedure -split "`n") -match $patternString) -or (($_.RemediationProcedure -split "`n") -match $patternString)}
            }
        }

        if($script:StaticCorrections[$CorrectionKey]){
            if($script:StaticCorrections[$CorrectionKey] -eq 'ignore'){
                $Recommendation = $script:StaticCorrections[$CorrectionKey]
            }
            else{
                $Recommendation = $script:BenchmarkRecommendations.Values |
                    Where-Object -FilterScript {$_.RecommendationNum -eq $script:StaticCorrections[$CorrectionKey]}
            }
        }
        else{
            $Recommendation = $script:BenchmarkRecommendations.Values |
                Where-Object -FilterScript $FilterScript
        }

        [int]$RecommendationCount = ($Recommendation | Measure-Object).Count

        if($RecommendationCount -eq 0){
            Write-Warning -Message "Failed to find a recommendation for $($Type) $($CorrectionKey)."
            $GPOHash.add('Error','Failed to find a recommendation')
            $script:RecommendationErrors += $GPOHash
        }
        elseif($RecommendationCount -gt 1){
            Write-Warning -Message "Found multiple recommendation matches for $($Type) $($CorrectionKey)."
            $GPOHash.add('Error',"Found multiple recommendations $(($Recommendation).RecommendationNum -join ', ')")
            $script:RecommendationErrors += $GPOHash
        }
        elseif($Recommendation -eq 'ignore'){
            Write-Debug -Message "Ignoring recommendation error for $($Type) $($CorrectionKey) due to static correction."
        }
        else{
            return $Recommendation.RecommendationNum
        }
    }

    end {

    }
}
