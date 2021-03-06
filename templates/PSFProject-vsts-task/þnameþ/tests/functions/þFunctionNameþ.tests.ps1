$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandpath" -ForegroundColor Cyan
. (resolve-path "$PSScriptRoot\..\constants.ps1")

Describe 'þFunctionNameþ' -Tags 'Integration' {

    BeforeAll {
        $script:PesterWorkingDirectory = "TestDrive:\$commandname"
    }
    BeforeEach {
        Remove-Item $script:PesterWorkingDirectory -Recurse -ErrorAction SilentlyContinue -Verbose:$false
    }
    AfterAll {
        Remove-Item $script:PesterWorkingDirectory -Recurse -ErrorAction SilentlyContinue -Verbose:$false
    }

    Context 'runs þFunctionNameþ' {
        It 'it throws þFunctionNameþ when no arguments passed in' {
            {þFunctionNameþ} | Should -Throw
        }
    }
}