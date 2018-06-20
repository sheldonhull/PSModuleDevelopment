param(
    $env:BUILD_SOURCEBRANCHNAME = 'dev'
)

Write-Host "###############################################################"
Write-Host " - "
Write-Host "Importing Required modules"
Write-Host "  Importing PSFramework"
Import-Module PSFramework -Force
Write-Host "  Importing PSModuleDevelopment"
Import-Module PSModuleDevelopment -Force
Write-Host "  Importing PSUtil"
Import-Module PSUtil -Force
Write-Host "  Importing platyPS"
Import-Module -Name platyPS -Force
Write-Host "###############################################################"


$env:SYSTEM_DEFAULTWORKINGDIRECTORY = (($env:SYSTEM_DEFAULTWORKINGDIRECTORY|Resolve-Path -ea 0|Split-Path -Parent|Split-Path -Parent).Path, ($PSScriptRoot|Split-path -parent|Split-Path -Parent) -ne $null)[0]
$commandReferenceBasePath = "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\documentation\commands"
#get-command -module platyps | out-gridview -PassThru -Title 'Select Command to View Help' | get-help -showWindow

#region þnameþ
Write-Host "  Importing þnameþ" -ForegroundColor Green
$moduleName = "þnameþ"
Import-Module "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\$ModuleName\$ModuleName\$ModuleName.psd1" -force
$excludedCommands = @("New-PSFTeppCompletionResult")
Write-PSFMessage -Level Host -Message "Processing $moduleName"
Write-PSFMessage -Level Host -Message "  Creating list of commands to process"
$commands = Get-Command -Module $moduleName -CommandType Function, Cmdlet | Select-Object -ExpandProperty Name | Where-Object { $_ -notin $excludedCommands } | Sort-Object
Write-PSFMessage -Level Host -Message "  $($commands.Count) commands found"

Write-PSFMessage -Level Host -Message "  Creating markdown help files"
Remove-Item "$($commandReferenceBasePath)\$($moduleName)" -Recurse -ErrorAction Ignore
$null = New-Item "$($commandReferenceBasePath)\$($moduleName)" -ItemType Directory -force
$null = New-MarkdownHelp -Command $commands -OutputFolder "$($commandReferenceBasePath)\$($moduleName)"
#Get-Help -module 'þnameþ' -Category HelpFile

Write-PSFMessage -Level Host -Message "  Creating About Markdown Help"
remove-item "$($commandReferenceBasePath)\about_$($moduleName).md" -ErrorAction SilentlyContinue

$AboutFile = (Get-ChildItem -Path  "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\$ModuleName" -Filter "about_$ModuleName.help.txt" -Recurse).FullName
Write-PSFMessage -Level Host -Message "  Creating index file from about $AboutFile"
Set-Content -Path "$($commandReferenceBasePath)\$($moduleName).md" -Value (Get-Content $AboutFile -raw) -Encoding UTF8
Write-PSFMessage -Level Host -Message "  Creating index entries for commands and appending to about_$ModuleName.md"
Add-Content -Path "$($commandReferenceBasePath)\$($moduleName).md" -Value @"

## $moduleName Command Reference

"@ -Encoding Ascii

foreach ($command in $commands) {
    Add-Content -Path "$($commandReferenceBasePath)\$($moduleName).md" -Value " - [$command]($($moduleName)/$command.md)"
}
Write-PSFMessage -Level Host -Message "Finished processing $moduleName"
#endregion þnameþ

Write-Host " - "
Write-Host "###############################################################"
Write-Host " - "

$branch = $env:BUILD_SOURCEBRANCHNAME
Write-PSFMessage -Level Host -Message "Applying documentation to repository"
set-location $env:SYSTEM_DEFAULTWORKINGDIRECTORY -Verbose
git config user.name ""
git config user.email ""
git add documentation
git commit -m "VSTS Documentation Update ***NO_CI***"
$errorMessage = git push origin head:$branch 2>&1
if ($LASTEXITCODE -gt 0) { throw $errorMessage }