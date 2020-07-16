function ConvertTo-Version {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$CISNumberString
    )

    begin {

    }

    process {
        function Get-DotCount([string]$String){
            ($string.length - $string.replace('.','').length)
        }

        [string]$VerString = $CISNumberString
        [int]$Dotcount = Get-DotCount -String $VerString

        if($Dotcount -eq 0){
            $VerString = "$($VerString).0"
        }
        elseif($Dotcount -ge 4) {
            do{
                $VerString = $VerString.Remove($VerString.LastIndexOf('.'),1)
            }
            until((Get-DotCount -String $VerString) -eq 3)
        }

        [version]$VerString
    }

    end {

    }
}