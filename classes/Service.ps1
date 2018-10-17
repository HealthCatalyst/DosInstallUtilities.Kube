<#
.SYNOPSIS
Service class

.DESCRIPTION
Service class

.INPUTS
Service class - The name of Service class

.OUTPUTS
None

.EXAMPLE
Service class

.EXAMPLE
Service class


#>
function ServiceDummy()
{
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'Service class: Starting'

    Write-Verbose 'Service class: Done'

}

class Service {
    # Optionally, add attributes to prevent invalid values
    [ValidateNotNullOrEmpty()][string]$servicename
    [int]$port
    [int]$targetPort
}

Export-ModuleMember -Function 'Service class'