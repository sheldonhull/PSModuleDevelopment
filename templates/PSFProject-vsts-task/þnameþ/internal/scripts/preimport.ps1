<#
.Description
    Setup any requirements prior to importing module.
    To bypass running, use PSFramework to set the ENV.BypassPsDepend = $true and all dependencies will automatically by bypassed.
    You can also use a simple enviromental variable for an adhoc call, by using $ENV:BypassPsDepend = $true
.Example
    PS> Set-PSFConfig -FullName 'ENV.BypassPSDepend' -Value $true -PassThru | Register-PSFConfig -Scope UserDefault
    PS> .\preimport.ps1
#>

# Important >>  PSScriptRoot not accessible here <<
if ((Get-PSFConfigValue -FullName 'ENV.BypassPSDepend') -eq $true -or ([Bool]$ENV:BypassPsDepend = $true))
{
    Write-Host "þnameþ -- preimport.ps1 -- Bypassed per ENV.BypassPSDepend = `$true" -ForegroundColor Green
}
else
{
    Write-Host "þnameþ - Executing preimport.ps1 and setting up dependencies. Please wait..." -ForegroundColor Green
    [Version[]]$versions = @(Get-module PowershellGet -ListAvailable).Version
    [Version]$HighestVersion = $Versions | Sort-Object -Descending | Select -First 1
    [Bool]$NotInstalledForCurrentUser = @(Get-module PowershellGet -ListAvailable | Where-Object {$_.Path -Match [regex]::Escape($ENV:UserProfile)}).count -eq 0
    [Bool]$OutOfDatePowershellGet = $HighestVersion -le [Version]::New(1, 6, 5) # ensure updated version, no 1.0.1 PowershellGet allowed to be the default

    Write-Debug "þnameþ -- preimport.ps1 --`nSetup Logic$(Get-Variable Versions,HighestVersion,NotInstalledForCurrentUser,OutOfDatePowershellGet -ErrorAction SilentlyContinue | Format-Table -AutoSize -Wrap | out-string)"
    #if current user doesn't have installed to local profile, ensure it's installed.
    if ($OutOfDatePowershellGet -or $NotInstalledForCurrentUser)
    {
        install-module PowershellGet -scope CurrentUser -confirm:$false -Force -AllowClobber
        Write-Warning  "þnameþ - preimport.ps1 - Installed updated version of PowershellGet to local user profile. If error experienced, restart Powershell Session to import the latest version."
    }


    if (@(Get-module PSDepend -ListAvailable).count -eq 0)
    {
        install-module PSDepend -scope currentuser -confirm:$false -force -AllowClobber
    }
    invoke-psdepend -inputobject @{
        psdepend                         = 'latest'
        PsDependoptions                  = @{
            Version = 'Latest'
            Target  = 'CurrentUser'
        }
        'PSGalleryModule::PowershellGet' = 'latest';
        'PSGalleryModule::PSFramework'   = 'latest';
        'PSGalleryModule::Dbatools'      = 'latest';
    } -quiet -confirm:$false
}