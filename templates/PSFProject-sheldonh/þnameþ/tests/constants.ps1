write-host "Setting test constant values" -ForegroundColor Cyan
$LocalOverrideFile = 'C:\temp\constants\þnameþ-local-constants.ps1'

$script:PesterTestDatabaseBackup = Join-Path $PSScriptRoot 'data\BACKUPFILE.bak'
$script:PesterSqlLogin = 'PesterTester' # this is hard coded in the Sql Files.
$QueryFile_CreateTestUser = Join-Path $PSScriptRoot 'data\CreateTestUser.sql'
$QueryFile_DropTestUser = Join-Path $PSScriptRoot 'data\DropTestUser.sql'
$QueryFile_MakeMeAdmin = Join-Path $PSScriptRoot 'data\MakeMeAdmin.sql'


<#
.Description
    Add test user to sql instance if doesn't exist. For SQL authentication testing.
.Parameter Database
    Parameter of Database to add the user to. Bypass adding ae user if in master
#>
function Add-TestUser
{
    [cmdletbinding()]
    param([Parameter()]$Database ='master')
    $cred = Get-PSFConfigValue 'þnameþ.Credential'
    Invoke-DbaSqlQuery -SqlInstance $script:SqlInstance -Database $Database -File $QueryFile_CreateTestUser -SqlParameters @{InputSqlLogin = $script:PesterSqlLogin; InputSqlLoginPassword = $cred.GetNetworkCredential().Password} -MessagesToOutput
    if($database -ne 'master')
    {
        Invoke-DbaSqlQuery -SqlInstance $script:SqlInstance -Database $Database -File $QueryFile_MakeMeAdmin -SqlParameters @{InputSqlLogin = $script:PesterSqlLogin} -MessagesToOutput
    }
}

<#
.Description
    Cleanup test user account from server, by default will just be sql login, but can override with database and remove database name. Since dropping test database, shouldn't need to actually run after each database creation.
.Parameter Database
    Default: Master
    Else provide your specific database.
#>
function Remove-TestUser
{
    [cmdletbinding()]
    param($Database = 'master')
    Invoke-DbaSqlQuery -SqlInstance $script:SqlInstance -Database $Database -File $QueryFile_DropTestUser -SqlParameters @{InputSqlLogin = $script:PesterSqlLogin} -MessagesToOutput
}


<#
Continue with constants
#>

if (Test-Path $LocalOverrideFile -PathType Leaf)
{
    write-host "Using Local Constants file: $LocalOverrideFile" -ForegroundColor Cyan
    . $LocalOverrideFile
}
else
{
    $script:SqlInstance = (Set-PSFConfig -Fullname 'þnameþ.SqlInstance'  -value 'localhost'  -PassThru).value
    $script:Database = (Set-PSFConfig -Fullname 'þnameþ.Database' -value ''               -PassThru).value
}
