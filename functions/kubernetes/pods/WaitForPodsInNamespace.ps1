<#
  .SYNOPSIS
  WaitForPodsInNamespace

  .DESCRIPTION
  WaitForPodsInNamespace

  .INPUTS
  WaitForPodsInNamespace - The name of WaitForPodsInNamespace

  .OUTPUTS
  None

  .EXAMPLE
  WaitForPodsInNamespace

  .EXAMPLE
  WaitForPodsInNamespace


#>
function WaitForPodsInNamespace() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
        ,
        [Parameter(Mandatory = $true)]
        [int]
        $interval
    )

    Write-Verbose 'WaitForPodsInNamespace: Starting'

    [hashtable]$Return = @{}

    [string] $podsText = $(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')
    [string] $waitingonPodText = "n"

    [int] $counter = 0
    [bool] $failed = $false
    Do {
        $waitingonPodText = ""
        Write-Host "---- waiting until all pods are running in namespace $namespace ---"

        Start-Sleep -Seconds $interval
        $counter++
        $podsText = $(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')

        if ([string]::IsNullOrWhiteSpace($podsText)) {
            throw "No pods were found in namespace $namespace"
        }

        [string[]] $pods = $podsText.Split(" ")
        foreach ($pod in $pods) {
            [string] $podstatus = $(kubectl get pods $pod -n $namespace -o jsonpath='{.status.phase}')
            if ($podstatus -eq "Running") {
                # nothing to do
            }
            elseif ($podstatus -eq "Pending") {
                # Write-Verbose "${pod}: $podstatus"
                [string] $containerReady = $(kubectl get pods $pod -n $namespace -o jsonpath="{.status.containerStatuses[0].ready}")
                if ($containerReady -ne "true" ) {
                    [string] $containerStatus = $(kubectl get pods $pod -n $namespace -o jsonpath="{.status.containerStatuses[0].state.waiting.reason}")
                    # Write-Verbose "${pod}: $podstatus ($containerStatus)"
                    if (![string]::IsNullOrEmpty(($containerStatus))) {
                        if ($containerStatus -eq "CreateContainerConfigError") {
                            $failed = $true
                            break
                        }
                        else {
                            $waitingonPodText = "${waitingonPodText}${pod}($containerStatus);"
                        }
                    }
                    else {
                        $waitingonPodText = "${waitingonPodText}${pod}(container);"
                    }
                }
            }
            else {
                $waitingonPodText = "${waitingonPodText}${pod}($podstatus);"
            }
        }

        Write-Host "[$counter] $waitingonPodText"
    }
    while (![string]::IsNullOrEmpty($waitingonPodText) -and !($failed) -and ($counter -lt 30) )

    kubectl get pods -n $namespace -o wide

    if ($counter -gt 29 -or $failed) {
        Write-Host "------- Kubernetes Events ------------"
        kubectl get events -n "$namespace" --sort-by=".metadata.creationTimestamp"
        Write-Host "------- End of Kubernetes Events ------------"
        $Return.Success = $false
        Write-Error "Pods Failed"
    }

    Write-Verbose 'WaitForPodsInNamespace: Done'
    $Return.Success = $true
    return $Return
}

Export-ModuleMember -Function "WaitForPodsInNamespace"