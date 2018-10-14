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
        [ValidateNotNullOrEmpty()]
        [string]
        $packageUrl
        ,
        [Parameter(Mandatory = $true)]
        [bool]
        $Ssl
        ,
        [Parameter(Mandatory = $true)]
        [string]
        $ExternalIP
        ,
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]
        $InternalIP
        ,
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]
        $ExternalSubnet
        ,
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]
        $InternalSubnet
        ,
        [Parameter(Mandatory = $true)]
        [string]
        $IngressInternalType
        ,
        [Parameter(Mandatory = $true)]
        [string]
        $IngressExternalType
    )

    Write-Verbose 'InstallLoadBalancerHelmPackage: Starting'

    [string] $package = "fabricloadbalancer"

    Write-Output "Removing old deployment"
    helm del --purge $package

    Start-Sleep -Seconds 5

    kubectl delete 'pods,services,configMaps,deployments,ingress' -l k8s-traefik=traefik -n kube-system --ignore-not-found=true

    Start-Sleep -Seconds 5

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