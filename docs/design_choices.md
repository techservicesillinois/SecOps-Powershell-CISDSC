# Design choices

This document outlines justifications for design choices through out this project that may not be obvious at first.

## Recommendation title length

Recommendation titles have been truncated to 256 characters as a result of [#248](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/248). This is a known limitation in Azure.

## Parameter name prefixes

Parameter names have all been prefixed with "cis" as a result of [#169](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/169). This was causing PSScriptAnalyzer heart burn as well as various other quirks.

## CISService over Service

This class based resource was introduced due to [#121](https://github.com/techservicesillinois/SecOps-Powershell-CISDSC/issues/121). The actual CIS recommendation was that a given service was absent or disabled. The native service resource from PSDesiredStateConfiguration did not achieve this and also required that absent services be known ahead of time and added to the excludelist. This approach was both a quality of life improvement and more in line with the benchmark itself.

## Build specific CSVs

This is due to the fact CIS reserves the right to change recommendation IDs which are used in these corrections. A specific recommendation may carry over to the next build of the OS but have a different ID. There is also different IDs for the same recommendations between server and workstation in many cases.

## Legal notice and local account renames have no default values

These are by nature incredibly specific to the envrionment a given host exists in so a reasonable default value does not exist.

## BaselineManagement forked and not just marked as a dependency

There were several bugs within BaselineManagement combined with our very specific use case for its functionality so it was heavily modified and baked into CISDSCResourceGeneration instead.

## User based settings are not supported

While technically possible through DSC we made a decision at the start not to support these. Because popular opinion is these are best managed via group policy and the situations in which it's even possible to use DSC are rare which didn't make it worth while.

## Not supporting legacy formatting of the CIS documents

CIS benchmarks evolve with every revision and the same goes for the document format. It would be difficult to guarantee every difference between documentation generations is accounted for so while older generations will likely work with minimum modification to the document (primarily worksheet names) we will only explicitly support/test the latest generation.

## No longer requiring CIS-CAT reports for new resources

CIS-CAT scans had a lot of value early in the project when bugs where being discovered and squashed however it's value has diminished rapidly as the code base has matured. This is combined with the facts that this is often the longest phase of developing a resource and causes the biggest delays due to CIS-CAT lagging in support of new benchmarks for weeks or months in some cases. We have opted to commit to a "sanity check" with CIS-CAT every other build when it becomes available but not make it a requirement for release.
