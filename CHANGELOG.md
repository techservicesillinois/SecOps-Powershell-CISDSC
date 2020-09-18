# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- Added a parameter for 1.1.4 (L1) Ensure 'Minimum password length' is set to '14 or more character(s)' to the Windows 10 Enterprise 2004 resource as this setting was changed to accept up to 128 characters in this build.
## [1.0.0] - 2020-09-15
### Added
- Added DSC resource for Windows 10 Enterprise 1809 based on benchmark v1.6.1
- Windows 10 Enterprise 1903 is intentionally omitted due to approaching EOL
- Added DSC resource for Windows 10 Enterprise 1909 based on benchmark v1.8.1
- Added DSC resource for Windows 10 Enterprise 2004 based on benchmark v1.9.0