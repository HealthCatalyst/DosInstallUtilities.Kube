<#
.SYNOPSIS
InstallHelmClient

.DESCRIPTION
InstallHelmClient

.INPUTS
InstallHelmClient - The name of InstallHelmClient

.OUTPUTS
None

.EXAMPLE
InstallHelmClient

.EXAMPLE
InstallHelmClient


#>
function InstallHelmClient()
{
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'InstallHelmClient: Starting'

    [string] $url = $globals.helmInstallUrl
    Write-Host "Install Helm client from $url"

    Write-Verbose 'InstallHelmClient: Done'
}

Export-ModuleMember -Function 'InstallHelmClient'