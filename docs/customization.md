# How do I exclude recommendations?
It is not uncommon for a recommendation to need to be excluded from configurations or slightly adjusted. These resources have built-in support for these situations.
Every resource contains an ExcludeList property that allows you to exclude settings based on their recommendation ID. These IDs can be found in the CIS documentation available from [CIS](./cis.md). Using these documents you should be able to identify your setting in question and locate its ID number. Examples of excluding recommendations can be found in the applicable [resources documentation](/src/CISDSC/docs).

# How do I customize values of recommendations?
Some recommendations are for ranges of values not an explicit value. Examples include minimum number of days or log size. These customizations are also accounted for in these resources via parameters. Available parameters and syntax can always be found in the [resources documentation](/src/CISDSC/docs).

# Special cases
There are a handful of special cases for customization. These are most often legal disclaimer text and local account renames. These will require a value be provided as shown or their recommendation IDs be added to the ExcludeList. This is due to the fact that these fields are always organization specific so there are no safe defaults for these values. More information on this can be found in the applicable [resources documentation](/src/CISDSC/docs).