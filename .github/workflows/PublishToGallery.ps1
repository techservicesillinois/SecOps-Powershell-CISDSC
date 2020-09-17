try{
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
    Publish-Module -Path '.\src\CISDSC' -Repository 'PSGallery' -NuGetApiKey $ENV:NuGetApiKey -Force
}
catch{
    throw $_
}