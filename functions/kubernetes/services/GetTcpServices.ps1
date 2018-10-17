<#
.SYNOPSIS
GetTcpServices

.DESCRIPTION
GetTcpServices

.INPUTS
GetTcpServices - The name of GetTcpServices

.OUTPUTS
None

.EXAMPLE
GetTcpServices

.EXAMPLE
GetTcpServices


#>
function GetTcpServices() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'GetTcpServices: Starting'

    [Service[]] $externalServices = @()

    $kubernetesServiceInfo = kubectl get svc -l expose=external -n "$namespace" -o json | ConvertFrom-Json

    foreach ($item in $kubernetesServiceInfo.items) {
        # find any ports that are not 80 or 443
        foreach ($port in $item.spec.ports) {
            if ((80 -ne $port.port) -and (443 -ne $port.port)) {
                $externalServices += [Service]@{
                    servicename = $item.metadata.name
                    port        = $port.port
                    targetPort  = $port.targetPort
                }
            }
        }
    }

    [Service[]] $internalServices = @()

    $kubernetesServiceInfo = kubectl get svc -l expose=internal -n "$namespace" -o json | ConvertFrom-Json

    foreach ($item in $kubernetesServiceInfo.items) {
        # find any ports that are not 80 or 443
        foreach ($port in $item.spec.ports) {
            if ((80 -ne $port.port) -and (443 -ne $port.port)) {
                $internalServices += [Service]@{
                    servicename = $item.metadata.name
                    port        = $port.port
                    targetPort  = $port.targetPort
                }
            }
        }
    }

    Write-Verbose 'GetTcpServices: Done'
    return @{
        ExternalServices = $externalServices
        InternalServices = $internalServices
    }
}

Export-ModuleMember -Function 'GetTcpServices'