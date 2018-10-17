$filename = $($(Split-Path -Leaf MyInvocation.MyCommand.Path).Replace('.Tests.ps1',''))

Describe "$filename Unit Tests" -Tags 'Unit' {
    It "TestMethod" {
    }
}

Describe "$filename Integration Tests" -Tags 'Integration' {
    It "Can install load balancers" {
        InstallLoadBalancerHelmPackage -ExternalIP "104.42.156.207"  -ExternalSubnet "" -InternalIP "11.1.7.5" -InternalSubnet "kubsubnet3-lb"
    }
}