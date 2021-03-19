# Design choices
This document outlines justifications for design choices through out this project that may not be obvious at first.

## Parameter name prefixes
Parameter names have all been prefixed with "cis" as a result of #169. This was causing PSScriptAnalyzer heart burn as well as various other quirks.

## CISService over Service
This class based resource was introdcued due to #121. The actual CIS recommendation was that a given service was absent or disabled. The native service resource from PSDesiredStateConfiguration did not achieve this and also required that absent services be known ahead of time and added to the excludelist. This approach was both a quality of life improvement and more in line with the benchmark itself.

## Build specific CSVs
This is due to the fact CIS reserves the right to change recommendation IDs which are used in these corrections. A specific recommendation may carry over to the next build of the OS but have a different ID. There is also different IDs for the same recommendations between server and workstation in many cases.

## Legal notice and local account renames have no default values
These are by nature incredibly specific to the envrionment a given host exists in so a reasonable default value does not exist.

## Why was BaselineManagement forked and not just marked as a dependency?
There were several bugs within BaselineManagement combined with our very specific use case for its functionality so it was heavily modified and baked into CISDSCResourceGeneration instead.

## Why aren't user based settings from the benchmarks supported?
While technically possible through DSC we made a decision at the start not to support these. Because popular opinion is these are best managed via group policy and the situations in which it's even possible to use DSC are rare which didn't make it worth while.
