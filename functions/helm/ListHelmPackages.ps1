<#
.SYNOPSIS
ListHelmPackages

.DESCRIPTION
ListHelmPackages

.INPUTS
ListHelmPackages - The name of ListHelmPackages

.OUTPUTS
None

.EXAMPLE
ListHelmPackages

.EXAMPLE
ListHelmPackages


#>
function ListHelmPackages()
{
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'ListHelmPackages: Starting'
    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    helm list

    Write-Verbose 'ListHelmPackages: Done'
}

Export-ModuleMember -Function 'ListHelmPackages'