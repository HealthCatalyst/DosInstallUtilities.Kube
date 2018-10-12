<#
.SYNOPSIS
ShowStatusOfAllPodsInNameSpace

.DESCRIPTION
ShowStatusOfAllPodsInNameSpace

.INPUTS
ShowStatusOfAllPodsInNameSpace - The name of ShowStatusOfAllPodsInNameSpace

.OUTPUTS
None

.EXAMPLE
ShowStatusOfAllPodsInNameSpace

.EXAMPLE
ShowStatusOfAllPodsInNameSpace


#>
function ShowStatusOfAllPodsInNameSpace() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'ShowStatusOfAllPodsInNameSpace: Starting'
    Write-Information -MessageData "showing status of pods in $namespace"
    $podsText = $(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')
    foreach ($pod in $podsText.Split(" ")) {
        Write-Information -MessageData "=============== Describe Pod: $pod ================="
        kubectl describe pods $pod -n $namespace
    }
    Write-Verbose 'ShowStatusOfAllPodsInNameSpace: Done'
}

Export-ModuleMember -Function 'ShowStatusOfAllPodsInNameSpace'