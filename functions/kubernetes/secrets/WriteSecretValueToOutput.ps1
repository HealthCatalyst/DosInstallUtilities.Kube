<#
.SYNOPSIS
WriteSecretValueToOutput

.DESCRIPTION
WriteSecretValueToOutput

.INPUTS
WriteSecretValueToOutput - The name of WriteSecretValueToOutput

.OUTPUTS
None

.EXAMPLE
WriteSecretValueToOutput

.EXAMPLE
WriteSecretValueToOutput


#>
function WriteSecretValueToOutput() {
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

    Write-Verbose 'WriteSecretValueToOutput: Starting'

    $secretvalue = $(ReadSecretValue -secretname $secretname -namespace $namespace)
    Write-Host "$secretname = $secretvalue"
    # Write-Host "To recreate the secret:"
    # Write-Host "kubectl create secret generic $secretname --namespace=$namespace --from-literal=value=$secretvalue"
    Write-Verbose 'WriteSecretValueToOutput: Done'

}

Export-ModuleMember -Function 'WriteSecretValueToOutput'