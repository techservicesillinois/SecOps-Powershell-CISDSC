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
            'more than',

            #These Recommendations will always need parameterized input, but do not match the key phrases above
            "Configure 'Interactive logon: Message text for users attempting to log on'",
            "Configure 'Interactive logon: Message title for users attempting to log on'",
            "Configure 'Accounts: Rename administrator account'",
            "Configure 'Accounts: Rename guest account'"

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