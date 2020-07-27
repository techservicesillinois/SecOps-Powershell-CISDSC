function Format-ReccomendationTitle{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$String
    )

    Begin
    {
    }
    Process
    {
        $String -replace "[^a-zA-Z0-9() ]",""
    }
    End
    {
    }
}