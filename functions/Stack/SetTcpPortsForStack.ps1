<#
.SYNOPSIS
SetTcpPortsForStack

.DESCRIPTION
SetTcpPortsForStack

.INPUTS
SetTcpPortsForStack - The name of SetTcpPortsForStack

.OUTPUTS
None

.EXAMPLE
SetTcpPortsForStack

.EXAMPLE
SetTcpPortsForStack


#>
function SetTcpPortsForStack()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'SetTcpPortsForStack: Starting'

    # read services with label expose=external

    $result = $(GetTcpServices -namespace $namespace)
    foreach ($item in $result.ExternalServices) {
        $service = $item

        AssertStringIsNotNullOrEmpty $service.servicename

        Write-Host "External: Adding TCP port: tcp.$($service.port)=$namespace/$($service.servicename):$($service.targetPort) "

        $package="nginx"
        helm upgrade "$package" stable/nginx-ingress `
        --reuse-values `
        --namespace kube-system `
        --set-string "tcp.$($service.port)=$namespace/$($service.servicename):$($service.targetPort)"
    }

    foreach ($item in $result.InternalServices) {
        [Service]$service = $item

        AssertStringIsNotNullOrEmpty $service.servicename

        Write-Host "Internal: Adding TCP port: tcp.$($service.port)=$namespace/$($service.servicename):$($service.targetPort) "

        $package="nginx-internal"
        helm upgrade "$package" stable/nginx-ingress `
        --reuse-values `
        --namespace kube-system `
        --set-string "tcp.$($service.port)=$namespace/$($service.servicename):$($service.targetPort)"
    }

    # update nginx with these ports

    Write-Verbose 'SetTcpPortsForStack: Done'

}

Export-ModuleMember -Function 'SetTcpPortsForStack'