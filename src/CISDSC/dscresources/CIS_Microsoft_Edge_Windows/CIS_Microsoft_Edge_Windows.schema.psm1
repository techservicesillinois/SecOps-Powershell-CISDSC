Configuration CIS_Microsoft_Edge_Windows
{
    param
    (
        [String[]]$ExcludeList = @(),
        [Boolean]$LevelOne = $true,
        [Boolean]$LevelTwo = $false
    )

    Import-DSCResource -ModuleName 'PSDesiredStateConfiguration'

    if($ExcludeList -notcontains '1.1.1' -and $LevelOne){
        Registry "1.1.1 - (L1) Ensure Ads setting for sites with intrusive ads is set to Enabled Block ads on sites with intrusive ads" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'AdsSettingForIntrusiveAdsSites'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.2' -and $LevelOne){
        Registry "1.1.2 - (L1) Ensure Allow download restrictions is set to Enabled Block potentially dangerous downloads" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'DownloadRestrictions'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.3' -and $LevelTwo){
        Registry "1.1.3 - (L2) Ensure Allow file selection dialog is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AllowFileSelectionDialogs'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.4' -and $LevelOne){
        Registry "1.1.4 - (L1) Ensure Allow Google Cast to connect to Cast devices on all IP addresses is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'MediaRouterCastAllowAllIPs'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.5' -and $LevelOne){
        Registry "1.1.5 - (L1) Ensure Allow importing of autofill form data is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ImportAutofillFormData'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.6' -and $LevelOne){
        Registry "1.1.6 - (L1) Ensure Allow importing of browser settings is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ImportBrowserSettings'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.7' -and $LevelOne){
        Registry "1.1.7 - (L1) Ensure Allow importing of home page settings is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ImportHomepage'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.8' -and $LevelOne){
        Registry "1.1.8 - (L1) Ensure Allow importing of payment info is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ImportPaymentInfo'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.9' -and $LevelOne){
        Registry "1.1.9 - (L1) Ensure Allow importing of saved passwords is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ImportSavedPasswords'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.10' -and $LevelOne){
        Registry "1.1.10 - (L1) Ensure Allow importing of search engine settings is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ImportSearchEngine'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.11' -and $LevelOne){
        Registry "1.1.11 - (L1) Ensure Allow managed extensions to use the Enterprise Hardware Platform API is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'EnterpriseHardwarePlatformAPIEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.12' -and $LevelTwo){
        Registry "1.1.12 - (L2) Ensure Allow or block audio capture is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AudioCaptureAllowed'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.13' -and $LevelTwo){
        Registry "1.1.13 - (L2) Ensure Allow or block video capture is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'VideoCaptureAllowed'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.14' -and $LevelTwo){
        Registry "1.1.14 - (L2) Ensure Allow or deny screen capture is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ScreenCaptureAllowed'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.15' -and $LevelOne){
        Registry "1.1.15 - (L1) Ensure Allow personalization of ads search and news by sending browsing history to Microsoft is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'PersonalizationReportingEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.16' -and $LevelOne){
        Registry "1.1.16 - (L1) Ensure Allow queries to a Browser Network Time service is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'BrowserNetworkTimeQueriesEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.17' -and $LevelTwo){
        Registry "1.1.17 - (L2) Ensure Allow suggestions from local providers is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'LocalProvidersEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.18' -and $LevelOne){
        Registry "1.1.18 - (L1) Ensure Allow the audio sandbox to run is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'AudioSandboxEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.19' -and $LevelOne){
        Registry "1.1.19 - (L1) Ensure Allow user feedback is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'UserFeedbackAllowed'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.20' -and $LevelTwo){
        Registry "1.1.20 - (L2) Ensure Allow users to open files using the ClickOnce protocol is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ClickOnceEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.21' -and $LevelTwo){
        Registry "1.1.21 - (L2) Ensure Allow users to open files using the DirectInvoke protocol is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'DirectInvokeEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.22' -and $LevelTwo){
        Registry "1.1.22 - (L2) Ensure Allow users to proceed from the HTTPS warning page is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'SSLErrorOverrideAllowed'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.23' -and $LevelOne){
        Registry "1.1.23 - (L1) Ensure Allow websites to query for available payment methods is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'PaymentMethodQueryEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.24' -and $LevelOne){
        Registry "1.1.24 - (L1) Ensure Allows a page to show popups during its unloading is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AllowPopupsDuringPageUnload'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.25' -and $LevelTwo){
        Registry "1.1.25 - (L2) Ensure Ask where to save downloaded files is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'PromptForDownloadLocation'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.26' -and $LevelOne){
        Registry "1.1.26 - (L1) Ensure Automatically import another browsers data and settings at first run is set to Enabled Disables automatic import and the import section of the first-run experience is skipped" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 4
            ValueName = 'AutoImportAtFirstRun'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.27' -and $LevelTwo){
        Registry "1.1.27 - (L2) Ensure Block third party cookies is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'BlockThirdPartyCookies'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.28' -and $LevelOne){
        Registry "1.1.28 - (L1) Ensure Block tracking of users web-browsing activity is set to Enabled Balanced (Blocks harmful trackers and trackers from sites user has not visited content and ads will be less personalized)" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'TrackingPrevention'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.29' -and $LevelTwo){
        Registry "1.1.29 - (L2) Ensure Browser sign-in settings is set to Enabled Disable browser sign-in" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'BrowserSignin'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.30' -and $LevelOne){
        Registry "1.1.30 - (L1) Ensure Clear browsing data when Microsoft Edge closes is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ClearBrowsingDataOnExit'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.31' -and $LevelOne){
        Registry "1.1.31 - (L1) Ensure Clear cached images and files when Microsoft Edge closes is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ClearCachedImagesAndFilesOnExit'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.32' -and $LevelOne){
        Registry "1.1.32 - (L1) Ensure Configure InPrivate mode availability is set to Enabled InPrivate mode disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'InPrivateModeAvailability'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.33' -and $LevelTwo){
        Registry "1.1.33 - (L2) Ensure Configure Online Text To Speech is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ConfigureOnlineTextToSpeech'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.34' -and $LevelOne){
        Registry "1.1.34 - (L1) Ensure Configure the list of names that will bypass the HSTS policy check is set to Disabled" {
            Ensure = 'Absent'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge\HSTSPolicyBypassList'
            ValueName = ''
        }
    }
    if($ExcludeList -notcontains '1.1.35' -and $LevelOne){
        Registry "1.1.35 - (L1) Ensure Configure the list of types that are excluded from synchronization is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge\SyncTypesListDisabled'
            ValueData = 'passwords'
            ValueName = '1'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '1.1.36' -and $LevelOne){
        Registry "1.1.36 - (L1) Ensure Configure the Share experience is set to Enabled Dont allow using the Share experience" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'ConfigureShare'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.37' -and $LevelOne){
        Registry "1.1.37 - (L1) Ensure Continue running background apps after Microsoft Edge closes is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'BackgroundModeEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.38' -and $LevelOne){
        Registry "1.1.38 - (L1) Ensure Control communication with the Experimentation and Configuration Service is set to Enabled Disable communication with the Experimentation and Configuration Service" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ExperimentationAndConfigurationServiceControl'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.39' -and $LevelOne){
        Registry "1.1.39 - (L1) Ensure Delete old browser data on migration is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'DeleteDataOnMigration'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.40' -and $LevelOne){
        Registry "1.1.40 - (L1) Ensure Disable saving browser history is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'SavingBrowserHistoryDisabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.41' -and $LevelOne){
        Registry "1.1.41 - (L1) Ensure Disable synchronization of data using Microsoft sync services is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'SyncDisabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.42' -and $LevelOne){
        Registry "1.1.42 - (L1) Ensure DNS interception checks enabled is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'DNSInterceptionChecksEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.43' -and $LevelOne){
        Registry "1.1.43 - (L1) Ensure Enable AutoFill for addresses is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AutofillAddressEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.44' -and $LevelOne){
        Registry "1.1.44 - (L1) Ensure Enable AutoFill for credit cards is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AutofillCreditCardEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.45' -and $LevelOne){
        Registry "1.1.45 - (L1) Ensure Enable component updates in Microsoft Edge is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'ComponentUpdatesEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.46' -and $LevelOne){
        Registry "1.1.46 - (L1) Ensure Enable deleting browser and download history is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AllowDeletingBrowserHistory'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.47' -and $LevelOne){
        Registry "1.1.47 - (L1) Ensure Enable globally scoped HTTP auth cache is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'GloballyScopeHTTPAuthCacheEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.48' -and $LevelTwo){
        Registry "1.1.48 - (L2) Ensure Enable guest mode is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'BrowserGuestModeEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.49' -and $LevelOne){
        Registry "1.1.49 - (L1) Ensure Enable network prediction is set to Enabled Dont predict network actions on any network connection" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'NetworkPredictionOptions'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.50' -and $LevelTwo){
        Registry "1.1.50 - (L2) Ensure Enable online OCSPCRL checks is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'EnableOnlineRevocationChecks'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.51' -and $LevelOne){
        Registry "1.1.51 - (L1) Ensure Enable Proactive Authentication is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ProactiveAuthEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.52' -and $LevelOne){
        Registry "1.1.52 - (L1) Ensure Enable profile creation from the Identity flyout menu or the Settings page is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'BrowserAddProfileEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.53' -and $LevelOne){
        Registry "1.1.53 - (L1) Ensure Enable renderer code integrity is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'RendererCodeIntegrityEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.54' -and $LevelOne){
        Registry "1.1.54 - (L1) Ensure Enable resolution of navigation errors using a web service is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ResolveNavigationErrorsUseWebService'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.55' -and $LevelTwo){
        Registry "1.1.55 - (L2) Ensure Enable Search suggestions is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'SearchSuggestEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.56' -and $LevelOne){
        Registry "1.1.56 - (L1) Ensure Enable security warnings for command-line flags is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'CommandLineFlagSecurityWarningsEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.57' -and $LevelOne){
        Registry "1.1.57 - (L1) Ensure Enable site isolation for every site is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'SitePerProcess'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.58' -and $LevelTwo){
        Registry "1.1.58 - (L2) Ensure Enable Translate is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'TranslateEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.59' -and $LevelOne){
        Registry "1.1.59 - (L1) Ensure Enable usage and crash-related data reporting is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'MetricsReportingEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.60' -and $LevelOne){
        Registry "1.1.60 - (L1) Ensure Enable use of ephemeral profiles is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ForceEphemeralProfiles'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.61' -and $LevelTwo){
        Registry "1.1.61 - (L2) Ensure Enforce Bing SafeSearch is set to Enabled Configure moderate search restrictions in Bing" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'ForceBingSafeSearch'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.62' -and $LevelTwo){
        Registry "1.1.62 - (L2) Ensure Enforce Google SafeSearch is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ForceGoogleSafeSearch'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.63' -and $LevelTwo){
        Registry "1.1.63 - (L2) Ensure Extend Adobe Flash content setting to all content is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'RunAllFlashInAllowMode'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.64' -and $LevelOne){
        Registry "1.1.64 - (L1) Ensure Hide the First-run experience and splash screen is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'HideFirstRunExperience'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.65' -and $LevelOne){
        Registry "1.1.65 - (L1) Ensure Manage exposure of local IP addresses by WebRTC is set to Disabled" {
            Ensure = 'Absent'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge\WebRtcLocalIpsAllowedUrls'
            ValueName = ''
        }
    }
    if($ExcludeList -notcontains '1.1.66' -and $LevelOne){
        Registry "1.1.66 - (L1) Ensure Notify a user that a browser restart is recommended or required for pending updates is set to Enabled Required - Show a recurring prompt to the user indicating that a restart is required" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'RelaunchNotification'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.67' -and $LevelOne){
        Registry "1.1.67 - (L1) Ensure Restrict exposure of local IP address by WebRTC is set to Enabled Allow public interface over http default route. This doesnt expose the local IP address" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 'default_public_interface_only'
            ValueName = 'WebRtcLocalhostIpHandling'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '1.1.68' -and $LevelOne){
        Registry "1.1.68 - (L1) Ensure Send site information to improve Microsoft services is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'SendSiteInfoToImproveServices'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.69' -and $LevelOne){
        Registry "1.1.69 - (L1) Ensure Set disk cache size in bytes is set to Enabled 250609664" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 250609664
            ValueName = 'DiskCacheSize'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.70' -and $LevelOne){
        Registry "1.1.70 - (L1) Ensure Set the time period for update notifications is set to Enabled 86400000" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 86400000
            ValueName = 'RelaunchNotificationPeriod'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.71' -and $LevelTwo){
        Registry "1.1.71 - (L2) Ensure Show an Always open checkbox in external protocol dialog is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'ExternalProtocolDialogShowAlwaysOpenCheckbox'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.72' -and $LevelTwo){
        Registry "1.1.72 - (L2) Ensure Specify if online OCSPCRL checks are required for local trust anchors is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'RequireOnlineRevocationChecksForLocalAnchors'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.1.73' -and $LevelOne){
        Registry "1.1.73 - (L1) Ensure Suggest similar pages when a webpage cant be found is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AlternateErrorPagesEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.2.1' -and $LevelOne){
        Registry "1.2.1 - (L1) Ensure Enable Google Cast is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'EnableMediaRouter'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.3.1' -and $LevelTwo){
        Registry "1.3.1 - (L2) Ensure Control use of the Web Bluetooth API is set to Enabled Do not allow any site to request access to Bluetooth" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'DefaultWebBluetoothGuardSetting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.3.2' -and $LevelTwo){
        Registry "1.3.2 - (L2) Ensure Control use of the WebUSB API is set to Enabled Do not allow any site to request access to USB" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'DefaultWebUsbGuardSetting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.3.3' -and $LevelTwo){
        Registry "1.3.3 - (L2) Ensure Default Adobe Flash setting is set to Enabled Block the Adobe Flash plug-in" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'DefaultPluginsSetting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.3.4' -and $LevelOne){
        Registry "1.3.4 - (L1) Ensure Default geolocation setting is set to Enabled Dont allow any site to track users physical location" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 2
            ValueName = 'DefaultGeolocationSetting'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.6.1' -and $LevelOne){
        Registry "1.6.1 - (L1) Ensure Allow cross-origin HTTP Basic Auth prompts is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'AllowCrossOriginAuthPrompt'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.6.2' -and $LevelTwo){
        Registry "1.6.2 - (L2) Ensure Supported authentication schemes is set to Enabled digest ntlm negotiate" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 'digest, ntlm, negotiate'
            ValueName = 'AuthSchemes'
            ValueType = 'String'
        }
    }
    if($ExcludeList -notcontains '1.8.1' -and $LevelOne){
        Registry "1.8.1 - (L1) Ensure Enable saving passwords to the password manager is set to Disabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 0
            ValueName = 'PasswordManagerEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.11.1' -and $LevelOne){
        Registry "1.11.1 - (L1) Ensure Configure Microsoft Defender SmartScreen is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'SmartScreenEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.11.2' -and $LevelOne){
        Registry "1.11.2 - (L1) Ensure Configure Microsoft Defender SmartScreen to block potentially unwanted apps is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'SmartScreenPuaEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.11.3' -and $LevelOne){
        Registry "1.11.3 - (L1) Ensure Force Microsoft Defender SmartScreen checks on downloads from trusted sources is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'SmartScreenForTrustedDownloadsEnabled'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.11.4' -and $LevelOne){
        Registry "1.11.4 - (L1) Ensure Prevent bypassing Microsoft Defender SmartScreen prompts for sites is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'PreventSmartScreenPromptOverride'
            ValueType = 'Dword'
        }
    }
    if($ExcludeList -notcontains '1.11.5' -and $LevelOne){
        Registry "1.11.5 - (L1) Ensure Prevent bypassing of Microsoft Defender SmartScreen warnings about downloads is set to Enabled" {
            Ensure = 'Present'
            Key = 'HKLM:\Software\Policies\Microsoft\Edge'
            ValueData = 1
            ValueName = 'PreventSmartScreenPromptOverrideForFiles'
            ValueType = 'Dword'
        }
    }
}
