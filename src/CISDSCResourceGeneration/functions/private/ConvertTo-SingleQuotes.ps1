function ConvertTo-SingleQuotes{
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
        ($String.Replace('"',"'"))
    }
    End
    {
    }
}