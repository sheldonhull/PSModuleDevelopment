$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandpath" -ForegroundColor Cyan
. (resolve-path "$PSScriptRoot\..\constants.ps1")
Import-Module (resolve-path "$PSScriptRoot\..\..\ps_modules\vststasksdk")  -Force -ArgumentList @{ NonInteractive = $true }

$script:TFSScriptPath = Resolve-Path "..\..\TFS-þnameþ.ps1"
if (!(Test-Path $script:TFSScriptPath -PathType Leaf ))
{
    throw "Cannot identify `$script:TFSScriptPath = $script:TFSScriptPath for testing."
}

Describe 'þnameþ through VSTS sdk' -Tags 'Integration', 'TFS' {

    BeforeAll {
        $script:PesterWorkingDirectory = "TestDrive:\$commandname"
    }
    BeforeEach {
        Remove-Item $script:PesterWorkingDirectory -Recurse -ErrorAction SilentlyContinue -Verbose:$false
    }
    AfterAll {
        Remove-Item $script:PesterWorkingDirectory -Recurse -ErrorAction SilentlyContinue -Verbose:$false
    }

    Context 'running TFS-þnameþ' {
        It 'runs successfully' {

            # Equivalent of Parameter Values/Fields in Task
            $ENV:INPUT_Param1 = 'Val1'
            $ENV:INPUT_Param2 = 'Val2'
            $ENV:INPUT_Param3 = 'Val3'

            # Build Equivalent Variables to Import
            Set-VstsTaskVariable -Name BypassPsDepend -Value $true
            Write-VstsSetVariable -Name BypassPsDepend -value $true

            Invoke-VstsTaskScript -ScriptBlock {
                $ENV:BypassPsDepend = $true
                . $script:TFSScriptPath
            }
        }
    }

}