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

    Write-Verbose 'InstallStackInKubernetes: Starting'

    [hashtable]$Return = @{}

    if ([string]::IsNullOrWhiteSpace($(kubectl get namespace $namespace --ignore-not-found=true))) {
        Write-Information -MessageData "namespace $namespace does not exist so creating it"
        kubectl create namespace $namespace
    }

    Write-Information -MessageData "Installing stack $($config.name) version $($config.version) from $configpath"

    foreach ($secret in $($config.secrets.password)) {
        GenerateSecretPassword -secretname "$secret" -namespace "$namespace"
    }
    foreach ($secret in $($config.secrets.value)) {
        # AskForSecretValue -secretname "$secret" -prompt "Client Certificate hostname" -namespace "$namespace"
        if ($secret -is [String]) {
            AskForSecretValue -secretname "$secret" -prompt "Client Certificate hostname" -namespace "$namespace"
        }
        else {
            $sourceSecretName = $($secret.valueFromSecret.name)
            $sourceSecretNamespace = $($secret.valueFromSecret.namespace)
            $value = ReadSecretValue -secretname $sourceSecretName -namespace $sourceSecretNamespace
            Write-Information -MessageData "Setting secret [$($secret.name)] to secret [$sourceSecretName] in namespace [$sourceSecretNamespace] with value [$value]"
            SaveSecretValue -secretname "$($secret.name)" -valueName "value" -value $value -namespace "$namespace"
        }
    }

    if ($namespace -ne "kube-system") {
        CleanOutNamespace -namespace $namespace
    }

    InstallHelmPackage  -namespace $namespace `
        -package $package `
        -packageUrl $packageUrl

    Write-Verbose 'InstallLoadBalancerHelmPackage: Done'

    WaitForPodsInNamespace -namespace $namespace -interval 5 -Verbose

    # read tcp ports and update ngnix with those ports
    SetTcpPortsForStack -namespace $namespace

    Write-Verbose 'InstallStackInKubernetes: Done'
    return $Return
}

Export-ModuleMember -Function "InstallStackInKubernetes"