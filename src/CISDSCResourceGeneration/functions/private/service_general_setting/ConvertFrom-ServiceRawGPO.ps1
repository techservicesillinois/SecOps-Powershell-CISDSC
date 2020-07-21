function ConvertFrom-ServiceRawGPO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Service,

        [Parameter(Mandatory = $true)]
        [string]$ServiceData
    )

    begin {

    }

    process {
        $serviceHash = @{
            'Name' = $Service
        }

        switch (($ServiceData -split ',')[0]){
            '2' {$serviceHash.Add('State',"'Running'")}
            '3' {$serviceHash.Add('StartupType',"'Manual'")}
            '4' {$serviceHash.Add('State',"'Stopped'")}
            Default {Write-Warning -Message "Invalid ServiceData of $($values[0])) for $($Service)"}
        }

        $Reccomendation = Get-ServiceReccomendation -serviceHash $serviceHash

        $serviceHash['Name'] = "'$($serviceHash['Name'])'"

        [ScaffoldingBlock]::new($Reccomendation,'Service',$serviceHash)
    }

    end {

    }
}