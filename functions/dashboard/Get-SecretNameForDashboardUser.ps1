<#
.SYNOPSIS
Get-SecretNameForDashboardUser

.DESCRIPTION
Get-SecretNameForDashboardUser

.INPUTS
Get-SecretNameForDashboardUser - The name of Get-SecretNameForDashboardUser

.OUTPUTS
None

.EXAMPLE
Get-SecretNameForDashboardUser

.EXAMPLE
Get-SecretNameForDashboardUser


#>
function Get-SecretNameForDashboardUser() {
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'Get-SecretNameForDashboardUser: Starting'
    $Return = @{}

    [string] $namespace = "kube-system"
    [string] $secretText = $(kubectl get secrets -n $namespace -o jsonpath="{.items[*].metadata.name}")
    AssertStringIsNotNullOrEmpty -text $secretText

    [string] $dashboardUser = $(Get-UserForDashboard)
    AssertStringIsNotNullOrEmpty -text $dashboardUser
    [string[]] $secrets = $secretText.Split(" ")
    [string] $mydashboardUserSecretName = $secrets | Where-Object {$_ -like "${dashboarduser}-token-*"}
    AssertStringIsNotNullOrEmpty -text $mydashboardUserSecretName

    $Return.SecretName = $mydashboardUserSecretName

    Write-Verbose 'Get-SecretNameForDashboardUser: Done'
    return $Return
}

Export-ModuleMember -Function 'Get-SecretNameForDashboardUser'