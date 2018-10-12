<#
  .SYNOPSIS
  Merge-Tokens
  
  .DESCRIPTION
  Merge-Tokens
  
  .INPUTS
  Merge-Tokens - The name of Merge-Tokens

  .OUTPUTS
  None
  
  .EXAMPLE
  Merge-Tokens

  .EXAMPLE
  Merge-Tokens


#>
function Merge-Tokens() {
    [CmdletBinding()]
    param
    (
        $template, 
        $tokens
    )

    Write-Verbose 'Merge-Tokens: Starting'

    return [regex]::Replace(
        $template,
        '\$(?<tokenName>\w+)\$',
        {
            param($match)

            $tokenName = $match.Groups['tokenName'].Value

            return $tokens[$tokenName]
        })

    Write-Verbose 'Merge-Tokens: Done'

}

Export-ModuleMember -Function "Merge-Tokens"