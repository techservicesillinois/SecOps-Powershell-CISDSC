Import-Module '.\src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1' -Force
$Splat = @{
    BenchmarkPath = 'C:\temp\cis\CIS_Microsoft_Windows_Server_2022_Benchmark_v1.0.0.xlsx'
    BenchmarkVersion = '1.0.0'
    GPOPath = 'C:\temp\cis\Server2022v1.0.0'
    OutputPath = '.\src\CISDSC\dscresources'
    StaticCorrectionsPath = '.\csvs\static_corrections\Server2022_21H2_corrections.csv'
    ParameterValidationsPath = '.\csvs\parameter_validations\Server2022_21H2_validations.csv'
    ParameterOverridesPath = '.\csvs\parameter_overrides\Server2022_21H2_overrides.csv'
    OS = 'Microsoft Windows Server 2022 Member Server'
    OSBuild = '21H2'
}
ConvertTo-DSC @Splat
