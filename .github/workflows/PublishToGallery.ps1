try{
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
    Install-Module -Name 'AuditPolicyDSC' -RequiredVersion '1.4.0.0' -Force -SkipPublisherCheck
    Install-Module -Name 'SecurityPolicyDSC' -RequiredVersion '2.10.0.0' -Force -SkipPublisherCheck
    Publish-Module -Path '.\src\CISDSC' -Repository 'PSGallery' -NuGetApiKey $ENV:NuGetApiKey -Force
}
catch{
    throw $_
}