function Get-RecommendationCustomizability{
    [CmdletBinding()]
    [OutputType([Boolean])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Title
    )

    Begin
    {
    }
    Process
    {
        $Phrases = @(
            'or more',
            'or fewer',
            'or greater',
            'or less'
            'less than',
            'greater than',
            'fewer than',
            'more than'
        )
        foreach($Phrase in $Phrases){
            if($Title -like "*$Phrase*"){
                return $true
            }
        }
        return $false
    }
    End
    {
    }
}