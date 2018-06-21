<#
.description
    updates the psd1 version number and the task.json version number if exists based on version.txt to simplify version updating.
.Parameter ModuleDirectory
    Directory of the module
.Parameter ModuleName
    Default: Leaf Name from the Module Directory passed in
    Name of the module. Optional

.example
    PS> Update-Version -ModuleDirectory (Split-path .\ -Parent)
    Run update on module version.

#>
function Update-Version
{
    [CmdletBinding()]
    [OutputType([PsObject[]])]
    Param (
        [Parameter(mandatory, ValueFromPipeline)][PsObject[]]$ModuleDirectory
        , [Parameter()]$ModuleName #don't cast as string to avoid issues with isnull
        , [Parameter()]$ReleaseNotes
    )
    begin
    {
        $StopWatch = [diagnostics.stopwatch]::StartNew()
        Write-PSFMessage -Level Verbose -Message ( "{0:hh\:mm\:ss\.fff} {1}: starting" -f $StopWatch.Elapsed, 'Update-Version')
        if (@(Get-Module -name 'newtonsoft.json' -listAvailable).count -eq 0)
        {
            Install-Module -Name newtonsoft.json -scope CurrentUser
        }
    }
    process
    {
        $ModuleDirectory | ForEach-Object {
            $m = $_
            try
            {
                $ModuleName = ($ModuleName, ($m | Split-Path -Leaf) -ne $null )[0]
                Write-PSFMessage -Level Verbose -Message "Module Name identified as: $ModuleName"
                $TaskJsonFullName = (Get-ChildItem -Path $m -filter 'task.json').FullName
                $PSD1FullName = (Get-ChildItem -Path $m -filter "$ModuleName.psd1").FullName
                $VersionXmlFullName = "$m\version.xml"
                Write-PSFMessage -Level Verbose -message "$(Get-Variable ModuleName,ModuleDirectory,TaskJsonFullName,PSD1FullName,VersionXmlFullName -ErrorAction SilentlyContinue| format-table -autosize | out-string)"
                [string]$ReleaseNotes = ("release updated {0}{1}" -f (get-date -Format 'yyyy-MM-dd hh:mm:ss') , ";$ReleaseNotes")
                $StopwatchProcess = [diagnostics.stopwatch]::StartNew()
                Write-PSFMessage -Level Verbose -Message ( "{0:hh\:mm\:ss\.fff} {1}: process start" -f $StopwatchProcess.Elapsed, 'Update-Version')
                if (![io.file]::Exists($VersionXmlFullName))
                {
                    [Version]$CurrentVersion = [version]::new(1, 0, 1)
                    $CurrentVersion | Export-Clixml -path "$m\version.xml"
                }
                else
                {
                    [version]$CurrentVersion = Import-CliXml $VersionXmlFullName
                    Write-PSFMessage -Level Verbose -Message  "$ModuleName  - $CurrentVersion"
                    [version]$NewVersion = ( [version]::new(
                            $CurrentVersion.Major
                            , $CurrentVersion.Minor
                            , ($CurrentVersion.Build + 1)
                        ))
                    [version]$NewVersion | Export-Clixml -path $VersionXmlFullName -force

                }

                if ($TaskJsonFullName)
                {
                    Write-PSFMessage -Level Verbose -Message  "Updating $TaskJsonFullName with new version $NewVersion"
                    $task = Get-Content -Path $TaskJsonFullName -raw | ConvertFrom-JsonNewtonsoft
                    $task.Version.Major = $NewVersion.Major
                    $task.Version.Minor = $NewVersion.Minor
                    $task.Version.Patch = $NewVersion.Build
                    $task.ReleaseNotes = $ReleaseNotes
                    $task | ConvertTo-JsonNewtonsoft | set-content $TaskJsonFullName -Encoding UTF8
                    Write-PSFMessage -Level Verbose -Message  "$ModuleName -- task.json --$($task.Version) vs $NewVersion"

                }
                if ($PSD1FullName)
                {
                    #[version]$ModuleCurrentVersion = '1.0.0.1'
                    $moduleInformation = Import-PowershellDataFile $PSD1FullName -Verbose:$false | ConvertHashtableTo-Object
                    #[Version]$ModuleOriginalVersion = [version]::parse($Moduleinformation.ModuleVersion)
                    #[version]::TryParse(('{0}.{1}.{2}.0' -f $moduleInformation.Version.Major, $moduleInformation.Version.Minor, $moduleInformation.Version.Patch), [ref]$ModuleCurrentVersion)
                    try
                    {
                        $SplatMe = @{
                            Path          = $PSD1FullName
                            ModuleVersion = [Version]$NewVersion
                            ReleaseNotes  = $ReleaseNotes
                            ErrorAction   = 'continue'
                        }
                        Update-ModuleManifest @SplatMe
                        Write-PSFMessage -Level Verbose -Message  "$ModuleName -- psd1 --$($Moduleinformation.ModuleVersion) vs $NewVersion"
                    }
                    catch
                    {
                        Write-PSFMessage -Level Warning -Message  "FAILED: $ModuleName -- psd1 --$($Moduleinformation.ModuleVersion) vs $NewVersion" -Exception $_.Exception
                    }
                }

                [pscustomobject]@{
                    ModuleName         = $ModuleName
                    ModuleVersion      = $NewVersion
                    ModuleDirectory    = $m
                    PSD1FullName       = $PSD1FullName
                    TaskJsonFullName   = $TaskJsonFullName
                    VersionXmlFullName = $VersionXmlFullName
                }


                Write-PSFMessage -Level Verbose -Message ( "{0:hh\:mm\:ss\.fff} {1}: process end" -f $StopwatchProcess.Elapsed, 'Update-Version')
            }
            catch
            {
                Write-PSFMessage -Level Warning -Message ( "{0:hh\:mm\:ss\.fff} {1}: error experienced" -f $StopwatchProcess.Elapsed, 'Update-Version') -Exception $_.Exception
                throw
            }
        }
    }
    end
    {
        Write-PSFMessage -Level Verbose -Message ( "{0:hh\:mm\:ss\.fff} {1}: finished" -f $StopWatch.Elapsed, 'Update-Version')
        $StopWatch.Stop()
    }
}
