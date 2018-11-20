<#
.SYNOPSIS
GenerateCertificates

.DESCRIPTION
GenerateCertificates

.INPUTS
GenerateCertificates - The name of GenerateCertificates

.OUTPUTS
None

.EXAMPLE
GenerateCertificates

.EXAMPLE
GenerateCertificates


#>
function GenerateCertificates() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $CertHostName
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $CertPassword
    )

    Write-Verbose 'GenerateCertificates: Starting'

    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    # install helm package
    [string] $sslsecret = $(kubectl get secret fabric-ssl-cert -n kube-system --ignore-not-found=true)

    if (!$sslsecret) {

        # TODO: read ssl cert from keyvault

        [string] $namespace = "kube-system"
        [string] $package = "certificategenerator"
        [string] $packageUrl = "$($kubeGlobals.certificateGeneratorPackageUrl)"
        [string] $clientCertificateUser = "fabricrabbitmquser"
        Write-Output "Removing old deployment for $package"
        DeleteHelmPackage -package $package

        Start-Sleep -Seconds 5

        # https://docs.helm.sh/developing_charts/

        Write-Output "Install helm package from $packageUrl"

        helm install $packageUrl `
            --name $package `
            --set-string certhostname=$CertHostName `
            --set-string certpassword=$CertPassword `
            --set-string clientCertificateUser=$clientCertificateUser `
            --namespace $namespace `
            --debug

        Write-Verbose "Listing packages"
        [string] $failedText = $(helm list --failed --output json)
        if (![string]::IsNullOrWhiteSpace($failedText)) {
            Write-Error "Helm package failed"
        }
        $(helm list)

        Write-Host "Waiting for certificategenerator pod to complete"
        $result = $(kubectl wait job --for=condition=complete --timeout=30s -l app=certificategenerator -n kube-system)

        Write-Verbose "Waiting for certificates to generate"
        while ([string]::IsNullOrEmpty($(kubectl get secret fabric-ssl-cert -n kube-system --ignore-not-found=true))) {
            Start-Sleep -Seconds 1
        }

        # Write-Output "Removing deployment for $package"
        # DeleteHelmPackage -package $package

        CreateNamespaceIfNotExists -namespace "fabricrealtime"

        # TODO: Make this automatic
        Write-Host "copy secrets to fabricrealtime namespace"
        [string] $secretName = "fabric-ca-cert"
        kubectl get secret $secretName --namespace=kube-system --export -o yaml | kubectl apply --namespace=fabricrealtime -f -
        [string] $secretName = "fabric-ssl-cert"
        kubectl get secret $secretName --namespace=kube-system --export -o yaml | kubectl apply --namespace=fabricrealtime -f -
        [string] $secretName = "fabric-client-cert"
        kubectl get secret $secretName --namespace=kube-system --export -o yaml | kubectl apply --namespace=fabricrealtime -f -
        [string] $secretName = "fabric-ssl-download-cert"
        kubectl get secret $secretName --namespace=kube-system --export -o yaml | kubectl apply --namespace=fabricrealtime -f -
    }
    else {
        Write-Host "Secret fabric-ssl-cert already set so using it"
    }

    Write-Verbose 'GenerateCertificates: Done'
}

Export-ModuleMember -Function 'GenerateCertificates'