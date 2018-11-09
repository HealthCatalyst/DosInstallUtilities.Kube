<#
.SYNOPSIS
DeleteHelmPackage

.DESCRIPTION
DeleteHelmPackage

.INPUTS
DeleteHelmPackage - The name of DeleteHelmPackage

.OUTPUTS
None

.EXAMPLE
DeleteHelmPackage

.EXAMPLE
DeleteHelmPackage


#>
function DeleteHelmPackage() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $package
    )

    Write-Verbose 'DeleteHelmPackage: Starting'

    [string[]] $installedPackages = $(helm list -q --output json | ConvertFrom-Json)

    if ($installedPackages) {
        if ($installedPackages.Contains("$package")) {
            helm del --purge $package
        }
    }

    Write-Verbose 'DeleteHelmPackage: Done'

}

Export-ModuleMember -Function 'DeleteHelmPackage'