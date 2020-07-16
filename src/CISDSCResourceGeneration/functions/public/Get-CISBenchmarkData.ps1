function Get-CISBenchmarkData {
    [CmdletBinding()]
    param (
        [switch]$Sections
    )

    begin {

    }

    process {
        if($Sections){
            $script:BenchmarkSections
        }
        else{
            $script:BenchmarkReccomendations
        }
    }

    end {

    }
}