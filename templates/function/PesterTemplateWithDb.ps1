

$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")

Write-Host -Object "Running $PSCommandpath" -ForegroundColor Cyan
. (Join-path (($PSScriptRoot, '.\' -ne '')[0]) "constants.ps1")  #if running in interactive console, cd to folder and you can run this without error


Describe 'þNameþ' -Tags 'Integration' {

    BeforeAll {
        $script:PesterWorkingDirectory = Join-path ([System.IO.Path]::GetTempPath()) "pester-$commandname-$(Get-Date -Format 'yyyyMMdd-hhmmss')"

        <#
        $database = "$commandname_pester_$(Get-Random)"
        invoke-sqlcmd2 -sqlinstance $script:PesterSqlInstance -query "CREATE DATABASE [$database]" -verbose:$false
        #>
    }
    BeforeEach {
        Remove-Item $script:PesterWorkingDirectory -Recurse  -ErrorAction SilentlyContinue -Verbose:$false
    }
    AfterAll {
        Remove-Item $script:PesterWorkingDirectory -Recurse -Verbose -erroraction silentlycontinue
        <#
        invoke-sqlcmd2 -sqlinstance $script:PesterSqlInstance -query ("
        IF DB_ID('$database') IS NOT NULL
        begin
            print 'Dropping $Database'
            ALTER DATABASE [$database] SET SINGLE_USER WITH ROLLBACK immediate;
            DROP DATABASE [$database];
        end
        ")
        #>

    }

    Context 'running þNameþ' {
        It 'þItDescriptionþ' {
            {þNameþ} | Should -Not -Throw
        }
    }

}
