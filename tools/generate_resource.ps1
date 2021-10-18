Import-Module '..\src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1' -Force
Remove-Item -Path '.\output' -Recurse -Force -ErrorAction 'SilentlyContinue'

$Splat = @{
    BenchmarkPath    = ".\*_Benchmark_v*.xlsx"
    BenchmarkVersion = '0.0.0'
    GPOPath          = ''
    OutputPath       = '.\output'
    StaticCorrectionsPath    = '..\CSVS\static_corrections\<replace me>_corrections.csv'
    ParameterValidationsPath = '..\CSVS\parameter_validations\<replace me>_validations.csv'
    ParameterOverridesPath   = '..\CSVS\parameter_overrides\<replace me>_overrides.csv'

    # uncomment which is applicable

    #OS               = 'Microsoft Windows Server 2019 Domain Controller'
    #OSBuild          = '20H2'

    #Browser = 'Microsoft Edge'
}
ConvertTo-DSC @Splat -verbose
