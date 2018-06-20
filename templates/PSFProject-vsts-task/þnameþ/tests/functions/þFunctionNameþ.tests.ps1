$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandpath" -ForegroundColor Cyan
. '..\constants.ps1'

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

    Context 'running þFunctionNameþ' {
        It 'þItDescriptionþ' {
            {þFunctionNameþ} | Should -Not -Throw
        }
    }

}