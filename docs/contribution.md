# Contribution Guidelines
This document aims to outline the requirements for the various forms of contribution for this project.

**ALL** contributions are subject to review via pull request

## New Resources
- Pull requests must contain an attached CIS-CAT scan result for at least "Level One"
- Update the "Unreleased" section of the [changelog](/CHANGELOG.md) to reflect it was added
- Do not increment the CISDSC version number as this will be done when a release is staged
- Resources are expected to have a version number matching the benchmark version they are based on
- All parameters are expected to have validation blocks with entries tracked in a [parameter validation](/parameter_validation) file
- Documentation must be placed in the [module's docs folder](/src/CISDSC/docs)

## Resource Corrections
- Cited documentation on why the existing setting was incorrect
- If applicable create an entry in the appropriate [static corrections](/csvs/static_corrections) file so that this change isn't lost in the event the resource is re-generated
- Increment the revision (4th) section of the resources version.
- Update the "Unreleased" section of the [changelog](/CHANGELOG.md) to reflect the change
- Documentation must be updated if applicable in the [module's docs folder](/src/CISDSC/docs)

## CISDSCResourceGeneration Enhancements
- Changes must have an associated Pester test if applicable
- Issue justifying the change should be created and cited in the pull request
- Update the [changelog](/CHANGELOG_CISDSCResourceGeneration.md) to reflect the change
- Increment the version number appropriately, there is no proper release for this so it is incremented as it's updated

## Documentation
- Must be in markdown