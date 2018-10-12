<#
.SYNOPSIS
SaveSecretPassword

.DESCRIPTION
SaveSecretPassword

.INPUTS
SaveSecretPassword - The name of SaveSecretPassword

.OUTPUTS
None

.EXAMPLE
SaveSecretPassword

.EXAMPLE
SaveSecretPassword


#>
function SaveSecretPassword()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $secretname
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $value
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'SaveSecretPassword: Starting'

    SaveSecretValue -namespace $namespace -secretname $secretname -valueName "password" -value $value

    Write-Verbose 'SaveSecretPassword: Done'
}

Export-ModuleMember -Function 'SaveSecretPassword'