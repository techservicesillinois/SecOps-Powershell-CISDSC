![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/ScriptAnalyzer/badge.svg)

# What is This?

# How do I install it?

# How does it work?

# How do I help?
The main form of contribution will be adding benchmarks for new OS/builds. The benchmarks are available via the [CIS workbench](https://workbench.cisecurity.org/) and require a free account to access. You will need the excel copy of the benchmarks.

Benchmarks are added in the form of composite resources. There is a Plaster template available for creating new composite resources [here](plasterTemplate/NewBenchmarkCompositeResource). The following will install Plaster and take you through the prompts to generate the scaffolding for the new composite resource.

```
git clone https://github.com/techservicesillinois/SecOps-Powershell-CISDSC
Install-Module -Name Plaster
Install-Module -Name ImportExcel

Invoke-Plaster -TemplatePath '.\plasterTemplates\NewBenchmarkCompositeResource\' -DestinationPath '.\src\CISDSC\dscresources'
.\plasterTemplates\generate_schemapsm1_contents_from_excel.ps1 -Path <Excel file from above> -TargetSchemaPsm1 <Output file from previous command> -UserSettingsSection <User settings section from excel file>
```

Settings in the benchmark have three part identifiers that should be referenced to support the exclude list as well as the regions laid out by the Plaster template. These ensure they are easily maintained by the developers and customized by the users. The PDF of the benchmarks is the best source for this.
![category](/screenshots/category.PNG)

![section](/screenshots/section.PNG)

![setting](/screenshots/setting.PNG)

Both level 1 & 2 of the benchmark will be in the same resource with a level parameter. The same is true for the optional BitLocker components.

Any setting that has multiple supported values or a min/max value should be parameterized with a default value. Ex: If the bench mark is a minimum log file size or a maximum amount of minutes on a timeout but not an explicit value.

Your composite resource version should match the version of the benchmark to easily correlate what it was based on, this is handled by the Plaster template. Ex: The current benchmark for Windows 10 Enterprise 1909 is v1.8.1 since these are versioned as they are revisited by CIS them with new recommendations.

![version](/screenshots/version.PNG)

# To Do
