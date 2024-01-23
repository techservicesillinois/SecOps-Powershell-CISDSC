function Get-RegKeyExpandHKLM {
    param (
        [Parameter(Mandatory = $true)]
        [string]$KeyName,
        [Parameter(Mandatory = $true)]
        [string]$ValueName

    )

	return "$($KeyName -replace 'HKLM:','HKEY_LOCAL_MACHINE'):$($ValueName)"
}