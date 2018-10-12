<#
.SYNOPSIS
CreateNamespaceIfNotExists

.DESCRIPTION
CreateNamespaceIfNotExists

.INPUTS
CreateNamespaceIfNotExists - The name of CreateNamespaceIfNotExists

.OUTPUTS
None

.EXAMPLE
CreateNamespaceIfNotExists

.EXAMPLE
CreateNamespaceIfNotExists


#>
function CreateNamespaceIfNotExists() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'CreateNamespaceIfNotExists: Starting'
    [hashtable]$Return = @{}

    if ([string]::IsNullOrWhiteSpace($(kubectl get namespace $namespace --ignore-not-found=true))) {
        Write-Host "Creating namespace: $namespace"
        kubectl create namespace $namespace
    }
    Write-Verbose 'CreateNamespaceIfNotExists: Done'
    return $Return
}

Export-ModuleMember -Function 'CreateNamespaceIfNotExists'