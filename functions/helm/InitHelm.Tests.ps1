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
  
  Write-Verbose 'InitHelm: Done'

}

Export-ModuleMember -Function "InitHelm"