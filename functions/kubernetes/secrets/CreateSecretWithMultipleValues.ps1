<#
  .SYNOPSIS
  CreateSecretWithMultipleValues
  
  .DESCRIPTION
  CreateSecretWithMultipleValues
  
  .INPUTS
  CreateSecretWithMultipleValues - The name of CreateSecretWithMultipleValues

  .OUTPUTS
  None
  
  .EXAMPLE
  CreateSecretWithMultipleValues

  .EXAMPLE
  CreateSecretWithMultipleValues


#>
function CreateSecretWithMultipleValues()
{
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
    ,
    [parameter (Mandatory = $true) ]
    [ValidateNotNullOrEmpty()]
    [string] 
    $secret1
    ,
    [parameter (Mandatory = $true) ]
    [ValidateNotNullOrEmpty()]
    [string] 
    $secret2
    ,    
    [parameter (Mandatory = $true) ]
    [ValidateNotNullOrEmpty()]
    [string] 
    $secret3
  )

  Write-Verbose 'CreateSecretWithMultipleValues: Starting'

#  kubectl create secret generic $secretname -n $namespace --from-literal=resourcegroup="${resourceGroup}" --from-literal=azurestorageaccountname="${storageAccountName}" --from-literal=azurestorageaccountkey="${storageKey}"

  kubectl create secret generic $secretname -n $namespace --from-literal=$secret1 --from-literal=$secret2 --from-literal=$secret3

  Write-Verbose 'CreateSecretWithMultipleValues: Done'

}

Export-ModuleMember -Function "CreateSecretWithMultipleValues"