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
function DeleteHelmPackage()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $package
    )

    Write-Verbose 'DeleteHelmPackage: Starting'

    helm del --purge $package

    Write-Verbose 'DeleteHelmPackage: Done'

}

Export-ModuleMember -Function 'DeleteHelmPackage'