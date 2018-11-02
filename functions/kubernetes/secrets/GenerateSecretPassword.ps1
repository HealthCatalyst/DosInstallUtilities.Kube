<#
.SYNOPSIS
GenerateSecretPassword

.DESCRIPTION
GenerateSecretPassword

.INPUTS
GenerateSecretPassword - The name of GenerateSecretPassword

.OUTPUTS
None

.EXAMPLE
GenerateSecretPassword

.EXAMPLE
GenerateSecretPassword


#>
function GenerateSecretPassword() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $secretname
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'GenerateSecretPassword: Starting'

    [hashtable]$Return = @{}

    if ([string]::IsNullOrWhiteSpace($namespace)) { $namespace = "default"}
    if ([string]::IsNullOrWhiteSpace($(kubectl get secret $secretname -n $namespace -o jsonpath='{.data}' --ignore-not-found=true))) {

        Write-Host "$secretname not found so generating it"
        [string] $mypassword = ""
        # MySQL password requirements: https://dev.mysql.com/doc/refman/5.6/en/validate-password-plugin.html
        # we also use sed to replace configs: https://unix.stackexchange.com/questions/32907/what-characters-do-i-need-to-escape-when-using-sed-in-a-sh-script
        Do {
            $mypassword = GeneratePassword
        }
        while (($mypassword -notmatch "^[a-z0-9!.*@\s]+$") -or ($mypassword.Length -lt 8 ))

        Write-Verbose "Setting secret $secretname to [$mypassword]"
        SaveSecretPassword -secretname $secretname -namespace $namespace -value "$mypassword"

        $Return.Password = $mypassword
    }
    else {
        Write-Host "$secretname secret already set so will reuse it"
        $Return.Password = $(ReadSecretPassword -secretname $secretname -namespace $namespace)
    }

    Write-Verbose 'GenerateSecretPassword: Done'
    return $Return

}

Export-ModuleMember -Function 'GenerateSecretPassword'