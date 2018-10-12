<#
  .SYNOPSIS
  ReadConfigFile
  
  .DESCRIPTION
  ReadConfigFile
  
  .INPUTS
  ReadConfigFile - The name of ReadConfigFile

  .OUTPUTS
  None
  
  .EXAMPLE
  ReadConfigFile

  .EXAMPLE
  ReadConfigFile


#>
function ReadConfigFile() {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param
    (

    )

    Write-Verbose 'ReadConfigFile: Starting'
    [hashtable]$Return = @{} 

    [string] $configfilepath = $(GetConfigFile).FilePath
    AssertStringIsNotNullOrEmpty $configfilepath

    Write-Verbose "Reading config from $configfilepath"
    $config = $(Get-Content $configfilepath -Raw | ConvertFrom-Json)

    $Return.Config = $config
    Write-Verbose 'ReadConfigFile: Done'
    return $Return
}

Export-ModuleMember -Function "ReadConfigFile"