<#
  .SYNOPSIS
  ReadSecretValue

  .DESCRIPTION
  ReadSecretValue

  .INPUTS
  ReadSecretValue - The name of ReadSecretValue

  .OUTPUTS
  None

  .EXAMPLE
  ReadSecretValue

  .EXAMPLE
  ReadSecretValue


#>
function ReadSecretValue() {
    [CmdletBinding()]
    [OutputType([string])]
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
        $namespace
    )

    Write-Verbose 'ReadSecretValue: Starting'
    $returnValue = ReadSecretData -secretname $secretname -valueName "value" -namespace $namespace
    Write-Verbose 'ReadSecretValue: Done'

    Return $returnValue
}

Export-ModuleMember -Function "ReadSecretValue"