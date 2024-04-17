# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Removed

- Removed 'Ensure Turn on PowerShell Transcription is set to Enabled (2)' and (3). These are subkeys of 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription' (OutputDirectory and EnableInvocationHeader) which are not mentioned by the CIS Benchmark and erroneously included in the GPOKit. Invalid ValueData for the OutputDirectory key was also causing issues with the MOF file in some cases, depending on how it was generated.

## [4.0.0] - 2024-03-26

### Added

- Windows 11 23H2 Resources, documentation and example scripts

### Changed

- Microsoft Windows 11 Enterprise added to OS parameter validation in ConvertTo-DSC

### Removed

- Failing tests from CISDSC.Tests (opened issue #269)
- Remove 5.3 per https://workbench.cisecurity.org/benchmarks/16515/tickets/21051

## [3.1.1] - 2023-01-23

### Changed

- Static corrections for Server 2022 regarding recommendation 18.9.108.4.3 were set to ignore, then the resource was regenerated. Originally CIS gave us incorrect information about the nature of these registry keys and whether they are required to meet that recommendation. They are not required and artifacts of the GPO build kit.

## [3.1.0] - 2022-12-05

### Changed

- Old LAPS Product ID replaced with new

## [3.0.0] - 2022-11-30

### Added

- Generated 2022 release 21H2 resource
- Example in tools for how it was generated

### Changed

- More details and reordering some steps in new_resources.md to reflect actual development process
- Version number of CISDSCResourceGeneration module missed in last update

## [2.5.3] - 2022-11-18

- Fixed missing validate range for cis189623101MaxIdleTime in benchmark CIS_Microsoft_Windows_Server_2019_Member_Server_Release_20H2
- Corrected Changelog and License URIs in the manifest to be raw links
- Fix for NUL character in registry policy file

## [2.5.2] - 2022-03-16

### Changed

- Resource generation no longer generates DSCTitles that exceeded character limits for use in Azure. [Issue 248](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/248)
- Design choice

## [2.5.1] - 2021-08-31

### Changed

- Fixed casing on CISDSC examples directory. [Issue 216](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/216)
- Added IconURI to CISDSC manifest
- CIS_Microsoft_Windows_Server_2019_Member_Server_Release_20H2 updated to latest benchmark release. [Issue 222](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/222).

### Removed

- Duplicate keys for next generation windows security in CIS_Microsoft_Windows_Server_2019_Member_Server_Release_20H2 [Issue 222](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/222).

## [2.5.0] - 2021-07-22

### Changed

- Updated Windows 10 Enterprise 20H2 to v10.0.1 of the benchmark. No functional changes so just increase in version number.

### Added

- Added new DSC resource for Windows 10 enterprise 21H1. CIS_Microsoft_Windows_10_Enterprise_Release_21H1 [Issue 208](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/208)

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
