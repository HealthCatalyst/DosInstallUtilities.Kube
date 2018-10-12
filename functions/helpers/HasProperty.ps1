<#
  .SYNOPSIS
  HasProperty
  
  .DESCRIPTION
  HasProperty
  
  .INPUTS
  HasProperty - The name of HasProperty

  .OUTPUTS
  None
  
  .EXAMPLE
  HasProperty

  .EXAMPLE
  HasProperty


#>
function HasProperty() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $object
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $propertyName      
    )

    Write-Verbose 'HasProperty: Starting'

    $propertyName -in $object.PSobject.Properties.Name

    Write-Verbose 'HasProperty: Done'

}

Export-ModuleMember -Function "HasProperty"