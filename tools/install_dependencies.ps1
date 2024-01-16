Install-Module -Name ('ImportExcel', 'Plaster', 'pester') -Scope CurrentUser -Force
Install-Module -Name 'GPRegistryPolicyParser' -AllowPrerelease -Scope CurrentUser -Force
Install-Module -Name 'AuditPolicyDSC' -RequiredVersion '1.4.0.0' -Scope CurrentUser -Force
Install-Module -Name 'SecurityPolicyDSC' -RequiredVersion '2.10.0.0' -Scope CurrentUser -Force
