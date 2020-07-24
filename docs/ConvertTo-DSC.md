---
external help file: CISDSCResourceGeneration-help.xml
Module Name: CISDSCResourceGeneration
online version:
schema: 2.0.0
---

# ConvertTo-DSC

## SYNOPSIS
Converts provided CIS benchmark materials and converts them to a DSC composite resource.

## SYNTAX

```
ConvertTo-DSC [-BenchmarkPath] <String> [-GPOPath] <String> [[-StaticCorrectionsPath] <String>]
 [[-OutputPath] <String>] [-OS] <String> [-OSBuild] <String> [-BenchmarkVersion] <Version> [<CommonParameters>]
```

## DESCRIPTION
Converts provided CIS benchmark materials and converts them to a DSC composite resource.

## EXAMPLES

### EXAMPLE 1
```
$Splat = @{
    BenchmarkPath = '.\CIS_Microsoft_Windows_Server_2016_RTM_Release_1607_Benchmark_v1.2.0.xlsx'
    BenchmarkVersion = 1.2.0
    GPOPath = '.\Server2016v1.2.0'
    OutputPath = '.\CISDSC\dscresources'
    StaticCorrectionsPath = '.\static_corrections.csv'
    OS = 'Microsoft Windows Server 2016 Member Server'
    OSBuild = '1607'
}
ConvertTo-DSC @Splat
```

## PARAMETERS

### -BenchmarkPath
Path to the excel document from CIS for the benchmark documentation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GPOPath
Path to the GPO files (build kit) from CIS containing the benchmarks settings.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StaticCorrectionsPath
Path to the CSV file containing known static corrections for GPO -\> Excel mismatchs.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Output directory for the files generated.
This will default to .\Output

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Join-Path -Path $PWD -ChildPath 'Output')
Accept pipeline input: False
Accept wildcard characters: False
```

### -OS
The operating system the benchmark is written for.
Supported values are the known Windows desktop and server versions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OSBuild
The build number of the operating system.
Ex: the 1909 in 'Microsoft Windows 10 Enterprise version 1909'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BenchmarkVersion
The version number of the CIS benchmark.
This will become the version number of the composite resource to show what version of the benchmark it's based off of.

```yaml
Type: Version
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
