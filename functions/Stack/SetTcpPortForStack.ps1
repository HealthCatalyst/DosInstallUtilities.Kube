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

    # update nginx with these ports

    Write-Verbose 'SetTcpPortsForStack: Done'

}

Export-ModuleMember -Function 'SetTcpPortsForStack'