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

    [DateTime] $startDate = Get-Date
    [int] $timeoutInMinutes = 10
    [int] $counter = 0
    Write-Host "Waiting for IP to get assigned to the load balancer (Note: It can take upto 5 minutes for Azure to finish creating the load balancer)"
    Do {
        $counter = $counter + 1
        [string] $externalIP = $(kubectl get svc -l $globals.externalLoadBalancerLabel -n "kube-system" -o jsonpath='{.items[].status.loadBalancer.ingress[].ip}')
        if (!$externalIP) {
            Write-Host -NoNewLine "${counter}0 "
            Start-Sleep -Seconds 10
        }
    }
    while ([string]::IsNullOrWhiteSpace($externalIP) -and ($startDate.AddMinutes($timeoutInMinutes) -gt (Get-Date)))

    if (![string]::IsNullOrWhiteSpace($externalIP)) {
        Write-Host " (Found)"
    }
    else {
        Write-Host " (Not Found)"
    }
    Write-Verbose "External IP: $externalIP"

    $counter = 0
    Write-Host "Waiting for IP to get assigned to the internal load balancer (Note: It can take upto 5 minutes for Azure to finish creating the load balancer)"
    Do {
        $counter = $counter + 1
        [string] $internalIP = $(kubectl get svc -l $globals.internalLoadBalancerLabel -n kube-system -o jsonpath='{.items[].status.loadBalancer.ingress[].ip}')
        if (!$internalIP) {
            Write-Host -NoNewLine "${counter}0 "
            Start-Sleep -Seconds 10
        }
    }
    while ([string]::IsNullOrWhiteSpace($internalIP) -and ($startDate.AddMinutes($timeoutInMinutes) -gt (Get-Date)))
    if (![string]::IsNullOrWhiteSpace($internalIP)) {
        Write-Host " (Found)"
    }
    else {
        Write-Host " (Not Found)"
    }

    Write-Verbose "Internal IP: $internalIP"

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