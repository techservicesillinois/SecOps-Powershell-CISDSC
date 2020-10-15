# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
### Changed
### Removed

## 2.2.2
### Changed
- Standardized casing for typing on resource parameters [Issue 143](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/143)

## 2.2.1
### Added
- Added resource example files to the Plaster template [Issue 133](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/133)
### Changed
- Corrected special case for HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\ScreenSaverGracePeriod incorrectly setting to DWORD instead of string [Issue 136](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/136)

## 2.2.0
### Added
- Added support for overriding parameters that are generated [Issue 71](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/71)

## 2.1.2
### Added
- Added support for dynamic setting on recommendation IDs on the special case recommendations (legal notice and account renames) [Issue 129](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/129)

## 2.1.1
### Added
### Changed
- Changed service logic to use the CISService resource [Issue 121](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/121)
### Removed

## 2.1 - 9/30/20
### Added
- Functionality to generate resource documentation along side the DSC resources [Issue 114](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/114)

## [2.0.0]
- Start of changelog