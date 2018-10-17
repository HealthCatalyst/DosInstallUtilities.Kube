$filename = $($(Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.ps1",""))

$mockConfig = @"
{
    "azure": {
        "subscription": "Health Catalyst - Fabric",
        "resourceGroup": "fabrickubernetes",
        "location": "eastus"
    }
}
"@ | ConvertFrom-Json

Describe "$filename Unit Tests" -Tags 'Unit' {
    It "TestMethod" {
    }
}

Describe "$filename Integration Tests" -Tags 'Integration' {
    It "Can install Helm Package for realtime" {
        $packageUrl = $globals.realtimePackageUrl

        InstallHelmPackage `
            -namespace "fabricrealtime" `
            -package "fabricrealtime" `
            -packageUrl $packageUrl `
            -Ssl $false `
            -customerid "test" `
            -ExternalIP "104.42.148.128" `
            -InternalIP "" `
            -ExternalSubnet "" `
            -InternalSubnet "" `
            -IngressExternalType "public" `
            -IngressInternalType "public"
    }
}