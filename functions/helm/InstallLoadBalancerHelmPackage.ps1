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
        [AllowEmptyString()]
        [string]
        $ExternalIP
        ,
        [Parameter(Mandatory = $true, HelpMessage="Set this if you want to put the external load balancer in a subnet")]
        [AllowEmptyString()]
        [string]
        $ExternalSubnet
        ,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $InternalIP
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $InternalSubnet
    )

    Write-Verbose 'InstallLoadBalancerHelmPackage: Starting'

    [string] $package = "nginx"
    [string] $packageInternal = "nginx-internal"
    [string] $ngniximageTag = "0.20.0"

    Write-Output "Removing old deployment"
    DeleteHelmPackage -package $package
    DeleteHelmPackage -package $packageInternal

    Start-Sleep -Seconds 5

    # nginx configuration: https://github.com/helm/charts/tree/master/stable/nginx-ingress#configuration

    if(![string]::IsNullOrWhiteSpace($ExternalSubnet)){
        Write-Verbose "Installing the external nginx load balancer into subnet $ExternalSubnet"
        helm install stable/nginx-ingress `
            --namespace "kube-system" `
            --name "$package" `
            --set controller.stats.enabled=true `
            --set controller.extraArgs.enable-ssl-passthrough=""  `
            --set controller.image.tag="$ngniximageTag" `
            --set-string controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"='"true"' `
            --set-string controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"='"'$ExternalSubnet'"' `
            --set controller.service.loadBalancerIP="$ExternalIP" `
            --set-string controller.service.labels."$($kubeGlobals.externalLoadBalancerLabel)"='"'$($kubeGlobals.externalLoadBalancerLabelValue)'"'
    }
    else {
        Write-Verbose "Installing the public nginx load balancer"
        helm install stable/nginx-ingress `
            --namespace "kube-system" `
            --name "$package" `
            --set controller.stats.enabled=true `
            --set controller.extraArgs.enable-ssl-passthrough=""  `
            --set controller.image.tag="$ngniximageTag" `
            --set controller.service.loadBalancerIP="$ExternalIP" `
            --set-string controller.service.labels."$($kubeGlobals.externalLoadBalancerLabel)"='"'$($kubeGlobals.externalLoadBalancerLabelValue)'"'
    }

    # setting values in helm: https://github.com/helm/helm/blob/master/docs/chart_best_practices/values.md
    # and https://github.com/helm/helm/blob/master/docs/using_helm.md
    # use "helm inspect values" to see values

    WaitForLoadBalancerIPByLabel -loadBalancerLabel $kubeGlobals.externalLoadBalancerLabel

    Write-Verbose "Installing the internal nginx load balancer"
    # NOTE: helm cannot handle spaces before or after "=" in --set command
    helm install stable/nginx-ingress `
        --namespace "kube-system" `
        --name "$packageInternal" `
        --set controller.image.tag="$ngniximageTag" `
        --set-string controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"='"true"' `
        --set-string controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"='"'$InternalSubnet'"' `
        --set controller.service.loadBalancerIP="$InternalIP" `
        --set-string controller.service.labels."$($kubeGlobals.internalLoadBalancerLabel)"='"'$($kubeGlobals.internalLoadBalancerLabelValue)'"'

    Write-Verbose 'InstallLoadBalancerHelmPackage: Done'
}

Export-ModuleMember -Function "InstallLoadBalancerHelmPackage"