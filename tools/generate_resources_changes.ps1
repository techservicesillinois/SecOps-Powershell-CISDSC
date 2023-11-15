Import-Module '..\src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1' -Force
Remove-Item -Path '.\output' -Recurse -Force -ErrorAction 'SilentlyContinue'

$Splat = @{
    BenchmarkPath    = "C:\Users\asvalent\Downloads\CIS_Microsoft_Windows_11_Enterprise_Benchmark_v2.0.0.xlsx"
    BenchmarkVersion = '2.0.0'
    GPOPath          = 'C:\Users\asvalent\Downloads\Windows11v2.0.0'
    OutputPath       = 'C:\Users\asvalent\repo\SecOps-Powershell-CISDSC\src\CISDSC\dscresources'
    StaticCorrectionsPath    = 'C:\Users\asvalent\repo\SecOps-Powershell-CISDSC\csvs\static_corrections\Win11_23H2_corrections.csv'
    ParameterValidationsPath = 'C:\Users\asvalent\repo\SecOps-Powershell-CISDSC\csvs\parameter_validations\Win11_23H2_validations.csv'
    ParameterOverridesPath   = 'C:\Users\asvalent\repo\SecOps-Powershell-CISDSC\csvs\parameter_overrides\Win11_23H2_overrides.csv'

    # uncomment which is applicable

    OS               = 'Microsoft Windows 11 Enterprise'
    OSBuild          = '23H2'

    #Browser = 'Microsoft Edge'
}
ConvertTo-DSC @Splat -verbose
