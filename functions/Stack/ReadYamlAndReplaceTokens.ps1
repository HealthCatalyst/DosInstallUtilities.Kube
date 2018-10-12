<#
  .SYNOPSIS
  ReadYamlAndReplaceTokens
  
  .DESCRIPTION
  ReadYamlAndReplaceTokens
  
  .INPUTS
  ReadYamlAndReplaceTokens - The name of ReadYamlAndReplaceTokens

  .OUTPUTS
  None
  
  .EXAMPLE
  ReadYamlAndReplaceTokens

  .EXAMPLE
  ReadYamlAndReplaceTokens


#>
function ReadYamlAndReplaceTokens() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $baseUrl
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] 
        $templateFile
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

    Write-Verbose 'ReadYamlAndReplaceTokens: Starting'

    [hashtable]$Return = @{} 

    Write-Information -MessageData "Reading from url: ${baseUrl}/${templateFile}"

    if ($baseUrl.StartsWith("http")) { 
        $response = $(Invoke-WebRequest -Uri "${baseUrl}/${templateFile}?f=${randomstring}" -UseBasicParsing -ErrorAction:Stop -ContentType "text/plain; charset=utf-8")
        $content = $response | Select-Object -Expand Content
    }
    else {
        $content = $(Get-Content -Raw -Path "$baseUrl/$templateFile")
    }

    $content = $(Merge-Tokens $content $tokens)

    $Return.Content = $content

    Write-Verbose 'ReadYamlAndReplaceTokens: Done'
    return $Return
}

Export-ModuleMember -Function "ReadYamlAndReplaceTokens"