<#
  .SYNOPSIS
  Test-CommandExists
  
  .DESCRIPTION
  Test-CommandExists
  
  .INPUTS
  Test-CommandExists - The name of Test-CommandExists

  .OUTPUTS
  None
  
  .EXAMPLE
  Test-CommandExists

  .EXAMPLE
  Test-CommandExists


#>
function Test-CommandExists() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        $command
    )

    Write-Verbose 'Test-CommandExists: Starting'

    # from https://blogs.technet.microsoft.com/heyscriptingguy/2013/02/19/use-a-powershell-function-to-see-if-a-command-exists/
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try {if (Get-Command $command) {RETURN $true}}
    Catch {Write-Information -MessageData "$command does not exist"; RETURN $false}
    Finally {$ErrorActionPreference = $oldPreference}

    Write-Verbose 'Test-CommandExists: Done'

}

Export-ModuleMember -Function "Test-CommandExists"