$filename = $($(Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.ps1",""))

Describe "$filename Unit Tests" -Tags 'Unit' {
    It "TestMethod" {
    }
}

Describe "$filename Integration Tests" -Tags 'Integration' {
    It "Can Install FabricRealtime Stack" {
        $packageUrl = "https://raw.githubusercontent.com/HealthCatalyst/helm.realtime/master/fabricrealtime-1.0.0.tgz"
        $namespace="fabricrealtime"

        # Arrange
        CleanOutNamespace -namespace $namespace -Verbose
        DeleteAllSecretsInNamespace -namespace $namespace -Verbose

        SaveSecretValue -secretname "certhostname" -valueName "value" -value "mycerthostname" -namespace "$namespace"
        SaveSecretPassword -secretname "mysqlrootpassword" -value "mysqlrootpassword" -namespace "$namespace"
        SaveSecretPassword -secretname "mysqlpassword" -value "mysqlpassword" -namespace "$namespace"
        SaveSecretPassword -secretname "certpassword" -value "mycertpassword" -namespace "$namespace"
        SaveSecretPassword -secretname "rabbitmqmgmtuipassword" -value "myrabbitmqmgmtuipassword" -namespace "$namespace"

        # Act
        InstallStackInKubernetes `
            -namespace $namespace `
            -package "fabricrealtime" `
            -packageUrl $packageUrl `
            -Ssl $false `
            -customerid "test" `
            -ExternalIP "104.42.148.128" `
            -InternalIP "" `
            -ExternalSubnet "" `
            -InternalSubnet "" `
            -IngressInternalType "public" `
            -IngressExternalType "public" `
            -Verbose
    }
}