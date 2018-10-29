<#
  .SYNOPSIS
  ReadSecretData

  .DESCRIPTION
  ReadSecretData

  .INPUTS
  ReadSecretData - The name of ReadSecretData

  .OUTPUTS
  None

  .EXAMPLE
  ReadSecretData

  .EXAMPLE
  ReadSecretData


#>
function ReadSecretData() {
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
        [string]
        $namespace
    )

    Write-Verbose 'ReadSecretData: Starting'

    Set-StrictMode -Version latest
    # stop whenever there is an error
    $ErrorActionPreference = "Stop"

    if ([string]::IsNullOrWhiteSpace($namespace)) { $namespace = "default"}

    [string] $secretbase64 = kubectl get secret $secretname -o jsonpath="{.data.${valueName}}" -n $namespace --ignore-not-found=true 2> $null

    [string] $secretvalue = ""

    if (![string]::IsNullOrWhiteSpace($secretbase64)) {
        $secretvalue = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secretbase64))
        return $secretvalue
    }
    else {
        $secretvalue = ""
    }

    Write-Verbose 'ReadSecretData: Done'
    return $secretvalue;
}

Export-ModuleMember -Function "ReadSecretData"