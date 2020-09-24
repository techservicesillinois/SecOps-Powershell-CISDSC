# Contribution Guidelines
This document aims to outline the requirements for the various forms of contribution for this project.

## New Resources
- Subject to review via pull request
- Pull requests must contain an attached CIS-CAT scan result for at least "Level One"
- Update the "Unreleased" section of the [changelog](/CHANGELOG.md) to reflect it was added
- Do not increment the CISDSC version number as this will be done when a release is staged
- Resources are expected to have a version number matching the benchmark version they are based on
- All parameters are expected to have validation blocks with entries tracked in a [parameter validation](/parameter_validation) file

## Resource Corrections
- Subject to review via pull request
- Cited documentation on why the existing setting was incorrect
- If applicable create an entry in the appropriate [static corrections](/static_corrections) file so that this change isn't lost in the event the resource is re-generated
- Increment the revision (4th) section of the resources version.
- Update the "Unreleased" section of the [changelog](/CHANGELOG.md) to reflect the change

## CISDSCResourceGeneration Enhancements
- Subject to review via pull request
- Changes must have an associated Pester test if applicable
- Issue justifying the change should be created and cited in the pull request
- Update the [changelog](/CHANGELOG_CISDSCResourceGeneration.md) to reflect the change
- Increment the version number appropriately, there is no proper release for this so it is incremented as it's updated

## Documentation
- Subject to review via pull request
- Must be in markdown