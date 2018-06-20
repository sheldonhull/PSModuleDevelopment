# Local Overrides. Place in C:\temp\constants for it to override default in project

$script:SqlInstance = (Set-PSFConfig -Fullname 'þnameþ.SqlInstance'  -value '' -verbose:$true -PassThru).value
$script:Database = (Set-PSFConfig -Fullname 'þnameþ.Database'     -value '' -verbose:$true -PassThru).value

Set-PSFConfig -Fullname 'þnameþ.Credential' -Value ([pscredential]::new('sa', ('SqlDevTestLoginPass'| ConvertTo-SecureString -Force -AsPlainText))) -verbose:$true
if ($ENV:VerifiedConnection -eq $false) {
    try {
        Test-DbaConnection -SqlInstance $script:SqlInstance -SqlCredential (get-psfconfigvalue 'þnameþ.Credential') -EnableException
    }
    catch {
        Write-PSFMessage -Level Warning -Message "Cannot connect to sql instance, aborting test"
        throw

    }
    Test-DbaValidLogin -sqlinstance $script:SqlInstance -SqlCredential (get-psfconfigvalue 'þnameþ.Credential') -login 'sa'
    Write-PSFMessage -Level Host -Message "Confirmed connection to my test instance: $script:SqlInstance"
    $ENV:VerifiedConnection = $true
}
else {
    Write-PSFMessage -Level Host -Message "... already verified sqlinstance connection, bypassing"
}