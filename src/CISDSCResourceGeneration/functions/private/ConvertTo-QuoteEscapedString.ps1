function ConvertTo-QuoteEscapedString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$String,

        [Parameter(Mandatory=$True)]
        [ValidateSet('Single','Double')]
        [string]$Quote
    )

    begin {

    }

    process {
        if($Quote -eq 'Single'){
            $String = $String.Replace("'","''")
        }
        elseif($Quote -eq 'Double'){
            $String = $String.Replace('"','''"')
        }

        $String
    }

    end {

    }
}