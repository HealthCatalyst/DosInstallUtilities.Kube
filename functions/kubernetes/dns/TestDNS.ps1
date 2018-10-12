<#
.SYNOPSIS
TestDNS

.DESCRIPTION
TestDNS

.INPUTS
TestDNS - The name of TestDNS

.OUTPUTS
None

.EXAMPLE
TestDNS

.EXAMPLE
TestDNS


#>
function TestDNS() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $baseUrl
    )

    Write-Verbose 'TestDNS: Starting'
    Write-Host "To resolve DNS issues: https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/#debugging-dns-resolution"
    Write-Host "Checking if DNS pods are running"
    kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o wide
    Write-Host "Details about DNS pods"
    kubectl describe pods --namespace=kube-system -l k8s-app=kube-dns
    Write-Host "Details about flannel pods"
    kubectl logs --namespace kube-system -l app=flannel
    Write-Host "Checking if DNS service is running"
    kubectl get svc --namespace=kube-system
    Write-Host "Checking if DNS endpoints are exposed "
    kubectl get ep kube-dns --namespace=kube-system
    Write-Host "Checking logs for DNS service"
    # kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name)
    kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c kubedns
    kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c dnsmasq
    kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c sidecar
    Write-Host "Creating a busybox pod to test DNS"
    Do {
        Write-Host "Waiting for busybox to terminate"
        Write-Host "."
        Start-Sleep 5
    } while ($(kubectl get pods busybox -n default -o jsonpath='{.status.phase}' --ignore-not-found=true))

    kubectl create -f $baseUrl/kubernetes/test/busybox.yaml
    Do {
        Write-Host "."
        Start-Sleep 5
    } while ("$(kubectl get pods busybox -n default -o jsonpath='{.status.phase}')" -ne "Running")
    Write-Host " resolve.conf "
    kubectl exec busybox cat /etc/resolv.conf
    Write-Host "testing if we can access internal (pod) network"
    kubectl exec busybox nslookup kubernetes.default
    Write-Host "testing if we can access external network"
    kubectl exec busybox wget www.google.com
    kubectl delete -f $baseUrl/kubernetes/test/busybox.yaml

    Write-Verbose 'TestDNS: Done'

}

Export-ModuleMember -Function 'TestDNS'