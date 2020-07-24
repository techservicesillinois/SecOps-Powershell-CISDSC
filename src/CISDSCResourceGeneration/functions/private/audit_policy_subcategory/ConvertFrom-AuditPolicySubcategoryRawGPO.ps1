function ConvertFrom-AuditPolicySubcategoryRawGPO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Object]$Entry
    )

    begin {

    }

    process {
        $GUID = $Entry.'Subcategory GUID'.TrimStart('{').TrimEnd('}')

        if (!$script:AuditSubcategory.ContainsKey($GUID)){
            Write-Warning -Message "ConvertFrom-AuditPolicySubcategoryRawGPO:$GUID ($($Entry.Subcategory)) is no longer supported or not implemented"
        }
        else{
            $retHash = @{
                'Name' = "'$($script:AuditSubcategory[$GUID])'"
                'Ensure' = [string]::Empty
                'AuditFlag' = [string]::Empty
            }

            switch -regex ($Entry.'Inclusion Setting'){
                'Success and Failure'{
                    $retHash['Ensure'] = "'Present'"
                    $duplicate = $retHash.Clone()
                    $retHash['AuditFlag'] = "'Success'"
                    $duplicate['AuditFlag'] = "'Failure'"
                }

                'No Auditing'{
                    $retHash['Ensure'] = "'Absent'"
                    $duplicate = $retHash.Clone()
                    $retHash['AuditFlag'] = "'Success'"
                    $duplicate['AuditFlag'] = "'Failure'"
                    $retHash['AuditFlag'] = "'Failure'"
                }

                '^Success$'{
                    $retHash['Ensure'] = "'Present'"
                    $duplicate = $retHash.Clone()
                    $retHash['AuditFlag'] = "'Success'"
                    $duplicate['AuditFlag'] = "'Failure'"
                    $duplicate['Ensure'] = "'Absent'"
                }

                '^Failure$'{
                    $retHash['Ensure'] = "'Present'"
                    $duplicate = $retHash.Clone()
                    $retHash['AuditFlag'] = "'Failure'"
                    $duplicate['AuditFlag'] = "'Success'"
                    $duplicate['Ensure'] = "'Absent'"
                }
            }

            $Recommendation = Get-AuditPolicySubcategoryRecommendation -Subcategory $Entry.Subcategory -InclusionSetting $Entry.'Inclusion Setting'

            [ScaffoldingBlock]::new($Recommendation,'AuditPolicySubcategory',$retHash)
            [ScaffoldingBlock]::new($Recommendation,'AuditPolicySubcategory',$duplicate)
        }
    }

    end {

    }
}