# shamelessly stolen from https://vinojose.wordpress.com/2016/07/19/how-to-use-pester-for-unit-testing-of-class-based-dsc-custom-resource/
# black magic that lets you test class based resources inside pester
function New-PSClassInstance
{
    param(
        [Parameter(Mandatory)]
        [String]$TypeName,
        [object[]]$ArgumentList = $null
    )

    $ts = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -eq $null | Foreach-Object -Process {
        $_.Gettypes()
    } | Where-Object name -eq $TypeName | Select-Object -Last 1
    
    if($ts) {
        [System.Activator]::CreateInstance($ts,$ArgumentList )
    }
    else {
        $typeException = New-Object TypeLoadException $TypeName
        $typeException.Data.Add("ArgumentList",$ArgumentList)
        throw $typeException
    }
}