<#
.SYNOPSIS
Get-UserForDashboard

.DESCRIPTION
Get-UserForDashboard

.INPUTS
Get-UserForDashboard - The name of Get-UserForDashboard

.OUTPUTS
None

.EXAMPLE
Get-UserForDashboard

.EXAMPLE
Get-UserForDashboard


#>
function Get-UserForDashboard()
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
    )

    Write-Verbose 'Get-UserForDashboard: Starting'
    $user = "my-dashboard-user"
    Write-Verbose 'Get-UserForDashboard: Done'
    return $user
}

Export-ModuleMember -Function 'Get-UserForDashboard'