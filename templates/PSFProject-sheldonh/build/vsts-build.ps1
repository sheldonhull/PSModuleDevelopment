
<#
This script publishes the module to the gallery.
It expects as input an ApiKey authorized to publish the module.

Insert any build steps you may need to take before publishing it here.

.NOTES
    For publishing with TFX for VSTS commands, requires TFX-CLI https://www.npmjs.com/package/tfx-cli

    PS>npm install -g tfx-cli
    Install

    PS> tfx login --service-url {TFSURL}/DefaultCollection -token MyTokenFromTFS
    The first time you do this on a system, you need to cache your credential for the tfx cli
#>

<#
This script publishes the module to the gallery.
It expects as input an ApiKey authorized to publish the module.

Insert any build steps you may need to take before publishing it here.
#>
param (
    [string]$ApiKey = (Get-PSFConfigValue 'API.ProgetApiKey' -Fallback $ENV:INPUT_APIKEY)
    , [string]$ReleaseNotes = $ENV:RELEASENOTES
    , [string]$TFSApiToken = (Get-PSFConfigValue 'API.TFSApiToken' -FallBack $ENV:SYSTEM_TOKEN)
    , $WhatIf
    , [string]$branch = ($env:BUILD_SOURCEBRANCHNAME, 'dev' -ne $Null)[0]
    , [switch]$force = $true

)

Get-ChildItem -Path "$PSScriptRoot\functions" -Filter *.ps1 | ForEach-Object {
    Unblock-File $_.FullName
    . "$($_.FullName)"
}

$ProjectDirectory = $PSScriptRoot | Split-Path -Parent
$ModuleName = $ProjectDirectory | Split-Path -Leaf
$ModuleDirectory = Join-Path $ProjectDirectory $ModuleName


$ENV:SYSTEM_DEFAULTWORKINGDIRECTORY = ($ProjectDirectory, $env:SYSTEM_DEFAULTWORKINGDIRECTORY -ne $null)[0]


if ($WhatIf)
{
    Publish-Module -Repository 'þRepositoryNameþ' -Path $ModuleDirectory  -NuGetApiKey $ApiKey -Force -WhatIf
}
else
{

    # credentials setup
    $result = Update-Version -ModuleDirectory $ModuleDirectory  -ReleaseNotes $ReleaseNotes
    Write-PSFMessage -Level Host -Message $result

    # generate a txt version of the markdown help for powershell get-help commands
    $script:UTF8_NO_BOM = New-Object System.Text.UTF8Encoding -ArgumentList $False
    New-ExternalHelp -Path (Join-Path $ModuleDirectory "en-us\about_$($ModuleName).md")  -OutputPath (Join-Path $ModuleDirectory "en-us") -ShowProgress -Force -Encoding $script:UTF8_NO_BOM

    # In publishing, eliminate test directory which may contain larger mock data
    Write-PSFMessage -Level VeryVerbose -Message "Copying $ModuleName to temp working directory to allow publishing without certain directories/contents such as tests"
    $FilteredPublishDirectory = New-Item -Path (Join-Path $ENV:TEMP $ModuleName) -ItemType Directory -Force
    Start-Process -FilePath 'CMD.EXE' -ArgumentList ('/C robocopy.exe "{0}" "{1} " /NFL /NC /MIR /XD "*tests"' -f $ModuleDirectory, $FilteredPublishDirectory) -NoNewWindow -Wait

    if ($result.TaskJsonFullName)
    {
        tfx build tasks upload --task-path "$FilteredPublishDirectory" --service-url (Get-PSFConfigValue -FullName 'VSTS.UrlDefaultCollection' -FallBack $ENV:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI) --token "$TFSApiToken" --no-prompt
    }

    $SplatArgs = @{
        Repository  = 'þRepositoryNameþ'
        Path        = $FilteredPublishDirectory
        NuGetApiKey = $ApiKey
        Verbose     = $false
        Force       = $force #needs to be true for noninteractive mode
    }
    Publish-Module @SplatArgs
    Write-PSFMessage -Level Host -Message "Published Module to þRepositoryNameþ"

    write-Host " - "
    Write-Host "###############################################################"
    Write-Host " - "

    set-location $env:SYSTEM_DEFAULTWORKINGDIRECTORY -Verbose
    git config credential.interactive never
    git config credential.authority NTLM
    git config user.name ""
    git config user.email ""

    git add .
    git commit -m "VSTS CI Version Update ***CI***"
    $errorMessage = git push origin head:$branch --porcelain 2>&1

    ##$errorMessage = git push "https://$env:SYSTEM_ACCESSTOKEN@github.com/PowershellFrameworkCollective/PowershellFrameworkCollective.github.io.git" head:$branch 2>&1
    if ($LASTEXITCODE -gt 0) { throw $errorMessage }
}
