<#
.SYNOPSIS
ShowStatusOfCluster

.DESCRIPTION
ShowStatusOfCluster

.INPUTS
ShowStatusOfCluster - The name of ShowStatusOfCluster

.OUTPUTS
None

.EXAMPLE
ShowStatusOfCluster

.EXAMPLE
ShowStatusOfCluster


#>
function ShowStatusOfCluster()
{
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'ShowStatusOfCluster: Starting'
    Write-Information -MessageData "Current cluster: $(kubectl config current-context)"
    kubectl version --short
    kubectl get "deployments,pods,services,nodes,ingress" --namespace=kube-system -o wide
    Write-Verbose 'ShowStatusOfCluster: Done'

}

Export-ModuleMember -Function 'ShowStatusOfCluster'