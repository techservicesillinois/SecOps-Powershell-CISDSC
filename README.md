![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/ScriptAnalyzer/badge.svg)

# What is This?
This project is designed to deliver [CIS](https://www.cisecurity.org/) security benchmarks via PowerShell DSC. It is a heavily modified fork of [Microsoft's BaselineManagement](BaselineManagement) module.

# How do I install it?
The actual DSC resources should be installed via the CISDSC PSgallery page which doesn't exist yet.

The required dev dependencies for developing resources can be install via the following PS with your working directory set to this cloned repository. These packages can be reviewed in the [build file](build.depend.psd1).
```
Install-Module -Name 'PSDepend'
Invoke-PSDepend -Force
```

# How do I help?

[Static corrections](docs/static_corrections.md)

The main form of contribution will be adding benchmarks for new OS/builds. The benchmarks are available via the [CIS workbench](https://workbench.cisecurity.org/) and require a free account to access. You will need the excel copy of the benchmarks and the build kit (GPOs) for most cases.

The [CISDSCResourceGeneration](/src/CISDSCResourceGeneration) module only available in this repository is designed to do the majority of the DSC generation as it's name implies. This module only works with Windows PowerShell 5.1 due to a dependency on [GPRegistryPolicyParser](https://www.powershellgallery.com/packages/GPRegistryPolicyParser). It appears as though PS 7 support is being worked on though.

Your composite resource version should match the version of the benchmark to easily correlate what it was based on. Ex: The current benchmark for Windows 10 Enterprise 1909 is v1.8.1 since these are versioned as they are revisited by CIS them with new recommendations.

Once you have the Excel documentation and the applicable build kit below is an example of how to generate the start of a composite resource. The build kits will need to be extracted as CIS provides them in .zip format.

Member Server and Domain Controller benchmarks are created into separate resources. Due to this some files need removed from the remediation kit directory after its extracted. For member servers remove the 'DC-L1' and 'DC-L2' and for domain controllers remove 'MS-L1' and 'MS-L2'.

```
Import-Module .\src\CISDSCResourceGeneration\CISDSCResourceGeneration.psd1 -Force
$Splat = @{
    BenchmarkPath = '.\CIS_Microsoft_Windows_Server_2016_RTM_Release_1607_Benchmark_v1.2.0.xlsx'
    BenchmarkVersion = 1.2.0
    GPOPath = '.\Server2016v1.2.0'
    OutputPath = '.\CISDSC\dscresources'
    StaticCorrectionsPath = '.\static_corrections.csv'
    OS = 'Microsoft Windows Server 2016 Member Server'
    OSBuild = '1607'
}
ConvertTo-DSC @Splat
```

Successfully generated resources will be placed into the generated composite resource however some settings have been known to link between the build kit and Excel document cleanly. This can be due to any number of things including: Human error, outdated registry/policy name in one or the other, mismatched values in GPO vs the excel document.

User settings (typically section 19 of the documentation) are purposely excluded from the generated DSC because DSC cannot be used to configure the HKCU registry hive.

# To Do