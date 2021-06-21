# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Changed
- Updated Windows 10 Enterprise 20H2 to v10.0.1 of the benchmark. No functional changes so just increase in version number.

## [2.4.0] - 2021-06-17
### Added
- Added CIS_Microsoft_Windows_Server_2019_Member_Server_Release_20H2 for Server 2019 20H2 [Issue 181](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/181).
### Changed
- Updated the validation range for 1.1.2 MaximumPasswordAge to be 1-60 instead of 60-999 after reviewing CIS documentation per [Issue 204](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/204)
### Removed

## [2.3.0] - 2021-03-02
### Added
- Added CIS_Microsoft_Edge_Windows resource for applying benchmarks for Edge on Windows [Issue 185](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/185)
### Changed
### Removed

## [2.2.0] - 2021-01-29
### Added
- Added new DSC resource for Windows 10 enterprise 20H2. CIS_Microsoft_Windows_10_Enterprise_Release_20H2 [Issue 166](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/166)
### Changed
### Removed

## [2.1.1] - 2021-01-26
### Added
### Changed
- All parameter names with a lead numeric character (those associated with recommendations) have been prefixed with an "cis". This is to allign with standard naming conventions for DSC resources and to resolve issues with platforms such as Azure Automation and AWX. THIS IS A BREAKING CHANGE FOR EXISTING CONFIGURATIONS.
- Corrected references of 'ExclusionList' to 'ExcludeList'
### Removed

## [2.0.1] - 2020-10-30
### Added
- Added RunAsAdministrator requirement to packaged examples
### Changed
- Updated Windows 10 Enterprise 2004 to v1.9.1 of the benchmark [Issue 146](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/146)
- Various standardization and grammar adjustments in examples and documentation
### Removed

## [2.0.0] - 2020-10-19
### Added
- Added resource for Windows Server 2019 Release 1809 [Issue 7](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/7)
- Added resource for Windows Server 2016 Release 1607 [Issue 6](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/6)
### Changed
- Corrected ScreenSaverGracePeriod registry key to apply as a string instead of a Dword in Windows 10 Enterprise 1809, 1909, and 2004. [Issue 136](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/136)
- Correct the parameter validation 2374InactivityTimeoutSecs to be a ValidateRange not ValidateLength in Windows 10 Enterprise 1809, 1909, and 2004. [Issue 135](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/135)

## [1.1.0] - 2020-10-05
### Added
- Added CISService resource. This is a custom resource for managing services that will consider an absent or disabled service to be in desired state.
### Changed
- Updated Windows 10 Enterprise 1809, 1909, and 2004 to use the new CISService resource. This means users will no longer have to explicitly exclude absent services from their configurations to avoid errors. This is not a breaking a change.
### Removed
- Removed duplicate entry for HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}:NoGPOListChanges in Windows 10 Enterprise 1809

## [1.0.2] - 2020-09-30
### Added
- Added missing parameter validation for 189623101MaxIdleTime in Windows 10 Enterprise 2004
- Added docs folder within the module outlining the Windows 10 resources

## [1.0.1] - 2020-09-21
### Added
- Added missing key for HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI:AppHVSIClipboardFileType to Windows 10 Enterprise 2004 18.9.46.5

### Changed
- Corrected values for "18.8.7.1.5 - (BL) Ensure Prevent installation of devices using drivers that match these device setup classes Prevent installation of devices using drivers for these device setup is set to IEEE 1394 device setup classes" across multiple resources. These were previously being pinned to 18.8.7.1.4 with bad values in 18.8.7.1.5
- Reinstated parameter for 1.1.4 (L1) Ensure 'Minimum password length' is set to '14 or more character(s)' to the Windows 10 Enterprise 2004 resource as this setting was changed to accept up to 128 characters in this build.

## [1.0.0] - 2020-09-15
### Added
- Added DSC resource for Windows 10 Enterprise 1809 based on benchmark v1.6.1
- Windows 10 Enterprise 1903 is intentionally omitted due to approaching EOL
- Added DSC resource for Windows 10 Enterprise 1909 based on benchmark v1.8.1
- Added DSC resource for Windows 10 Enterprise 2004 based on benchmark v1.9.0
