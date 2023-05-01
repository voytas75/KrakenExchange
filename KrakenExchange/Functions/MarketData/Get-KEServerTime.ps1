function Get-KEServerTime {
<#
.SYNOPSIS
This function retrieves the current server time for the Kraken exchange.

.DESCRIPTION
The Get-KEServerTime function sends a request to the Kraken exchange API to retrieve the current server time. The response contains the current time as the number of seconds since the Unix epoch.

.EXAMPLE
PS C:\> Get-KEServerTime

This example retrieves the current server time from the Kraken exchange and displays the response.

.NOTES
The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
Author: wnapierala [@] hotmail.com, chatGPT
Date: 04.2023

.LINK
For more information, see the Kraken API documentation:
https://docs.kraken.com/rest/#tag/Market-Data/operation/getServerTime
#>
    [CmdletBinding()]
    param (    )
    
    $ServerTimeMethod = "/0/public/Time"
    $endpoint = "https://api.kraken.com"
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $ServerTimeUrl = $endpoint + $ServerTimeMethod

    $ServerTimeHeaders = @{ 
        "User-Agent" = $UserAgent
    }

    $ServerTimeResponse = Invoke-RestMethod -Uri $ServerTimeUrl -Method Post -Headers $ServerTimeHeaders
    return $ServerTimeResponse
}    
        
 