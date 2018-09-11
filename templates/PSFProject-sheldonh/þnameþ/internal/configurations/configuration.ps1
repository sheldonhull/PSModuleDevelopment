<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'þnameþ' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"

Register-PSFConfigValidation -Name "CredentialType" -ScriptBlock  {
    param($val)
    [pscustomobject]@{
        Success = ($val.GetType().name -match 'PSCredential' -or $val -eq $null) -eq $true
        Value = $val
        Message = "Validate that credential type is set to null or else a [pscredential] object"
    }
}
#>