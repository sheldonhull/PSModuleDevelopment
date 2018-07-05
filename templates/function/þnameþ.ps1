<#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used only once in each topic.
.DESCRIPTION
    þdescription of functionþ
.PARAMETER Foo
    Description
.PARAMETER Foo
    Description
.PARAMETER Foo
    Description

.EXAMPLE
    PS> þFunctionNameþ
    Runs þFunctionNameþ

###### OPTIONAL ######
.LINK
    The name of a related topic. The value appears on the line below the ".LINK" keyword and must be preceded by a comment symbol # or included in the comment block.
.NOTES
    Additional information about the function or script.
.INPUTS
    The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.
.OUTPUTS
    The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.
.EXTERNALHELP
    Specifies an XML-based help file for the script or function.
###### ENDOPTIONAL ######

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
