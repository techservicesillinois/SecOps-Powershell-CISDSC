![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/workflows/ScriptAnalyzer/badge.svg)

# What is This?
This project is designed to deliver [CIS](https://www.cisecurity.org/) security benchmarks in PowerShell DSC via the included [CISDSC](src/CISDSC) module.

It also contains a module to assist in the creation of these resources via [CISDSCResourceGeneration](src/CISDSCResourceGeneration) which is a heavily modified fork of [Microsoft's BaselineManagement](BaselineManagement) module.

# What is PowerShell DSC?
PowerShell DSC is a configuration management framework built into Windows 7+ powered by PowerShell. The below view gives a high level explanation of the framework.

</br>**What is PowerShell DSC (Desired State Configuration)?**</br>[![video](https://img.youtube.com/vi/k_rXBIHu3xk/0.jpg)](https://www.youtube.com/watch?v=k_rXBIHu3xk)

PowerShell DSC resources like the ones offered here can be utilized within other configuration management platforms as well. Making this an easy solution regardless of your platform of choice. </br>
[Ansible](https://docs.ansible.com/ansible/latest/modules/win_dsc_module.html)</br>
[Chef](https://docs.chef.io/resources/dsc_resource/)</br>
[Puppet](https://puppet.com/blog/managing-powershell-dsc-puppet/)</br>
[Manually](https://docs.microsoft.com/en-us/powershell/scripting/dsc/configurations/write-compile-apply-configuration?view=powershell-7#compile-the-configuration)

More detailed information can be found in the [getting started with DSC document](docs/dsc_getting_started.md)

# How do I install it?
The actual DSC resources should be installed via the CISDSC module's PSgallery page which doesn't exist yet.</br>

The process of setting up a development environment for contributes is outlined in [new resources](docs/new_resources.md).

# How can I contribute?
The most common form of code contributions come in the form of [static corrections](docs/static_corrections.md) and [new resources](docs/new_resources.md). However edits and additions to documentation are also always welcome.

# To Do