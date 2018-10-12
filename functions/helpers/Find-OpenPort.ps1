<#
  .SYNOPSIS
  Find-OpenPort
  
  .DESCRIPTION
  Find-OpenPort
  
  .INPUTS
  Find-OpenPort - The name of Find-OpenPort

  .OUTPUTS
  None
  
  .EXAMPLE
  Find-OpenPort

  .EXAMPLE
  Find-OpenPort


#>
function Find-OpenPort()
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()] 
        [int[]]
        $portArray
    )

  Write-Verbose 'Find-OpenPort: Starting'

  [hashtable]$Return = @{} 

  ForEach ($port in $portArray) {
      [bool]$isPortFree = Get-IsPortFree $port
      if ($isPortFree) {
          $Return.Port = $port
          Write-Verbose "Find-OpenPort: Done [$port]"
          return $Return
      }
  }

  $Return.Port = 0

  Write-Verbose 'Find-OpenPort: Done'
  return $Return  
}

Export-ModuleMember -Function "Find-OpenPort"