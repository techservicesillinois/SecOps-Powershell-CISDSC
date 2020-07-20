function ConvertTo-SingleQuotes
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,Position=0)]
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