<#
  .SYNOPSIS
  DeployYamlFiles
  
  .DESCRIPTION
  DeployYamlFiles
  
  .INPUTS
  DeployYamlFiles - The name of DeployYamlFiles

  .OUTPUTS
  None
  
  .EXAMPLE
  DeployYamlFiles

  .EXAMPLE
  DeployYamlFiles


#>
function DeployYamlFiles() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $namespace
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $baseUrl
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $appfolder
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $folder
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [hashtable] 
        $tokens
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [bool] 
        $local
        ,
        $resources
    )

    Write-Verbose 'DeployYamlFiles: Starting'

    # $resources can be null
    [hashtable]$Return = @{} 

    if ($resources) {
        Write-Information -MessageData "-- Deploying $folder --"
        foreach ($file in $resources) {
            DeployYamlFile -baseUrl $baseUrl -templateFile "${appfolder}/${folder}/${file}" -tokens $tokens -local $local
        }
    }

    Write-Verbose 'DeployYamlFiles: Done'

    return $Return
}

Export-ModuleMember -Function "DeployYamlFiles"