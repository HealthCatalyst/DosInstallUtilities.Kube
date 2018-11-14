$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Set-StrictMode -Version Latest

# Set-Location $naPath

$ErrorActionPreference = "Stop"

$VerbosePreference = "continue"

$module = "DosInstallUtilities.Kube"
Get-Module "$module" | Remove-Module -Force

Import-Module "$here\$module.psm1" -Force

