<#
.SYNOPSIS
DeleteAllSecretsInNamespace

.DESCRIPTION
DeleteAllSecretsInNamespace

.INPUTS
DeleteAllSecretsInNamespace - The name of DeleteAllSecretsInNamespace

.OUTPUTS
None

.EXAMPLE
DeleteAllSecretsInNamespace

.EXAMPLE
DeleteAllSecretsInNamespace


#>
function DeleteAllSecretsInNamespace()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'DeleteAllSecretsInNamespace: Starting'

    kubectl delete --all 'secrets' --namespace=$namespace --ignore-not-found=true

    Write-Verbose 'DeleteAllSecretsInNamespace: Done'

}

Export-ModuleMember -Function 'DeleteAllSecretsInNamespace'