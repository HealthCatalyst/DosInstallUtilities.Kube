<#
.SYNOPSIS
Test-Script

.DESCRIPTION
Test-Script

.INPUTS
Test-Script - The name of Test-Script

.OUTPUTS
None

.EXAMPLE
Test-Script

.EXAMPLE
Test-Script


#>
function Test-Script()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Object]
        $script
    )

    Write-Verbose 'Test-Script: Starting'

    $parse_errs = $null
    $tokens = [System.Management.Automation.PSParser]::Tokenize($script, [ref] $parse_errs)

    foreach ($err in $parse_errs) {
        'ERROR on line ' + $err.Token.StartLine + ': ' + $err.Message + "`n"
    }

    foreach ($token in $tokens) {
        if($token.Type -eq 'CommandArgument'){
            $gcmerr = Get-Command $token.Content 2>&1
            if(! $?){
                'WARNING on line ' + $gcmerr.InvocationInfo.ScriptLineNumber + ': ' + $gcmerr.Exception.Message + "`n"
            }
        }
    }

    Write-Verbose 'Test-Script: Done'
}

Export-ModuleMember -Function 'Test-Script'