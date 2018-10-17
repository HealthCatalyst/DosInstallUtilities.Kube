$filename = $($(Split-Path -Leaf MyInvocation.MyCommand.Path).Replace('.Tests.ps1',''))

Describe "$filename Unit Tests" -Tags 'Unit' {
    It "TestMethod" {
    }
}

Describe "$filename Integration Tests" -Tags 'Integration' {
    It "Can Get result" {
        $result = $(GetServicesWithExternalLabel -namespace "fabricrealtime").Services
        $result.Length | Should BeGreaterThan 0
        foreach ($item in $result) {
            Write-Host "$($item.servicename) port=$($item.port) targetPort=$($item.targetPort)"
        }

    }
}