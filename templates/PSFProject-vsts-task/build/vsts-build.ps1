#requires -Module BetterCredentials
<#
This script publishes the module to the gallery.
It expects as input an ApiKey authorized to publish the module.

Insert any build steps you may need to take before publishing it here.

.NOTES
    Requires TFX-CLI https://www.npmjs.com/package/tfx-cli

    PS>npm install -g tfx-cli
    Install

    PS> tfx login --service-url {TFSURL}/DefaultCollection -token MyTokenFromTFS
    The first time you do this on a system, you need to cache your credential for the tfx cli
#>
param (
    $ApiKey,
    $WhatIf,
    $Force = $true
)
Get-ChildItem -Path "$PSScriptRoot\functions" -Filter *.ps1 | ForEach-Object { 
    Unblock-File $_.FullName
    . "$($_.FullName)"
}
$ENV:SYSTEM_DEFAULTWORKINGDIRECTORY = ($env:SYSTEM_DEFAULTWORKINGDIRECTORY,$PSScriptRoot -ne $null)[0]


if ($WhatIf)
{
    Publish-Module -Repository 'þRepositoryNameþ' -Path "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ" -NuGetApiKey $ApiKey -Force -WhatIf
}
else
{

    # credentials setup
    $cred = Find-Credential 'þPublishApiCredentialNameþ' ## USES BetterCredentials
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR([SecureString]($cred.Password))
    $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    Update-Version -ModuleDirectory "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ"
    
    #copy lastest vststasksdk if doesn't exist
    if(!(Test-Path "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ\ps_modules" -PathType Container))
    { 
    $ModuleDirectory      = "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ"
    $DestinationDirectory = New-Item "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ\ps_modules\VstsTaskSdk" -Force -ItemType Directory
    $TempFolder           = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
    Save-Module -Name VstsTaskSdk -Path $TempFolder -Force 
    $VersionFolder        = (GCI $TempFolder -Filter 'VstsTaskSdk.psd1' -Recurse | select -Expand Directory).FullName
    . robocopy $VersionFolder $DestinationDirectory /S /PURGE
    }
    
    $SplatArgs = @{
        Repository  = 'þRepositoryNameþ'
        Path 		= "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ"
        NuGetApiKey = $PlainPassword
        Verbose     = $false
        Force       = $Force
    }
    Publish-Module @SplatArgs
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)	 #clear password
    tfx build tasks upload --task-path "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ"
    
    }

}
