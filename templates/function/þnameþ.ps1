<#
.description
þdescription of functionþ

.example
# To Return
þnameþ


#>
function þnameþ
{
    [CmdletBinding()]
    Param (

    )

    begin
    {
        $StopWatch = [diagnostics.stopwatch]::StartNew()
        Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: starting" -f $StopWatch.Elapsed, 'þnameþ')
    }
    process
    {
        try
        {
            $StopwatchProcess = [diagnostics.stopwatch]::StartNew()
            Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: process start" -f $StopwatchProcess.Elapsed, 'þnameþ')

            Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: process end" -f $StopwatchProcess.Elapsed, 'þnameþ')
        }
        catch
        {
            Write-PSFMessage -Level Warning -Message ( "{0:hh\:mm\:ss\.fff} {1}: error experienced" -f $StopwatchProcess.Elapsed, 'þnameþ') -Exception $_.Exception
            throw
        }
    }
    end
    {
        Write-PSFMessage -Level Output -Message ( "{0:hh\:mm\:ss\.fff} {1}: finished" -f $StopWatch.Elapsed, 'þnameþ')
        $StopWatch.Stop()
    }
}
