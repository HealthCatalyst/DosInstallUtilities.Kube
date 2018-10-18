<#
  .SYNOPSIS
  InstallStackInKubernetes

  .DESCRIPTION
  InstallStackInKubernetes

  .INPUTS
  InstallStackInKubernetes - The name of InstallStackInKubernetes

  .OUTPUTS
  None

  .EXAMPLE
  InstallStackInKubernetes

  .EXAMPLE
  InstallStackInKubernetes


#>
function InstallStackInKubernetes() {
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

    Write-Verbose 'InstallStackInKubernetes: Starting'

    [hashtable]$Return = @{}

    if ([string]::IsNullOrWhiteSpace($(kubectl get namespace $namespace --ignore-not-found=true))) {
        Write-Information -MessageData "namespace $namespace does not exist so creating it"
        kubectl create namespace $namespace
    }

    Write-Information -MessageData "Installing stack $($config.name) version $($config.version) from $configpath"

    if ($namespace -ne "kube-system") {
        CleanOutNamespace -namespace $namespace
    }

    InstallHelmPackage  -namespace $namespace `
        -package $package `
        -packageUrl $packageUrl

    Write-Verbose 'InstallLoadBalancerHelmPackage: Done'

    WaitForPodsInNamespace -namespace $namespace -interval 5 -Verbose

    # read tcp ports and update ngnix with those ports
    SetTcpPortsForStack -namespace $namespace -Verbose

    Write-Verbose 'InstallStackInKubernetes: Done'
    return $Return
}

Export-ModuleMember -Function "InstallStackInKubernetes"