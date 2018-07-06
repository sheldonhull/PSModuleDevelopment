<#
.description
þdescription of functionþ

.example
# To Return
þnameþ


#>



[cmdletbinding()]
param(
    # Use SDK to get parameter values, or enviromental values. Cannot pass via param block at this time.
)

$TFSStopWatch = [diagnostics.stopwatch]::StartNew()
Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: starting" -f $TFSStopwatch.Elapsed, 'TFS-þnameþ')

#Import-Module -Name "$ModuleDirectory\ps_modules\VstsTaskSdk" -Verbose  -ArgumentList @{ NonInteractive = $true }

Import-Module -Name "$PSScriptRoot\þnameþ.psd1" -force

[string]$SqlInstance   = Get-PSFConfigValue -FullName 'þnameþ.SqlInstance' -FallBack (Get-VstsInput -Name SqlInstance   -verbose)
[string]$Database      = Get-PSFConfigValue -FullName 'þnameþ.Database' -FallBack (Get-VstsInput -Name Database -verbose)

Write-PSFMessage -Level Debug -Message "---þnameþ current variables---`n$(Get-PSFConfig -Fullname 'þnameþ.*' | Format-Table -AutoSize -Wrap | Out-String)"
try
{
    $TFSStopwatchProcess = [diagnostics.stopwatch]::StartNew()
    Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: task start" -f $TFSStopwatchProcess.Elapsed, 'TFS-þnameþ')

    #TASKS HERE
    Set-PSFConfig -FullName 'þnameþ.Output.' -Value '' -Initialize -Validation 'string' -Handler { } -Description "Output results" -PassThru -Verbose | Register-PSFConfig -Scope FileSystem -Verbose


    Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: task end" -f $TFSStopwatchProcess.Elapsed, 'TFS-þnameþ')
}
catch
{
    Write-PSFMessage -Level Warning -Message ( "{0:hh\:mm\:ss\.fff} {1}: error experienced" -f $TFSStopwatchProcess.Elapsed, 'TFS-þnameþ') -Exception $_.Exception
    throw
}



Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: finished" -f $TFSStopwatch.Elapsed, 'TFS-þnameþ')
$TFSStopwatch.Stop()