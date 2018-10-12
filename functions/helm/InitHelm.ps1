<#
  .SYNOPSIS
  InitHelm
  
  .DESCRIPTION
  InitHelm
  
  .INPUTS
  InitHelm - The name of InitHelm

  .OUTPUTS
  None
  
  .EXAMPLE
  InitHelm

  .EXAMPLE
  InitHelm


#>
function InitHelm()
{
  [CmdletBinding()]
  param
  (
  )

  Write-Verbose 'InitHelm: Starting'

  helm init --client-only

  # https://zero-to-jupyterhub.readthedocs.io/en/stable/setup-helm.html
  kubectl --namespace kube-system create serviceaccount tiller

  kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

  helm init --service-account tiller

  helm init --upgrade --service-account tiller

  Write-Verbose 'InitHelm: Done'

}

Export-ModuleMember -Function "InitHelm"