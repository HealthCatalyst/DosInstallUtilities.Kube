<#
.SYNOPSIS
KubeGlobals

.DESCRIPTION
KubeGlobals

.INPUTS
KubeGlobals - The name of KubeGlobals

.OUTPUTS
None

.EXAMPLE
KubeGlobals

.EXAMPLE
KubeGlobals


#>
function KubeGlobals()
{
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'KubeGlobals: Starting'
    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    Write-Verbose 'KubeGlobals: Done'

}

[hashtable] $kubeGlobals = @{
    realtimePackageUrl = "https://raw.githubusercontent.com/HealthCatalyst/helm.realtime/master/fabricrealtime-1.1.0.tgz"
    nlpPackageUrl = "https://raw.githubusercontent.com/HealthCatalyst/helm.nlp/master/fabricnlp-0.1.0.tgz"
    certificateGeneratorPackageUrl = "https://raw.githubusercontent.com/HealthCatalyst/helm.certificategenerator/master/certificategenerator-0.1.0.tgz"
    helmInstallUrl = "https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-windows-amd64.zip"
    externalLoadBalancerLabel = "k8s-app-external"
    externalLoadBalancerLabelValue = "nginx"
    internalLoadBalancerLabel = "k8s-app-internal"
    internalLoadBalancerLabelValue = "nginx"
    internalLoadBalancerLabelSelector = "k8s-app-internal=nginx"
    externalLoadBalancerLabelSelector = "k8s-app-external=nginx"
}

Export-ModuleMember -Variable kubeGlobals