<#
.SYNOPSIS
ReadSecretPassword

.DESCRIPTION
ReadSecretPassword

.INPUTS
ReadSecretPassword - The name of ReadSecretPassword

.OUTPUTS
None

.EXAMPLE
ReadSecretPassword

.EXAMPLE
ReadSecretPassword


#>
function ReadSecretPassword() {
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $secretname, [string]$namespace
    )

    Write-Verbose 'ReadSecretPassword: Starting'
    $Result = ReadSecretData -secretname $secretname -valueName "password" -namespace $namespace
    Write-Verbose 'ReadSecretPassword: Done'
    return $Result
}

Export-ModuleMember -Function 'ReadSecretPassword'