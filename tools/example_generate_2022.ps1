# . $args[0]
Import-Module '.\src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1' -Force
$Splat = @{
    BenchmarkPath = 'C:\temp\cis\CIS_Microsoft_Windows_Server_2022_Benchmark_v1.0.0.xlsx'
    BenchmarkVersion = '1.0.0'
    GPOPath = 'C:\temp\cis\Server2022v1.0.0'
    OutputPath = '.\src\CISDSC\dscresources'
    StaticCorrectionsPath = '.\csvs\static_corrections\Server2022_MysteryBuild_corrections_draft.csv'
    ParameterValidationsPath = '.\csvs\parameter_validations\TacoSalad.csv'
    ParameterOverridesPath = '.\csvs\parameter_overrides\TacoSalad.csv'
    OS = 'Microsoft Windows Server 2022 Member Server'
    OSBuild = 'TacoSalad'
}
ConvertTo-DSC @Splat