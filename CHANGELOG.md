# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
### Changed
### Removed

## [1.1.0] - 2020-10-05
### Added
- Added CISService resource. This is a custom resource for managing services that will consider an absent or disabled service to be in desired state.
### Changed
- Updated Windows 10 Enterprise 1809, 1909, and 2004 to use the new CISService resource. This means users will no longer have to explicitly exclude absent services from their configurations to avoid errors. This is not a breaking a change.
### Removed
- Removed duplicate entry for HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}:NoGPOListChanges

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