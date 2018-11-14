<#
  .SYNOPSIS
  GetLoadBalancerIPs

  .DESCRIPTION
  GetLoadBalancerIPs

  .INPUTS
  GetLoadBalancerIPs - The name of GetLoadBalancerIPs

  .OUTPUTS
  None

  .EXAMPLE
  GetLoadBalancerIPs

  .EXAMPLE
  GetLoadBalancerIPs


#>
function GetLoadBalancerIPs() {
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'GetLoadBalancerIPs: Starting'
    [hashtable]$Return = @{}

    [string] $externalIP = $(WaitForLoadBalancerIPByLabel -loadBalancerLabel $kubeGlobals.externalLoadBalancerLabel).LoadBalancerIP

    [string] $internalIP = $(WaitForLoadBalancerIPByLabel -loadBalancerLabel $kubeGlobals.internalLoadBalancerLabel).LoadBalancerIP

    if ([string]::IsNullOrWhiteSpace($externalIP) -or [string]::IsNullOrWhiteSpace($internalIP)) {
        Write-Host "------- Kubernetes Events ------------"
        kubectl get events -n "kube-system" --sort-by=".metadata.creationTimestamp"
        Write-Host "------- End of Kubernetes Events ------------"
        # kubectl get events -n kube-system --sort-by='.metadata.creationTimestamp'  -o "go-template={{range .items}}{{.involvedObject.name}}{{'\t'}}{{.involvedObject.kind}}{{'\t'}}{{.message}}{{'\t'}}{{.reason}}{{'\t'}}{{.type}}{{'\t'}}{{.firstTimestamp}}{{'\n'}}{{end}}"
    }

    $Return.ExternalIP = $externalIP
    $Return.InternalIP = $internalIP

    Write-Verbose 'GetLoadBalancerIPs: Done'
    return $Return

}

Export-ModuleMember -Function "GetLoadBalancerIPs"