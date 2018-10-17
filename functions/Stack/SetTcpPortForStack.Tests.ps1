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
    )

    Write-Verbose 'SetTcpPortsForStack: Starting'

    Write-Verbose 'SetTcpPortsForStack: Done'

}

Export-ModuleMember -Function 'SetTcpPortsForStack'