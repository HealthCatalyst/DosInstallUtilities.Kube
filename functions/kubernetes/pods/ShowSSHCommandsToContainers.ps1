<#
.SYNOPSIS
ShowSSHCommandsToContainers

.DESCRIPTION
ShowSSHCommandsToContainers

.INPUTS
ShowSSHCommandsToContainers - The name of ShowSSHCommandsToContainers

.OUTPUTS
None

.EXAMPLE
ShowSSHCommandsToContainers

.EXAMPLE
ShowSSHCommandsToContainers


#>
function ShowSSHCommandsToContainers() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'ShowSSHCommandsToContainers: Starting'
    $pods = $(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')
    foreach ($pod in $pods.Split(" ")) {
        Write-Host "kubectl exec -it $pod -n $namespace -- sh"
    }

    Write-Verbose 'ShowSSHCommandsToContainers: Done'

}

Export-ModuleMember -Function 'ShowSSHCommandsToContainers'