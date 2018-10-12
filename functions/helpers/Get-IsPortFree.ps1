<#
  .SYNOPSIS
  Get-ProcessByPort
  
  .DESCRIPTION
  Get-ProcessByPort
  
  .INPUTS
  Get-ProcessByPort - The name of Get-ProcessByPort

  .OUTPUTS
  None
  
  .EXAMPLE
  Get-ProcessByPort

  .EXAMPLE
  Get-ProcessByPort


#>
function Get-IsPortFree() {
    [CmdletBinding()]
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()] 
        [int] 
        $Port
    )

    Write-Verbose "Get-IsPortFree: Starting [Port=$Port]"

    $tcpClient = new-object Net.Sockets.TcpClient
    try
    {
        $tcpClient.Connect("localhost", $Port)
        Write-Verbose "Get-IsPortFree: port $Port is in use"
    }
    catch
    {
        Write-Verbose "Get-IsPortFree: port is open"
        return $true
    }
    finally
    {
        $tcpClient.Dispose()
    }    
    return $false
}

Export-ModuleMember -Function "Get-IsPortFree"