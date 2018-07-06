# List of forbidden commands
$global:BannedCommands = @(
    'Write-Host',
    'Write-Verbose',
    'Write-Warning',
    'Write-Error',
    'Write-Output',
    'Write-Information',
    'Write-Debug'
)

<#
    Contains list of exceptions for banned cmdlets.
    Insert the file names of files that may contain them.

    Example:
    "Write-Host"  = @('Write-PSFHostColor.ps1','Write-PSFMessage.ps1')
#>
$global:MayContainCommand = @{
    "Write-Host"        = @('preimport.ps1')
    "Write-Verbose"     = @('preimport.ps1')
    "Write-Warning"     = @('preimport.ps1')
    "Write-Error"       = @('preimport.ps1')
    "Write-Output"      = @()
    "Write-Information" = @()
    "Write-Debug"       = @('preimport.ps1')
}