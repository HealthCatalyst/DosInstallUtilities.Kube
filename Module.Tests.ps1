$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$functionFolder = "$here\functions"
$module = "DosInstallUtilities.Kube"

Get-Module "$module" | Remove-Module -Force

Import-Module "$here\$module.psm1" -Force

# $Credential = Get-Credential -UserName "$env:USERNAME@$env:USERDNSDOMAIN" -Message "login please"
# Connect-AzureRmAccount -Credential $Credential
Describe "$module Tests" {
    It "has the root module $module.psm1" {
        "$here\$module.psm1" | Should Exist
    }
    It "has the manifest file for $module.psm1" {
        "$here\$module.psd1" | Should Exist
    }
    It "$module folder has functions" {
        "$functionFolder" | Should Exist
    }
    It "$module is valid Powershell Code" {
        $psFile = Get-Content -Path "$here\$module.psm1" -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
        $errors.Count | Should Be 0
    }
    It "$module has no syntax errors" {
        $psFile = Get-Content -Path "$here\$module.psm1" -ErrorAction Stop
        Test-Script -script $psFile
    }

    $files = $(Get-ChildItem -Path $functionFolder -Recurse -File | Where-Object {$_.Name -notcontains "Tests.ps1"} | % { $_.FullName })

    foreach($file in $files)
    {
        Write-Host "file: $file"
        [string]$function = $file
        $function = $function.Replace($functionFolder,"")
        $function = $function.Replace(".ps1","")
        Write-Host "function: $function"

        if(!$function.EndsWith("Tests")){

            Context "Test Function $function" {
                It "$function.ps1 should exist" {
                    "$functionFolder\$function.ps1" | Should Exist
                }
                It "$function.ps1 should be an advanced function" {
                    "$functionFolder\$function.ps1" | Should Contain 'function'
                    "$functionFolder\$function.ps1" | Should Contain 'cmdletbinding'
                    "$functionFolder\$function.ps1" | Should Contain 'param'
                }
                It "$function.ps1 should contain Write-Verbose blocks" {
                    "$functionFolder\$function.ps1" | Should Contain 'Write-Verbose'
                }
                It "$function.ps1 is valid Powershell Code" {
                    $psFile = Get-Content -Path "$functionFolder\$function.ps1" -ErrorAction Stop
                    $errors = $null
                    $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                    $errors.Count | Should Be 0
                }
                It "$function.ps1 has no syntax errors" {
                    if($function -ne "\kubernetes\ingress\TroubleshootIngress"){
                        $psFile = Get-Content -Path "$functionFolder\$function.ps1" -ErrorAction Stop
                        Test-Script -script $psFile
                    }
                }
            }
            # Context "$function has tests" {
            #     It "$function.Tests.ps1 should exist" {
            #         "$functionFolder\$function.Tests.ps1" | Should Exist
            #     }
            # }
        }
    }
}