<#
  .SYNOPSIS
  InstallHelmPackage

  .DESCRIPTION
  InstallHelmPackage

  .INPUTS
  InstallHelmPackage - The name of InstallHelmPackage

  .OUTPUTS
  None

  .EXAMPLE
  InstallHelmPackage

  .EXAMPLE
  InstallHelmPackage


#>
function InstallHelmPackage() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $package
        ,
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

    Write-Verbose "InstallHelmPackage: Starting $package"

    Write-Output "Removing old deployment for $package"
    helm del --purge $package

    Start-Sleep -Seconds 5

    # kubectl delete 'pods,services,configMaps,deployments,ingress' -l k8s-traefik=traefik -n $namespace --ignore-not-found=true

    # Start-Sleep -Seconds 5

    Write-Output "Install helm package from $packageUrl"
    helm install $packageUrl `
        --name $package `
        --namespace $namespace `
        --set ssl=$Ssl `
        --set ExternalIP="$ExternalIP" `
        --set InternalIP="$InternalIP" `
        --set ExternalSubnet="$ExternalSubnet" `
        --set InternalSubnet="$InternalSubnet" `
        --set ingressInternalType="$IngressInternalType" `
        --set ingressExternalType="$IngressExternalType" `
        --debug

    Write-Verbose "Listing packages"
    [string] $failedText = $(helm list --failed --output json)
    if (![string]::IsNullOrWhiteSpace($failedText)) {
        Write-Error "Helm package failed"
    }
    $(helm list)

    Write-Verbose "InstallHelmPackage: Done $package"
}

Export-ModuleMember -Function "InstallHelmPackage"