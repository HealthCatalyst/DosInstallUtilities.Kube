<#
.SYNOPSIS
ReadAllSecretsAsHashTable

.DESCRIPTION
ReadAllSecretsAsHashTable

.INPUTS
ReadAllSecretsAsHashTable - The name of ReadAllSecretsAsHashTable

.OUTPUTS
None

.EXAMPLE
ReadAllSecretsAsHashTable

.EXAMPLE
ReadAllSecretsAsHashTable


#>
function ReadAllSecretsAsHashTable() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'ReadAllSecretsAsHashTable: Starting'

    [hashtable]$Return = @{}

    $Return.Secrets = @()

    Write-Information -MessageData  "---- $namespace ---"

    [string] $secrets = $(kubectl get secrets -n $namespace -o jsonpath="{.items[?(@.type=='Opaque')].metadata.name}")
    if ($secrets) {
        foreach ($secret in $secrets.Split(" ")) {
            $secretjson = $(kubectl get secret $secret -n $namespace -o json) | ConvertFrom-Json
            foreach ($secretitem in $secretjson.data) {
                $properties = $($secretitem | Get-Member -MemberType NoteProperty)
                $secretlist = @()
                foreach ($property in $properties) {
                    $propertyName = $property.Name
                    Write-Information -MessageData  $propertyName
                    $value = $($secretitem | Select-Object -ExpandProperty $propertyName)
                    $secretvalue = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($value))
                    $secretlist += @{
                        key   = "$propertyName"
                        value = "$secretvalue"
                    }
                }
                $Return.Secrets += @{
                    secretname   = "$secret"
                    namespace    = "$namespace"
                    secretvalues = $secretlist
                }
            }
        }
    }

    Write-Verbose 'ReadAllSecretsAsHashTable: Done'
    return $Return
}

Export-ModuleMember -Function 'ReadAllSecretsAsHashTable'