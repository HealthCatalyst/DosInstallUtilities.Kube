<#
.SYNOPSIS
TroubleshootIngress

.DESCRIPTION
TroubleshootIngress

.INPUTS
TroubleshootIngress - The name of TroubleshootIngress

.OUTPUTS
None

.EXAMPLE
TroubleshootIngress

.EXAMPLE
TroubleshootIngress


#>
function TroubleshootIngress() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $namespace
    )

    Write-Verbose 'TroubleshootIngress: Starting'
    $ingresses = $(kubectl get ingress -n $namespace -o jsonpath='{.items[*].metadata.name}')
    foreach ($ingress in $ingresses.Split(" ")) {
        $ingressPath = $(kubectl get ing $ingress -n $namespace -o jsonpath="{.spec.rules[].http.paths[].path}")
        $ingressHost = $(kubectl get ing $ingress -n $namespace -o jsonpath='{.spec.rules[].host}')
        $ingressRuleType = $(kubectl get ing $ingress -n $namespace -o jsonpath="{.metadata.annotations.traefik\.frontend\.rule\.type}")
        $ingressType = $(kubectl get ing $ingress -n $namespace -o jsonpath="{.metadata.labels.expose}")
        Write-Host "=============== Ingress: $ingress ================="
        Write-Host "Ingress Path: $ingressPath"
        Write-Host "Ingress Host: $ingressHost"
        Write-Host "Ingress Type: $ingressType"
        Write-Host "Ingress Rule Type: $ingressRuleType"
        $ingressServiceName = $(kubectl get ing $ingress -n $namespace -o jsonpath="{.spec.rules[].http.paths[].backend.serviceName}")
        $ingressServicePort = $(kubectl get ing $ingress -n $namespace -o jsonpath="{.spec.rules[].http.paths[].backend.servicePort}")
        Write-Host "Service: $ingressServiceName port: $ingressServicePort"
        $servicePort = $(kubectl get svc $ingressServiceName -n $namespace -o jsonpath="{.spec.ports[].port}")
        $targetPort = $(kubectl get svc $ingressServiceName -n $namespace -o jsonpath="{.spec.ports[].targetPort}")
        Write-Host "Service Port: $servicePort target Port: $targetPort"
        $servicePodSelectorMap = $(kubectl get svc $ingressServiceName -n $namespace -o jsonpath="{.spec.selector}")
        $servicePodSelectors = $servicePodSelectorMap.Replace("map[", "").Replace("]", "").Split(" ")
        $servicePodSelectorsList = ""
        foreach ($servicePodSelector in $servicePodSelectors) {
            $servicePodSelectorItems = $servicePodSelector.Split(":")
            $servicePodSelectorKey = $($servicePodSelectorItems[0])
            $servicePodSelectorValue = $($servicePodSelectorItems[1])
            $servicePodSelectorsList += " -l ${servicePodSelectorKey}=${servicePodSelectorValue}"
        }
        Write-Host "Pod Selector: $servicePodSelectorsList"
        $pod = $(Invoke-Expression("kubectl get pod $servicePodSelectorsList -n $namespace -o jsonpath='{.items[*].metadata.name}'"))
        Write-Host "Pod name: $pod"
        $podstatus = $(kubectl get pod $pod -n $namespace -o jsonpath="{.status.phase}")
        Write-Host "Pod status: $podstatus"
        $containerImage = $(kubectl get pod $pod -n $namespace -o jsonpath="{.spec.containers[0].image}")
        Write-Host "Container image: $containerImage"
        $containerPort = $(kubectl get pod $pod -n $namespace -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
        Write-Host "Container Port: $containerPort"
    }

    Write-Verbose 'TroubleshootIngress: Done'

}

Export-ModuleMember -Function 'TroubleshootIngress'