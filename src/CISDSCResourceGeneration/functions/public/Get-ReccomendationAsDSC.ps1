function Get-ReccomendationAsDSC {
    [CmdletBinding()]
    param (
        [System.Collections.Hashtable]$DSCHash
    )

    begin {

    }

    process {
        [string[]]$DSCBlock = @()

        [string]$IfClose = [string]::Empty
        if($DSCHash['Reccomendation'].Level){
            $IfClose = ' -and ${0})' -f $DSCHash['Reccomendation'].Level
        }
        $IfClose += '{'

        switch($DSCHash['DSCResourceType']){
            'Registry' {
                if($DSCHash['DSCParameters']['ValueData'] -in ($null,[string]::Empty)){
                    $DSCHash['DSCParameters']['ValueData'] = switch($DSCHash['DSCParameters']['ValueType']){
                        'MultiString' {"@('')"}
                        Default {"''"}
                    }
                }
            }
        }

        $DSCBlock += 'if($ExcludeList -notcontains ''{0}''{1}' -f $DSCHash['Reccomendation'].'recommendation #',$IfClose
        $DSCBlock += "    $($DSCHash['DSCResourceType']) '$(ConvertTo-QuoteEscapedString -String $DSCHash['Reccomendation'].title -Quote Single)'{"
        foreach($Key in $DSCHash['DSCParameters'].Keys){
            $DSCBlock += "        $Key = $($DSCHash['DSCParameters'][$Key])"
        }
        $DSCBlock += "    }"
        $DSCBlock += "}"

        $DSCBlock -join "`n"
    }

    end {

    }
}