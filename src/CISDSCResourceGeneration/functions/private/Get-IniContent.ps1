<#
.Synopsis
   Converts provided CIS benchmark materials and converts them to a DSC composite resource.
.DESCRIPTION
   Converts the contents of an ini/inf file into hashtables.
.PARAMETER Path
    Path to the ini/inf file. Intended for use with a group policy object's GptTmpl.inf
.EXAMPLE
    Get-IniContent -Path '.\DC-L1\{27E69C52-5FFB-4B78-87A4-DB1B2D927DBC}\DomainSysvol\GPO\Machine\microsoft\windows nt\SecEdit\GptTmpl.inf'
#>
function Get-IniContent
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]$Path
    )

    $ini = @{}
    switch -regex -file $Path{
        # Section
        "^\[(.+)\]"{
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }
        # Comment
        "^(;.*)$"{
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            $ini[$section][$name] = $value.Trim()
            continue
        }
        # Key
        "(.+)\s*=(.*)"{
            $name,$value = $matches[1..2]
            $ini[$section][$name.Trim()] = $value.Trim()
            # Need to replace double quotes with `"
            continue
        }
        "\`"(.*)`",(.*)$"{
            $name, $value = $matches[1..2]
            $ini[$section][$name.Trim()] = $value.Trim()
            continue
        }
    }
    return $ini
}
