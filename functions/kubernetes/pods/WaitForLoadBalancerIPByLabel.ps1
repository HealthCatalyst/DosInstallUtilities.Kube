<#
.SYNOPSIS
WaitForLoadBalancerIPByLabel

.DESCRIPTION
WaitForLoadBalancerIPByLabel

.INPUTS
WaitForLoadBalancerIPByLabel - The name of WaitForLoadBalancerIPByLabel

.OUTPUTS
None

.EXAMPLE
WaitForLoadBalancerIPByLabel

.EXAMPLE
WaitForLoadBalancerIPByLabel


#>
function WaitForLoadBalancerIPByLabel()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $loadBalancerLabel
    )

    Write-Verbose "WaitForLoadBalancerIPByLabel: Starting ($loadBalancerLabel)"
    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    [hashtable]$Return = @{}

    [string] $loadBalancerIP = $(kubectl get svc -l $loadBalancerLabel -n "kube-system" -o jsonpath='{.items[].status.loadBalancer.ingress[].ip}')

    [DateTime] $startDate = Get-Date
    [int] $timeoutInMinutes = 10
    [int] $counter = 0
    if([string]::IsNullOrWhiteSpace($loadBalancerIP)){
        Write-Host "Waiting for IP to get assigned to the load balancer: $loadBalancerLabel (Note: It can take upto 5 minutes for Azure to finish creating the load balancer)"
        Do {
            $counter = $counter + 1
            [string] $loadBalancerIP = $(kubectl get svc -l $loadBalancerLabel -n "kube-system" -o jsonpath='{.items[].status.loadBalancer.ingress[].ip}')
            if (!$loadBalancerIP) {
                Write-Host -NoNewLine "${counter}0 "
                Start-Sleep -Seconds 10
            }
        }
        while ([string]::IsNullOrWhiteSpace($loadBalancerIP) -and ($startDate.AddMinutes($timeoutInMinutes) -gt (Get-Date)))

        if (![string]::IsNullOrWhiteSpace($loadBalancerIP)) {
            Write-Host " (Found: $loadBalancerIP)"
        }
        else {
            Write-Host " (Not Found)"
        }
    }
    Write-Verbose "Load Balancer IP: $loadBalancerIP"

    Write-Verbose 'WaitForLoadBalancerIPByLabel: Done'

    $Return.LoadBalancerIP = $loadBalancerIP

    return $Return
}

Export-ModuleMember -Function 'WaitForLoadBalancerIPByLabel'