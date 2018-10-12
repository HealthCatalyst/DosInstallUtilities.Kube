$module = Get-Module -Name "DosInstallUtilities.Kube"
$module | Select-Object *

$params = @{
    'Author' = 'Health Catalyst'
    'CompanyName' = 'Health Catalyst'
    'Description' = 'Functions to configure Kubernetes'
    'NestedModules' = 'DosInstallUtilities.Kube'
    'Path' = ".\DosInstallUtilities.Kube.psd1"
}

New-ModuleManifest @params
