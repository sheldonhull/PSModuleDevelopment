
function ConvertHashtableTo-Object
{
    [CmdletBinding()]
    Param([Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
        [hashtable]$ht
    )
    PROCESS
    {
        $results = @()

        $ht | % {
            $result = New-Object psobject;
            foreach ($key in $_.keys)
            {
                $result | Add-Member -MemberType NoteProperty -Name $key -Value $_[$key]
            }
            $results += $result;
        }
        return $results
    }
}