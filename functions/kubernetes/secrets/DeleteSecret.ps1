<#
  .SYNOPSIS
  DeleteSecret
  
  .DESCRIPTION
  DeleteSecret
  
  .INPUTS
  DeleteSecret - The name of DeleteSecret

  .OUTPUTS
  None
  
  .EXAMPLE
  DeleteSecret

  .EXAMPLE
  DeleteSecret


#>
function DeleteSecret() {
    [CmdletBinding()]
    param
    (
        [parameter (Mandatory = $true) ]
        [ValidateNotNullOrEmpty()]
        [string]
        $secretname
        ,
        [parameter (Mandatory = $true) ]
        [ValidateNotNullOrEmpty()]
        [string] 
        $namespace
    )

    Write-Verbose 'DeleteSecret: Starting'

    if (![string]::IsNullOrWhiteSpace($(kubectl get secret $secretname -n $namespace -o jsonpath='{.data}' --ignore-not-found=true))) {
        kubectl delete secret $secretname -n $namespace
    }

    Write-Verbose 'DeleteSecret: Done'
}

Export-ModuleMember -Function "DeleteSecret"