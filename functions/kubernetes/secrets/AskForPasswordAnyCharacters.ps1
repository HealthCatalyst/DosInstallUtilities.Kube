<#
.SYNOPSIS
AskForPasswordAnyCharacters

.DESCRIPTION
AskForPasswordAnyCharacters

.INPUTS
AskForPasswordAnyCharacters - The name of AskForPasswordAnyCharacters

.OUTPUTS
None

.EXAMPLE
AskForPasswordAnyCharacters

.EXAMPLE
AskForPasswordAnyCharacters


#>
function AskForPasswordAnyCharacters()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $secretname
        ,
        [string]
        $prompt
        ,
        [string]
        $namespace
        ,
        [string]
        $defaultvalue
    )

    Write-Verbose 'AskForPasswordAnyCharacters: Starting'
    [hashtable]$Return = @{}

    if ([string]::IsNullOrWhiteSpace($namespace)) { $namespace = "default"}
    if ([string]::IsNullOrWhiteSpace($(kubectl get secret $secretname -n $namespace -o jsonpath='{.data}' --ignore-not-found=true))) {

        $mypassword = ""
        # MySQL password requirements: https://dev.mysql.com/doc/refman/5.6/en/validate-password-plugin.html
        # we also use sed to replace configs: https://unix.stackexchange.com/questions/32907/what-characters-do-i-need-to-escape-when-using-sed-in-a-sh-script
        Do {
            $fullprompt = $prompt
            if ($defaultvalue) {
                $fullprompt = "$prompt (leave empty for default)"
            }
            $mypassword = Read-host "$fullprompt"
            if ($mypassword.Length -lt 1) {
                $mypassword = $defaultvalue
            }
        }
        while (($mypassword.Length -lt 8 ) -and (!("$mypassword" -eq "$defaultvalue")))
        kubectl create secret generic $secretname --namespace=$namespace --from-literal=password=$mypassword
    }
    else {
        Write-Information -MessageData "$secretname secret already set so will reuse it"
    }

    return $Return

    Write-Verbose 'AskForPasswordAnyCharacters: Done'

}

Export-ModuleMember -Function 'AskForPasswordAnyCharacters'