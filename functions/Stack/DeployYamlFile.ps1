<#
  .SYNOPSIS
  DeployYamlFile
  
  .DESCRIPTION
  DeployYamlFile
  
  .INPUTS
  DeployYamlFile - The name of DeployYamlFile

  .OUTPUTS
  None
  
  .EXAMPLE
  DeployYamlFile

  .EXAMPLE
  DeployYamlFile


#>
function DeployYamlFile() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $templateFile
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $baseUrl
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
    )

    Write-Verbose 'DeployYamlFile: Starting'

    # $resources can be null
    [hashtable]$Return = @{} 

    $content = $(ReadYamlAndReplaceTokens -baseUrl $baseUrl -templateFile $templateFile -local $local -tokens $tokens).Content
    Write-Verbose $content
    $content | kubectl apply -f -
    $result = $?
    if ($result -ne $True) {
        throw "Error applying kubernetes template: $templateFile"
    }


    Write-Verbose 'DeployYamlFile: Done'
    return $Return
}

Export-ModuleMember -Function "DeployYamlFile"