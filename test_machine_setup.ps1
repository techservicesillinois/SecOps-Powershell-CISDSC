#Requires -RunAsAdministrator

<#
    .DESCRIPTION
    Script for setting up a new machine to be used for testing new resources.
    Will install required modules from the PSGallery and packages from chocolatey.
#>

Set-ExecutionPolicy -ExecutionPolicy 'Unrestricted' -Scope 'LocalMachine'
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
Install-Module -Name 'cChoco' -Scope 'AllUsers'
Install-Module -Name 'AuditPolicyDSC' -RequiredVersion '1.4.0.0' -Scope 'AllUsers'
Install-Module -Name 'SecurityPolicyDSC' -RequiredVersion '2.10.0.0' -Scope 'AllUsers'

Enable-PSRemoting –Force
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