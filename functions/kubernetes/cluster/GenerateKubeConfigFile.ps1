<#
.SYNOPSIS
GenerateKubeConfigFile

.DESCRIPTION
GenerateKubeConfigFile

.INPUTS
GenerateKubeConfigFile - The name of GenerateKubeConfigFile

.OUTPUTS
None

.EXAMPLE
GenerateKubeConfigFile

.EXAMPLE
GenerateKubeConfigFile


#>
function GenerateKubeConfigFile() {
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'GenerateKubeConfigFile: Starting'
    [string] $user = $(Get-UserForDashboard)
    # https://kubernetes.io/docs/getting-started-guides/scratch/#preparing-credentials
    # https://stackoverflow.com/questions/47770676/how-to-create-a-kubectl-config-file-for-serviceaccount
    [string] $secretname = $(Get-SecretNameForDashboardUser).SecretName
    [string] $ca = $(Get-TokenForDashboardUser).Ca # ca doesn't use base64 encoding
    [string] $token = $(Get-TokenForDashboardUser).Token
    [string] $namespace = $(ReadSecretData -secretname "$secretname" -valueName "namespace" -namespace "kube-system")
    [string] $server = $(ReadSecretValue -secretname "dnshostname" -namespace "default")
    [string] $serverurl = "https://${server}:6443"

    # the multiline string below HAS to start at the beginning of the line per powershell
    # https://www.kongsli.net/2012/05/03/powershell-gotchas-getting-multiline-string-literals-correct/
    [string] $kubeconfig =
    @"
apiVersion: v1
kind: Config
clusters:
- name: ${server}
  cluster:
    certificate-authority-data: ${ca}
    server: ${serverurl}
contexts:
- name: default-context
  context:
    cluster: ${server}
    namespace: ${namespace}
    user: ${user}
current-context: default-context
users:
- name: ${user}
  user:
    token: ${token}
"@

    Write-Host "------ CUT HERE -----"
    Write-Host $kubeconfig
    Write-Host "------ END CUT HERE ---"

    Write-Verbose 'GenerateKubeConfigFile: Done'

}

Export-ModuleMember -Function 'GenerateKubeConfigFile'