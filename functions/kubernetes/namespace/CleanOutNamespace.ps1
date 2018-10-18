<#
  .SYNOPSIS
  CleanOutNamespace

  .DESCRIPTION
  CleanOutNamespace

  .INPUTS
  CleanOutNamespace - The name of CleanOutNamespace

  .OUTPUTS
  None

  .EXAMPLE
  CleanOutNamespace

  .EXAMPLE
  CleanOutNamespace


#>
function CleanOutNamespace() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'CleanOutNamespace: Starting'

    [hashtable]$Return = @{}

    Write-Host "--- Cleaning out any old resources in $namespace ---"

    # note kubectl doesn't like spaces in between commas below
    kubectl delete --all 'deployments,pods,services,ingress,persistentvolumeclaims,jobs,cronjobs' --namespace=$namespace --ignore-not-found=true

    # can't delete persistent volume claims since they are not scoped to namespace
    kubectl delete 'pv' -l namespace=$namespace --ignore-not-found=true

    Write-Host "Waiting for resources to be deleted"
    $CLEANUP_DONE = "n"
    $counter = 0
    Do {
        $CLEANUP_DONE = $(kubectl get 'deployments,pods,services,ingress,persistentvolumeclaims,jobs,cronjobs' --namespace=$namespace -o jsonpath="{.items[*].metadata.name}")
        if (![string]::IsNullOrEmpty($CLEANUP_DONE)) {
            $counter++
            Write-Host "[$counter] Remaining items: $CLEANUP_DONE"
            Start-Sleep 5
        }
    }
    while ((![string]::IsNullOrEmpty($CLEANUP_DONE)) -and ($counter -lt 12))

    if (![string]::IsNullOrEmpty($CLEANUP_DONE)) {
        Write-Host "Deleting pods didn't work so deleting with force"
        kubectl delete --all 'pods' --grace-period=0 --force --namespace=$namespace --ignore-not-found=true
        Write-Host "Waiting for resources to be deleted"
        $CLEANUP_DONE = "n"
        $counter = 0
        Do {
            $CLEANUP_DONE = $(kubectl get 'deployments,pods,services,ingress,persistentvolumeclaims,jobs,cronjobs' --namespace=$namespace -o jsonpath="{.items[*].metadata.name}")
            if (![string]::IsNullOrEmpty($CLEANUP_DONE)) {
                $counter++
                Write-Host "[$counter] Remaining items: $CLEANUP_DONE"
                Start-Sleep 5
            }
        }
        while ((![string]::IsNullOrEmpty($CLEANUP_DONE)) -and ($counter -lt 12))
    }

    Write-Verbose 'CleanOutNamespace: Done'
    return $Return
}

Export-ModuleMember -Function "CleanOutNamespace"