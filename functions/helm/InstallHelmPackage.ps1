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
    )

    Write-Verbose "InstallHelmPackage: Starting $package"

    Write-Output "Removing old deployment for $package"
    helm del --purge $package

    Start-Sleep -Seconds 5

    # kubectl delete 'pods,services,configMaps,deployments,ingress' -l k8s-traefik=traefik -n $namespace --ignore-not-found=true

    # Start-Sleep -Seconds 5

    # https://docs.helm.sh/developing_charts/

    Write-Output "Install helm package from $packageUrl"
    helm install $packageUrl `
        --name $package `
        --namespace $namespace `
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