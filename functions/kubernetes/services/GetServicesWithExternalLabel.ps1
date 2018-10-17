<#
.SYNOPSIS
GetServicesWithExternalLabel

.DESCRIPTION
GetServicesWithExternalLabel

.INPUTS
GetServicesWithExternalLabel - The name of GetServicesWithExternalLabel

.OUTPUTS
None

.EXAMPLE
GetServicesWithExternalLabel

.EXAMPLE
GetServicesWithExternalLabel


#>
function GetServicesWithExternalLabel() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'GetServicesWithExternalLabel: Starting'

    class Service {
        # Optionally, add attributes to prevent invalid values
        [ValidateNotNullOrEmpty()][string]$servicename
        [int]$port
        [int]$targetPort
    }

    $services = @()

    $kubernetesServiceInfo = kubectl get svc -l expose=external -n "$namespace" -o json | ConvertFrom-Json

    foreach ($item in $kubernetesServiceInfo.items) {
        # find any ports that are not 80 or 443
        foreach ($port in $item.spec.ports) {
            if ((80 -ne $port.port) -and (443 -ne $port.port)) {
                $services += [Service]@{
                    servicename = $item.metadata.name
                    port        = $port.port
                    targetPort  = $port.targetPort
                }
            }
        }
    }

    Write-Verbose 'GetServicesWithExternalLabel: Done'
    return @{
        Services = $services
    }
}

Export-ModuleMember -Function 'GetServicesWithExternalLabel'