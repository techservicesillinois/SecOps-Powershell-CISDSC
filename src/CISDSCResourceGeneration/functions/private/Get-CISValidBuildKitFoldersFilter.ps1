<#
.Synopsis
    Returns a FilterScript intended to be used by Get-ChildItem for the GPO file imports. This will filter out the MS or DC parts of the build kit when applicable.
.DESCRIPTION
    Returns a FilterScript intended to be used by Get-ChildItem for the GPO file imports. This will filter out the MS or DC parts of the build kit when applicable.
.PARAMETER System
    The operating system or software the benchmark is written for. This will determine which worksheets are valid to import.
.EXAMPLE
    Get-CISValidBuildKitFoldersFilter -System 'Microsoft Windows 10 Enterprise'
#>
function Get-CISValidBuildKitFoldersFilter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$System
    )

    begin {
    }

    process {
        switch($System){
            {$_ -like '*Member Server'}{
                $FilterScript = "*MS-*"
            }

            {$_ -like '*Domain Controller'}{
                $FilterScript = "*DC-*"
            }

            Default{
                $FilterScript = "*"
            }
        }

        return $FilterScript
    }

    end {
    }
}
