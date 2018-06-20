<#
.description
þdescription of functionþ

.example
# To Return
þFunctionNameþ


#>
function þFunctionNameþ
{
    [CmdletBinding()]
    Param (

    )

    begin
    {
        $StopWatch = [diagnostics.stopwatch]::StartNew()
        Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: starting" -f $StopWatch.Elapsed, 'þFunctionNameþ')
    }
    process
    {
        try
        {
            $StopwatchProcess = [diagnostics.stopwatch]::StartNew()
            Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: process start" -f $StopwatchProcess.Elapsed, 'þFunctionNameþ')

            Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: process end" -f $StopwatchProcess.Elapsed, 'þFunctionNameþ')
        }
        catch
        {
            Write-PSFMessage -Level Warning -Message ( "{0:hh\:mm\:ss\.fff} {1}: error experienced" -f $StopwatchProcess.Elapsed, 'þFunctionNameþ') -Exception $_.Exception
            throw
        }
    }
    end
    {
        Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: finished" -f $StopWatch.Elapsed, 'þFunctionNameþ')
        $StopWatch.Stop()
    }
}
