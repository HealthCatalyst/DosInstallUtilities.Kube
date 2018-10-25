<#
.SYNOPSIS
AskForSecretValue

.DESCRIPTION
AskForSecretValue

.INPUTS
AskForSecretValue - The name of AskForSecretValue

.OUTPUTS
None

.EXAMPLE
AskForSecretValue

.EXAMPLE
AskForSecretValue


#>
function AskForSecretValue()
{
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
        $prompt
        ,
        [string]
        $namespace
        ,
        [string]
        $defaultvalue
    )

    Write-Verbose 'AskForSecretValue: Starting'

    [hashtable]$Return = @{}

    if ([string]::IsNullOrWhiteSpace($namespace)) { $namespace = "default"}
    if ([string]::IsNullOrWhiteSpace($(kubectl get secret $secretname -n $namespace -o jsonpath='{.data}' --ignore-not-found=true))) {

        $certhostname = ""
        Do {
            $certhostname = Read-host "$prompt"
            if (!$certhostname) {
                if ($defaultvalue) {
                    $certhostname = $defaultvalue
                }
            }
        }
        while ($certhostname.Length -lt 1 )

        kubectl create secret generic $secretname --namespace=$namespace --from-literal=value=$certhostname
    }
    else {
        Write-Information -MessageData "$secretname secret already set so will reuse it"
    }

    Write-Verbose 'AskForSecretValue: Done'

    return $Return
}

Export-ModuleMember -Function 'AskForSecretValue'