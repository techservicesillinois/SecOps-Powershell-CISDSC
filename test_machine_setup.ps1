#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Script for setting up a new machine to be used for testing new CIS resources. Per the new_resources.md doc in the DOCs folder.
    Will install required modules from the PSGallery and packages from chocolatey.
#>

#Fix for older versions of Windows since the PSGallery dropped support for TLS1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name 'PowerShellGet' -Scope 'AllUsers' -Force

Set-ExecutionPolicy -ExecutionPolicy 'Unrestricted' -Scope 'LocalMachine' -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
Install-Module -Name 'cChoco' -Scope 'AllUsers' -Force
Install-Module -Name 'AuditPolicyDSC' -RequiredVersion '1.4.0.0' -Scope 'AllUsers' -Force
Install-Module -Name 'SecurityPolicyDSC' -RequiredVersion '2.10.0.0' -Scope 'AllUsers' -Force

Enable-PSRemoting -Force
Set-Item -Path 'WSMan:\localhost\MaxEnvelopeSizeKb' -Value 8192

[DSCLocalConfigurationManager()]
configuration LCMConfig {
    Node 'localhost' {
        Settings {
            RefreshMode = 'Push'
            ConfigurationMode = 'ApplyOnly'
        }
    }
}
LCMConfig
Set-DscLocalConfigurationManager -Path '.\LCMConfig'

Configuration TestSetup {
    Import-DscResource -Module 'cChoco'

    Node 'localhost' {
        cChocoInstaller 'InstallChoco' {
            InstallDir = 'C:\choco'
        }
        cChocoPackageInstaller 'InstallGit' {
            Name = 'Git'
            Ensure = 'Present'
            DependsOn = '[cChocoInstaller]installChoco'
        }
        cChocoPackageInstaller 'InstallGoogleChrome' {
            Name = 'googlechrome'
            Ensure = 'Present'
            DependsOn = '[cChocoInstaller]installChoco'
        }
        cChocoPackageInstaller 'Installnotepadplusplus' {
            Name = 'notepadplusplus'
            Ensure = 'Present'
            DependsOn = '[cChocoInstaller]installChoco'
        }
        #Needed for CIS-CAT Assessor
        cChocoPackageInstaller 'InstallJRE8' {
            Name = 'jre8'
            Ensure = 'Present'
            DependsOn = '[cChocoInstaller]installChoco'
        }
        File 'RepoDir' {
            DestinationPath = 'C:\repos'
            Ensure = 'Present'
            Type = 'Directory'
        }
    }
}
TestSetup
Start-DscConfiguration -Path '.\TestSetup' -Verbose -Wait -Force
