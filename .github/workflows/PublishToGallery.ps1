try{
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

    (Import-PowerShellDataFile -Path '.\src\CISDSC\CISDSC.psd1')['RequiredModules'] | ForEach-Object -Process {
        Install-Module -Name $_['ModuleName'] -RequiredVersion $_['ModuleVersion'] -Force -SkipPublisherCheck
    }

    Publish-Module -Path '.\src\CISDSC' -Repository 'PSGallery' -NuGetApiKey $ENV:NuGetApiKey -Force
}
catch{
    throw $_
}