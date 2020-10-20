# What setup is needed to run a configuration?
- Preparing a system to take DSC configurations requires configuration of WinRm (Windows Remote Management) and the LCM (Local Configuration Manager)
- Settings should be applied in the order this document is written to avoid potential issues

## WinRm

### Enabling
- WinRM will need to be enabled on the machine for the LCM to do it's job. This is due to it leveraging "implicit remoting". Documentation for WinRM can be found [here](https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management) or you can use the quick setups with either of the following commands to enable with default configuration. These commands will not work if any network adapter is set to use the public network profile. It is possible to bypass this but not recommended for security reasons, recommended solution is to set them to domain or private. This includes virtual adapters such as ones created by VPNs or Hypver-V.

```
# -Force can be omitted if doing this manually but is required to suppress prompts when running in an automated fashion
Enable-PSRemoting -Force
```

### MaxEnvelopeSize
- Increase the WinRM MaxEnvelopeSize quota. This specifies the maximum Simple Object Access Protocol (SOAP) data in kilobytes for the WinRM service. The default value for this is often too low for larger DSC configurations. Increasing this is a harmless change assuming it's kept under the supported limit of 1039440 defined in the [documentation](https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management#maxenvelopesizekb). The default value is 500 but 2048-8192 is not uncommon for DSC usage. Below are commands for adjusting this setting, the value can be edited as needed.

```
Set-Item -Path 'WSMan:\localhost\MaxEnvelopeSizeKb' -Value 8192
```

## LCM
- The LCM is what executes DSC tasks on Windows and has been pre-installed since Windows 7. LCM configuration will be subject to your specific environment and needs. Below is an example of configuring it to act in an ad-hoc execution only mode disabling any routine consistency checks or [pull server](https://docs.microsoft.com/en-us/powershell/scripting/dsc/pull-server/pullserver?view=powershell-7) check ins. Advanced configuration options can be found [here](https://docs.microsoft.com/en-us/powershell/scripting/dsc/managing-nodes/metaconfig?view=powershell-7).

```
[DSCLocalConfigurationManager()]
configuration LCMConfig {
    Node 'localhost' {
        Settings {
            RefreshMode = 'Push'
            ConfigurationMode = 'ApplyOnly'
        }
    }
}

LCMConfig
Set-DscLocalConfigurationManager -Path '.\LCMConfig'
Remove-Item -Path '.\LCMConfig' -Recurse -Force
```

## Running a configuration
- At this point your system is able to run DSC configurations. After installing the CIDSC module from the [PSGallery](https://www.powershellgallery.com/packages/CISDSC) you can use any of the packaged [examples](/src/CISDSC/Examples) and [customize](./customization.md) them to your liking
- If you'd like to try these configurations out in an audit capacity additional steps to do so can be found in the [auditing document](./auditing.md)