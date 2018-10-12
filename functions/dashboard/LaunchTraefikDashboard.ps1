<#
.SYNOPSIS
LaunchTraefikDashboard

.DESCRIPTION
LaunchTraefikDashboard

.INPUTS
LaunchTraefikDashboard - The name of LaunchTraefikDashboard

.OUTPUTS
None

.EXAMPLE
LaunchTraefikDashboard

.EXAMPLE
LaunchTraefikDashboard


#>
function LaunchTraefikDashboard()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $internalIp
    )

    Write-Verbose 'LaunchTraefikDashboard: Starting'

    # $customerid = ReadSecretValue -secretname customerid
    # $customerid = $customerid.ToLower().Trim()
    Write-Host "Launching http://${internalIp}/internal in the web browser"
    Start-Process -FilePath "http://${internalIp}/internal";
    Write-Host "Launching http://${internalIp}/external in the web browser"
    Start-Process -FilePath "http://${internalIp}/external";

    Write-Verbose 'LaunchTraefikDashboard: Done'
}

Export-ModuleMember -Function 'LaunchTraefikDashboard'