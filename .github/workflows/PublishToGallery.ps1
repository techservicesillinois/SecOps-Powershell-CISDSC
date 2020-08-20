try{
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
    Install-Module -Name 'PSDepend' -Force -SkipPublisherCheck
    Invoke-PSDepend -Force
    Publish-Module -Path '.\src\CISDSC' -Repository 'PSGallery' -NuGetApiKey $ENV:NuGetApiKey -Force
}
catch{
    throw $_
}