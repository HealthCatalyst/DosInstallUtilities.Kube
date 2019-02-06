<#
.SYNOPSIS
AddFolderToPath

.DESCRIPTION
AddFolderToPath

.INPUTS
AddFolderToPath - The name of AddFolderToPath

.OUTPUTS
None

.EXAMPLE
AddFolderToPath

.EXAMPLE
AddFolderToPath


#>
function AddFolderToPath()
{
    [CmdletBinding()]
    param
    (
        [parameter (Mandatory = $false) ]
        [ValidateNotNull()]
        [string]
        $Path
    )

    Write-Verbose 'AddFolderToPath: Starting'
    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    $VerifiedPathsToAdd = $Null

    if($env:Path -like "*$Path*") {
        Write-Host "Current item in path is: $Path"
        Write-Host "$Path already exists in Path statement"
    }
    else {
        $VerifiedPathsToAdd += ";$Path"
        Write-Host "`$VerifiedPathsToAdd updated to contain: $Path"
    }

    if($VerifiedPathsToAdd -ne $null) {
        Write-Host "`$VerifiedPathsToAdd contains: $verifiedPathsToAdd"
        Write-Host "Adding $Path to Path statement now..."
        [Environment]::SetEnvironmentVariable("Path",$env:Path + $VerifiedPathsToAdd,"Process")
    }

    Write-Verbose 'AddFolderToPath: Done'
}

Export-ModuleMember -Function 'AddFolderToPath'