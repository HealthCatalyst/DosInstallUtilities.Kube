<#
  .SYNOPSIS
  LoadLoadBalancerStack
  
  .DESCRIPTION
  LoadLoadBalancerStack
  
  .INPUTS
  LoadLoadBalancerStack - The name of LoadLoadBalancerStack

  .OUTPUTS
  None
  
  .EXAMPLE
  LoadLoadBalancerStack

  .EXAMPLE
  LoadLoadBalancerStack


#>
function LoadLoadBalancerStack() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()] 
        [string]
        $baseUrl
        , 
        [int]
        $ssl
        , 
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()] 
        [string]
        $ingressInternalType
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()] 
        [string]
        $ingressExternalType
        , 
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()] 
        [string]
        $customerid
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [bool] 
        $isOnPrem
        ,
        [string]
        $externalIp
        ,
        [string]
        $internalIp
        ,
        [string]
        $externalSubnetName
        ,
        [string]
        $internalSubnetName
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $local      
    )

    Write-Verbose 'LoadLoadBalancerStack: Starting'

    [hashtable]$Return = @{} 

    # delete existing containers
    kubectl delete 'pods,services,configMaps,deployments,ingress' -l k8s-traefik=traefik -n kube-system --ignore-not-found=true

    # set Google DNS servers to resolve external  urls
    # http://blog.kubernetes.io/2017/04/configuring-private-dns-zones-upstream-nameservers-kubernetes.html
    kubectl delete -f "$baseUrl/loadbalancer/dns/upstream.yaml" --ignore-not-found=true
    Start-Sleep -Seconds 10
    $tokens = @{}
    DeployYamlFile -baseUrl $baseUrl -templateFile "loadbalancer/dns/upstream.yaml" -tokens $tokens -local $local

    # to debug dns: https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/#inheriting-dns-from-the-node

    kubectl delete ServiceAccount traefik-ingress-controller-serviceaccount -n kube-system --ignore-not-found=true

    Write-Information -MessageData "baseUrl: $baseUrl"

    # setting up traefik
    # https://github.com/containous/traefik/blob/master/docs/user-guide/kubernetes.md

    $runOnMaster = ""

    # $traefiklabels = "external,internal"
    Write-Information -MessageData "LoadLoadBalancerStack"
    
    Write-Information -MessageData "Customer ID: $customerid"

    Write-Information -MessageData "EXTERNALSUBNET: $externalSubnetName"
    Write-Information -MessageData "EXTERNALIP: $externalIp"
    Write-Information -MessageData "INTERNALSUBNET: $internalSubnetName"
    Write-Information -MessageData "INTERNALIP: $internalIp"

    [hashtable]$tokens = @{ 
        "CUSTOMERID"         = $customerid;
        "EXTERNALSUBNET"     = "$externalSubnetName";
        "EXTERNALIP"         = "$externalIp";
        "#REPLACE-RUNMASTER" = "$runOnMaster";
        "INTERNALSUBNET"     = "$internalSubnetName";
        "INTERNALIP"         = "$internalIp";
    }    

    $namespace = "kube-system"
    $appfolder = "loadbalancer"
    Write-Information -MessageData "Deploying configmaps"
    $folder = "configmaps"
    if ($ssl) {
        $files = "config.ssl.yaml"
        DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
    }
    else {
        $files = "config.yaml"
        DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
    }

    Write-Information -MessageData "Deploying pods"
    $folder = "pods"

    if ($ingressExternalType -eq "onprem" ) {
        $files = "traefik-onprem.yaml"
        DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
    }
    elseif ($ingressInternalType -eq "public" ) {
        $files = "traefik-azure.both.yaml"
        DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
    }
    else {
        if ($ssl) {
            $files = "traefik-azure.external.ssl.yaml traefik-azure.internal.ssl.yaml"
            DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
        }
        else {
            $files = "traefik-azure.external.yaml traefik-azure.internal.yaml"
            DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
        }    
    }

    Write-Information -MessageData "Deploying services"

    # Write-Information -MessageData "Deploying http ingress"
    # $folder = "ingress/http"
    # $files = "apidashboard.yaml"
    # DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ")

    $folder = "services/external"

    if ($ingressExternalType -eq "onprem" ) {
        Write-Information -MessageData "Setting up external load balancer"
        $files = "loadbalancer.onprem.yaml"
        DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
    }    
    elseif ("$ingressExternalType" -ne "vnetonly") {
        Write-Information -MessageData "Setting up a public load balancer"

        Write-Information -MessageData "Using External IP: [$externalIp]"

        Write-Information -MessageData "Setting up external load balancer"
        $files = "loadbalancer.external.public.yaml"
        DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
    }
    else {
        Write-Information -MessageData "Setting up an external load balancer"
        $files = "loadbalancer.external.vnetonly.yaml"
        DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local
    }


    if ($ingressExternalType -eq "onprem" ) {
    }
    elseif ("$ingressInternalType" -eq "public") {
        Write-Information -MessageData "Setting up an internal load balancer"
        $files = "loadbalancer.internal.public.yaml"
    }
    else {
        Write-Information -MessageData "Setting up an internal load balancer"
        Write-Information -MessageData "Using Internal IP: [$internalIp]"
        $files = "loadbalancer.internal.vnetonly.yaml"
    }
    DeployYamlFiles -namespace $namespace -baseUrl $baseUrl -appfolder $appfolder -folder $folder -tokens $tokens -resources $files.Split(" ") -local $local

    InstallStack -baseUrl $baseUrl -namespace $namespace -appfolder $appfolder `
        -externalSubnetName "$externalSubnetName" -externalIp "$externalip" `
        -internalSubnetName "$internalSubnetName" -internalIp "$internalIp" `
        -local $local

    WaitForPodsInNamespace -namespace kube-system -interval 5

    return $Return
  
    Write-Verbose 'LoadLoadBalancerStack: Done'

}

Export-ModuleMember -Function "LoadLoadBalancerStack"