<#
.SYNOPSIS
LaunchGrafana

.DESCRIPTION
LaunchGrafana

.INPUTS
LaunchGrafana - The name of LaunchGrafana

.OUTPUTS
None

.EXAMPLE
LaunchGrafana

.EXAMPLE
LaunchGrafana


#>
function LaunchGrafana()
{
    [CmdletBinding()]
    param
    (
        [bool]
        $runAsJob = $false
    )

    Write-Verbose 'LaunchGrafana: Starting'
    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    Write-Host "Open your browser to http://localhost:3000"

    if ($runAsJob) {
        $sb = [scriptblock]::Create('"kubectl --namespace monitoring port-forward $(kubectl get pod --namespace monitoring -l app=grafana -o template --template "{{(index .items 0).metadata.name}}") 3000:3000')
        $job = Start-Job -Name "KubGrafana" -ScriptBlock $sb -ErrorAction Stop
        Wait-Job $job -Timeout 5;
        Write-Host "job state: $($job.state)"
        Receive-Job -Job $job 6>&1
    }
    else {
        kubectl --namespace monitoring port-forward $(kubectl get pod --namespace monitoring -l app=grafana -o template --template "{{(index .items 0).metadata.name}}") 3000:3000
    }

    Write-Verbose 'LaunchGrafana: Done'
}

Export-ModuleMember -Function 'LaunchGrafana'