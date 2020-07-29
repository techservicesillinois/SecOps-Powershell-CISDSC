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
