#requires -Module BetterCredentials
<#
This script publishes the module to the gallery.
It expects as input an ApiKey authorized to publish the module.

Insert any build steps you may need to take before publishing it here.
#>
param (
    $ApiKey,
    $WhatIf
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
    
    
    $SplatArgs = @{
        Repository  = 'þRepositoryNameþ'
        Path 		= "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\þnameþ"
        NuGetApiKey = $PlainPassword
        Verbose     = $false
        Force       = $Force
    }
    Publish-Module @SplatArgs
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)	 #clear password
}
