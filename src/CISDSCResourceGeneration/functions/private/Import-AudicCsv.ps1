<#
.Synopsis
    Recursively finds all 'Audit.csv' files in the provided directory that contain audit policy definitions. Definitions are returned as [ScaffoldingBlock] objects.
    Ex:
    Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting,Setting Value
    ,System,Audit Credential Validation,{0cce923f-69ae-11d9-bed3-505054503030},Success and Failure,,3
.DESCRIPTION
    Recursively finds all 'Audit.csv' files in the provided directory. These contain audit policy definitions.
    Ex:
    Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting,Setting Value
    ,System,Audit Credential Validation,{0cce923f-69ae-11d9-bed3-505054503030},Success and Failure,,3
.PARAMETER GPOPath
    Path to the GPO files (build kit) from CIS containing the benchmarks settings.
.EXAMPLE
#>
function Import-AudicCsv {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$GPOPath,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$System
    )

    begin {
    }

    process {
        Get-ChildItem -Path $GPOPath -Filter 'Audit.csv' -Recurse | Where-Object -FilterScript {$_.FullName -like (Get-CISValidBuildKitFoldersFilter -System $System)} | ForEach-Object -Process {
            Write-Verbose -Message "Importing $($_.FullName)"
            $CSV = Import-CSV -Path $_.FullName

            foreach($Row in $CSV){
                switch ($Row){
                    {!([string]::IsNullOrEmpty($Row.'Subcategory GUID'))} {ConvertFrom-AuditPolicySubcategoryRawGPO -SubcategoryGUID $Row.'Subcategory GUID' -Subcategory $Row.Subcategory -InclusionSetting $Row.'Inclusion Setting'}
                    Default {Write-Warning -Message "Audit: $($CSV.SubCategory) is not currently supported"}
                }
            }
        }
    }

    end {
    }
}
