<#
.SYNOPSIS
DownloadFile

.DESCRIPTION
DownloadFile

.INPUTS
DownloadFile - The name of DownloadFile

.OUTPUTS
None

.EXAMPLE
DownloadFile

.EXAMPLE
DownloadFile


#>
function DownloadFile() {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $url
        ,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $targetFile
    )

    Write-Verbose 'DownloadFile: Starting'

    [hashtable]$Return = @{}

    # https://learn-powershell.net/2013/02/08/powershell-and-events-object-events/
    $web = New-Object System.Net.WebClient
    $web.UseDefaultCredentials = $True
    $Index = $url.LastIndexOf("/")
    $file = $url.Substring($Index + 1)
    $newurl = $url.Substring(0, $index)

    $Global:isDownloaded = $false

    try {

        #Some of the URLs have changed SSL versions - this should allow all SSL connections
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Ssl3 -bor [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12
        Register-ObjectEvent -InputObject $web -EventName DownloadFileCompleted `
            -SourceIdentifier Web.DownloadFileCompleted -Action {
            $Global:isDownloaded = $True
        }
        Register-ObjectEvent -InputObject $web -EventName DownloadProgressChanged `
            -SourceIdentifier Web.DownloadProgressChanged -Action {
            $Global:Data = $event
        }
        $web.DownloadFileAsync($url, ($targetFile -f $file))

        $receivedBytes = 0
        $totalBytes = 0

        While (-Not $Global:isDownloaded) {
            if ($Global:Data) {
                if ($Global:Data.SourceArgs.PSobject.Properties.name -match "ProgressPercentage") {
                    $percent = $Global:Data.SourceArgs.ProgressPercentage
                    $totalBytes = $Global:Data.SourceArgs.TotalBytesToReceive
                    $receivedBytes = $Global:Data.SourceArgs.BytesReceived
                    If ($null -ne $percent) {
                        Write-Progress -Activity ("Downloading {0} from {1}" -f $file, $newurl) `
                            -Status ("{0} bytes \ {1} bytes" -f $receivedBytes, $totalBytes)  -PercentComplete $percent
                    }
                }
            }
        }
        Write-Progress -Activity ("Downloading {0} from {1}" -f $file, $newurl) `
            -Status ("{0} bytes \ {1} bytes" -f $receivedBytes, $totalBytes)  -Completed
    }
    finally {
        Unregister-Event -SourceIdentifier Web.DownloadFileCompleted
        Unregister-Event -SourceIdentifier Web.DownloadProgressChanged
    }

    Write-Information -MessageData "Finished downloading $url"

    Write-Verbose 'DownloadFile: Done'
    return $Return
}

Export-ModuleMember -Function 'DownloadFile'