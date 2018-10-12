<#
  .SYNOPSIS
  SaveSecretValue
  
  .DESCRIPTION
  SaveSecretValue
  
  .INPUTS
  SaveSecretValue - The name of SaveSecretValue

  .OUTPUTS
  None
  
  .EXAMPLE
  SaveSecretValue

  .EXAMPLE
  SaveSecretValue


#>
function SaveSecretValue() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $secretname
        , 
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $valueName
        , 
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $value
        , 
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace      
    )

    Write-Verbose 'SaveSecretValue: Starting'

    [hashtable]$Return = @{} 

    # secretname must be lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character
    if ([string]::IsNullOrWhiteSpace($namespace)) { $namespace = "default"}

    if (![string]::IsNullOrWhiteSpace($(kubectl get secret $secretname -n $namespace -o jsonpath='{.data}' --ignore-not-found=true))) {
        kubectl delete secret $secretname -n $namespace
    }

    kubectl create secret generic $secretname --namespace=$namespace --from-literal=${valueName}=$value


    Write-Verbose 'SaveSecretValue: Done'
    return $Return
}

Export-ModuleMember -Function "SaveSecretValue"