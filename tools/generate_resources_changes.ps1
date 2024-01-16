Import-Module '.\src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1' -Force
Remove-Item -Path '.\output' -Recurse -Force -ErrorAction 'SilentlyContinue'

# Linux
# $files_root = '\home\delaport\win11'
# $repo_path = '\home\delaport\src\SecOps-Powershell-CISDSC'

# Windows
$files_root = 'C:\Users\delaport\src\SecOps-Powershell-CISDSC\cis_files'
$repo_path = 'C:\Users\delaport\src\SecOps-Powershell-CISDSC'

$Splat = @{
    BenchmarkPath    = "$files_root\CIS_Microsoft_Windows_11_Enterprise_Benchmark_v2.0.0.xlsx"
    BenchmarkVersion = '2.0.0'
    GPOPath          = "$files_root\Windows11v2.0.0"
    OutputPath       = "$repo_path\src\CISDSC\dscresources"
    StaticCorrectionsPath    = "$repo_path\csvs\static_corrections\Win11_23H2_corrections.csv"
    ParameterValidationsPath = "$repo_path\csvs\parameter_validations\Win11_23H2_validations.csv"
    ParameterOverridesPath   = "$repo_path\csvs\parameter_overrides\Win11_23H2_overrides.csv"

    # uncomment which is applicable

    OS               = 'Microsoft Windows 11 Enterprise'
    OSBuild          = '23H2'

    #Browser = 'Microsoft Edge'
}
ConvertTo-DSC @Splat -verbose
