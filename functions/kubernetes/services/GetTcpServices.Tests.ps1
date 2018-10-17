$filename = $($(Split-Path -Leaf MyInvocation.MyCommand.Path).Replace('.Tests.ps1',''))

Describe "$filename Unit Tests" -Tags 'Unit' {
    It "TestMethod" {
    }
}

Describe "$filename Integration Tests" -Tags 'Integration' {
    It "Can Get result" {
        $result = $(GetTcpServices -namespace "fabricrealtime")
        $externalServices = $result.ExternalServices
        $externalServices.Length | Should BeGreaterThan 0
        foreach ($item in $externalServices) {
            Write-Host "External: $($item.servicename) port=$($item.port) targetPort=$($item.targetPort)"
        }
        $internalServices = $result.InternalServices
        $internalServices.Length | Should BeGreaterThan 0
        foreach ($item in $internalServices) {
            Write-Host "Internal: $($item.servicename) port=$($item.port) targetPort=$($item.targetPort)"
        }

    }
}