<#
.SYNOPSIS
GeneratePassword

.DESCRIPTION
GeneratePassword

.INPUTS
GeneratePassword - The name of GeneratePassword

.OUTPUTS
None

.EXAMPLE
GeneratePassword

.EXAMPLE
GeneratePassword


#>
function GeneratePassword()
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
    )

    Write-Verbose 'GeneratePassword: Starting'

    $Length = 3
    $set1 = "abcdefghijklmnopqrstuvwxyz".ToCharArray()
    $set2 = "0123456789".ToCharArray()
    $set3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray()
    $set4 = "!.*@".ToCharArray()
    $result = ""
    for ($x = 0; $x -lt $Length; $x++) {
        $result += $set1 | Get-Random
        $result += $set2 | Get-Random
        $result += $set3 | Get-Random
        $result += $set4 | Get-Random
    }
    return $result

    Write-Verbose 'GeneratePassword: Done'

}

Export-ModuleMember -Function 'GeneratePassword'