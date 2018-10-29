<#
.SYNOPSIS
ShowLogsOfAllPodsInNameSpace

.DESCRIPTION
ShowLogsOfAllPodsInNameSpace

.INPUTS
ShowLogsOfAllPodsInNameSpace - The name of ShowLogsOfAllPodsInNameSpace

.OUTPUTS
None

.EXAMPLE
ShowLogsOfAllPodsInNameSpace

.EXAMPLE
ShowLogsOfAllPodsInNameSpace


#>
function ShowLogsOfAllPodsInNameSpace() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'ShowLogsOfAllPodsInNameSpace: Starting'

    Write-Host "showing logs (last 30 lines) in $namespace"
    $pods = $(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')
    foreach ($pod in $pods.Split(" ")) {
        Write-Host "=============== Pod: $pod ================="
        kubectl logs --tail=30 $pod -n $namespace
    }

    Write-Verbose 'ShowLogsOfAllPodsInNameSpace: Done'

}

Export-ModuleMember -Function 'ShowLogsOfAllPodsInNameSpace'