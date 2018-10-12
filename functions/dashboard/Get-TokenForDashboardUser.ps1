<#
.SYNOPSIS
Get-TokenForDashboardUser

.DESCRIPTION
Get-TokenForDashboardUser

.INPUTS
Get-TokenForDashboardUser - The name of Get-TokenForDashboardUser

.OUTPUTS
None

.EXAMPLE
Get-TokenForDashboardUser

.EXAMPLE
Get-TokenForDashboardUser


#>
function Get-TokenForDashboardUser()
{
    [CmdletBinding()]
    param
    (
    )

    $Return = @{}

    Write-Verbose 'Get-TokenForDashboardUser: Starting'
    [string] $namespace = "kube-system"

    [string] $secretname = $(Get-SecretNameForDashboardUser).SecretName
    AssertStringIsNotNullOrEmpty -text $secretname

    $secretjson = $(kubectl get secret $secretname -n $namespace -o json) | ConvertFrom-Json
    [string] $tokenBase64 = $secretjson.data.token
    AssertStringIsNotNullOrEmpty -text $tokenBase64

    [string] $token = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($tokenBase64))
    AssertStringIsNotNullOrEmpty -text $token

    $ca = $(kubectl get secret $secretname -n $namespace -o jsonpath='{.data.ca\.crt}') # ca doesn't use base64 encoding

    $Return.Ca = $ca
    $Return.Token = $token

    Write-Verbose 'Get-TokenForDashboardUser: Done'
    return $Return
}

Export-ModuleMember -Function 'Get-TokenForDashboardUser'