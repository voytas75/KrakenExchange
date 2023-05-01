function Get-KESystemStatus {
    <#
.SYNOPSIS
Gets the current system status for the Kraken exchange.

.DESCRIPTION
The Get-KESystemStatus function retrieves the current system status for the Kraken exchange using the Kraken API.

.EXAMPLE
PS C:\> Get-KESystemStatus
Returns the current system status for the Kraken exchange.

.OUTPUTS
Returns a PowerShell object with the following properties:
- status: A string indicating the current status of the system.
- timestamp: A timestamp indicating when the status was last updated.

.LINK
For more information, see the Kraken API documentation:
https://docs.kraken.com/rest/#tag/Market-Data/operation/getSystemStatus

.NOTES
The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
Author: wnapierala [@] hotmail.com, chatGPT
Date: 04.2023
#>
    [CmdletBinding()]
    param (    )
        
    $systemstatusMethod = "/0/public/SystemStatus"
    $endpoint = "https://api.kraken.com"
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $systemstatusheaders = @{ 
        "User-Agent" = $useragent
    }
    $systemstatusUrl = $endpoint + $systemstatusMethod
    $systemstatusResponse = Invoke-RestMethod -Uri $systemstatusUrl -Method Get -Headers $systemstatusheaders
    return $systemstatusResponse
}    
            
     