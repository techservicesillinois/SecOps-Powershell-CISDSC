![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/ScriptAnalyzer/badge.svg)

# What is This?

# How do I install it?

# How does it work?

# How do I help?
The main form of contribution will be adding benchmarks for new OS/builds. The benchmarks are available via the [CIS workbench](https://workbench.cisecurity.org/) and require a free account to access.

Benchmarks are added in the form of composite resources. There is a Plaster template available for creating new composite resources [here](plasterTemplate/NewBenchmarkCompositeResource). The following will install Plaster and take you through the prompts to generate the scaffolding for the new composite resource.

```
Install-Module -Name Plaster
Invoke-Plaster -TemplatePath '.\plasterTemplates\NewBenchmarkCompositeResource\' -DestinationPath '.\src\CISDSC\dscresources'
```

Settings in the benchmark have three part identifiers that should be referenced to support the exclude list as well as the regions laid out by the Plaster template. These ensure they are easily maintained by the developers and customized by the users. The PDF of the benchmarks is the best source for this.
![category](/screenshots/category.png)

![section](/screenshots/section.png)

![setting](/screenshots/setting.png)

Level 1 & 2 benchmarks will be kept separate with the expectation being to achieve level 2 you need to use both the L1 and L2 resources applicable to your host.

Your composite resource version should match the version of the benchmark to easily correlate what it was based on, this is handled by the Plaster template. Ex: The current benchmark for Windows 10 Enterprise 1909 is v1.8.1 since these are versioned as they are revisited by CIS them with new recommendations.

![version](/screenshots/version.png)

# To Do
