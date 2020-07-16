function ConvertTo-QuoteEscapedString {
    [CmdletBinding()]
    param (
        [string]$String,

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