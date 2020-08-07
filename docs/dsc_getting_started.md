# What setup is needed to run a configuration?
- There is no agent to install needed to execute PowerShell DSC. It utilizes the LCM (Local Configuration Manager) that has been pre-installed since Windows 7.
The LCM will be able to execute on ad-hoc manual configurations with no configuration but advanced setup can be found [here](https://docs.microsoft.com/en-us/powershell/scripting/dsc/managing-nodes/metaconfig?view=powershell-7)

- WinRM will need to be enabled on the machine for the LCM to do it's job. This is due to it leveraging "implicit remoting". Documentation for WinRM can be found [here](https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management) or you can use the quick setups with either of the following commands to enable with default configuration.

CMD
```
winrm quickconfig
```

PowerShell
```
Enable-PSRemoting –force
```

- Increase the WinRM MaxEnvelopeSize quota. This specifies the maximum Simple Object Access Protocol (SOAP) data in kilobytes for the WinRM service. The default value for this is often too low for larger DSC configurations. Increasing this is a harmless change assuming it's kept under the supported limit of 1039440 defined in the above WinRM documentation. The default value is 500 but 2048-8192 is not uncommon for DSC usage. Below are commands for adjusting this setting, the value can be edited as needed.

CMD
```
winrm set winrm/config @{MaxEnvelopeSizekb="8192"}
```

PowerShell
```
Set-Item -Path WSMan:\localhost\MaxEnvelopeSizeKb -Value 8192
```