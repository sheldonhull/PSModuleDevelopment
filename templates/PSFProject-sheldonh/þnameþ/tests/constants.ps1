write-host "Setting test constant values" -ForegroundColor Cyan
$LocalOverrideFile = 'C:\temp\constants\þnameþ-local-constants.ps1'
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
