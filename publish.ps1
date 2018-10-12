$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = "DosInstallUtilities.Kube"

Import-Module PowerShellGet

Get-Module "$module" | Remove-Module -Force

Import-Module "$here\$module.psm1" -Force -Verbose

$apikey = Read-Host -Prompt "Please enter the API key"
Publish-Module -Name "$here\$module.psm1" -NuGetApiKey $apikey