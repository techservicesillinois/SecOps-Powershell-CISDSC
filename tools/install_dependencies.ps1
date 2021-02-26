Install-Module -Name ('ImportExcel', 'Plaster', 'pester') -Scope AllUsers -Force
Install-Module -Name 'GPRegistryPolicyParser' -AllowPrerelease -Scope AllUsers -Force
Install-Module -Name 'AuditPolicyDSC' -RequiredVersion '1.4.0.0' -Scope AllUsers -Force
Install-Module -Name 'SecurityPolicyDSC' -RequiredVersion '2.10.0.0' -Scope AllUsers -Force
