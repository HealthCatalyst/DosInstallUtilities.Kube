<#
  .SYNOPSIS
  InstallLoadBalancerHelmPackage

  .DESCRIPTION
  InstallLoadBalancerHelmPackage

  .INPUTS
  InstallLoadBalancerHelmPackage - The name of InstallLoadBalancerHelmPackage

  .OUTPUTS
  None

  .EXAMPLE
  InstallLoadBalancerHelmPackage

  .EXAMPLE
  InstallLoadBalancerHelmPackage


#>
function InstallLoadBalancerHelmPackage() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $ExternalIP
    )

    Write-Verbose 'InstallLoadBalancerHelmPackage: Starting'

    [string] $package = "nginx"

    Write-Output "Removing old deployment"
    helm del --purge $package

    Start-Sleep -Seconds 5

    # install nginx
    helm install stable/nginx-ingress `
	--namespace "kube-system" `
	--name "nginx" `
    --set controller.service.loadBalancerIP="$ExternalIP"

    # InstallHelmPackage  -namespace "kube-system" `
    #     -package $package `
    #     -packageUrl $packageUrl `
    #     -Ssl $Ssl `
    #     -ExternalIP $ExternalIP `
    #     -InternalIP $InternalIP `
    #     -ExternalSubnet $ExternalSubnet `
    #     -InternalSubnet $InternalSubnet `
    #     -IngressInternalType $IngressInternalType `
    #     -IngressExternalType $IngressExternalType

    Write-Verbose 'InstallLoadBalancerHelmPackage: Done'
}

Export-ModuleMember -Function "InstallLoadBalancerHelmPackage"