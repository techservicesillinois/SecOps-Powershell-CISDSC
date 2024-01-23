function Get-RegPatternString {
	param(
        [Parameter(Mandatory = $true)]
        [string]$CorrectionKey
	)

 [string]$patternString = "(?i)^($($CorrectionKey))$".replace("\","\\").Replace('*','[*]')
 return $patternString
}