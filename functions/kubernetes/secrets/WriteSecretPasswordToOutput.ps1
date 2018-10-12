<#
.SYNOPSIS
WriteSecretPasswordToOutput

.DESCRIPTION
WriteSecretPasswordToOutput

.INPUTS
WriteSecretPasswordToOutput - The name of WriteSecretPasswordToOutput

.OUTPUTS
None

.EXAMPLE
WriteSecretPasswordToOutput

.EXAMPLE
WriteSecretPasswordToOutput


#>
function WriteSecretPasswordToOutput() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $secretname
    )

    Write-Verbose 'WriteSecretPasswordToOutput: Starting'
    $secretvalue = $(ReadSecretPassword -secretname $secretname -namespace $namespace)
    Write-Host "$secretname = $secretvalue"
    # Write-Host "To recreate the secret:"
    # Write-Host "kubectl create secret generic $secretname --namespace=$namespace --from-literal=password=$secretvalue"

    Write-Verbose 'WriteSecretPasswordToOutput: Done'

}

Export-ModuleMember -Function 'WriteSecretPasswordToOutput'