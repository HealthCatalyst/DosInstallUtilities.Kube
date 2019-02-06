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

    [string] $url = $kubeGlobals.helmInstallUrl
    Write-Host "Installing Helm client from $url"

    DownloadFile -url $url -targetFile "helm.zip"
    Start-Sleep -Seconds 5

    Expand-Archive -Path .\helm.zip -DestinationPath "$env:USERPROFILE\.azure-kubectl"
    Start-Sleep -Seconds 5

    Copy-Item -Path "$env:USERPROFILE\.azure-kubectl\windows-amd64\*" -Destination "$env:USERPROFILE\.azure-kubectl\"

    Write-Verbose 'InstallHelmClient: Done'
}

Export-ModuleMember -Function 'InstallHelmClient'