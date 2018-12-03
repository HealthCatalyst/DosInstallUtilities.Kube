<#
.SYNOPSIS
InstallGrafana

.DESCRIPTION
InstallGrafana

.INPUTS
InstallGrafana - The name of InstallGrafana

.OUTPUTS
None

.EXAMPLE
InstallGrafana

.EXAMPLE
InstallGrafana


#>
function InstallGrafana()
{
    [CmdletBinding()]
    param
    (
    )

    Write-Verbose 'InstallGrafana: Starting'
    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    # https://github.com/helm/charts/tree/master/stable/prometheus-operator

    DeleteHelmPackage -package prometheus-operator

    kubectl delete crd prometheuses.monitoring.coreos.com --ignore-not-found
    kubectl delete crd prometheusrules.monitoring.coreos.com --ignore-not-found
    kubectl delete crd servicemonitors.monitoring.coreos.com --ignore-not-found
    kubectl delete crd alertmanagers.monitoring.coreos.com --ignore-not-found

     helm install stable/prometheus-operator `
        --name prometheus-operator `
        --namespace monitoring

        # --set-string "grafana\.ini".server.root_url='"http://hcut.healthcatalyst.net/grafana"'

        # prometheus.prometheusSpec.routePrefix
    # set subpath: https://github.com/helm/charts/issues/6264

    # {"apiVersion":"extensions/v1beta1","kind":"Ingress","metadata":{"name":"grafana-ingress-path","namespace":"monitoring","labels":{"expose":"external"},"annotations":{"kubernetes.io/ingress.class":"nginx","nginx.ingress.kubernetes.io/add-base-url":"true","nginx.ingress.kubernetes.io/rewrite-target":"/"}},"spec":{"rules":[{"http":{"paths":[{"path":"/grafana","backend":{"serviceName":"prometheus-operator-grafana","servicePort":80}}]}}]}}

    #        --set-string grafana.ingress.annotations."kubernetes\.io/ingress.class"='"nginx"'

    # https://akomljen.com/get-kubernetes-cluster-metrics-with-prometheus-in-5-minutes/

    # oauth proxy
    # https://akomljen.com/protect-kubernetes-external-endpoints-with-oauth2-proxy/

    Write-Verbose 'InstallGrafana: Done'
}

Export-ModuleMember -Function 'InstallGrafana'