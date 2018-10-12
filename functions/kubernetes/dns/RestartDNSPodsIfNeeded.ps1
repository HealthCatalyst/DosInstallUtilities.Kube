<#
.SYNOPSIS
RestartDNSPodsIfNeeded

.DESCRIPTION
RestartDNSPodsIfNeeded

.INPUTS
RestartDNSPodsIfNeeded - The name of RestartDNSPodsIfNeeded

.OUTPUTS
None

.EXAMPLE
RestartDNSPodsIfNeeded

.EXAMPLE
RestartDNSPodsIfNeeded


#>
function RestartDNSPodsIfNeeded() {
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'RestartDNSPodsIfNeeded: Starting'
    kubectl get pods -l k8s-app=kube-dns -n kube-system -o wide
    Do { $confirmation = Read-Host "Do you want to restart DNS pods? (y/n)"}
    while ([string]::IsNullOrWhiteSpace($confirmation))

    if ($confirmation -eq 'y') {
        $failedItems = kubectl get pods -l k8s-app=kube-dns -n kube-system -o jsonpath='{range.items[*]}{.metadata.name}{\"\n\"}{end}'
        ForEach ($line in $failedItems) {
            Write-Host "Deleting pod $line"
            kubectl delete pod $line -n kube-system
        }
    }
    Write-Verbose 'RestartDNSPodsIfNeeded: Done'

}

Export-ModuleMember -Function 'RestartDNSPodsIfNeeded'