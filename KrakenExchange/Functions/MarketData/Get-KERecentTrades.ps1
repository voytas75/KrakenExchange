function Get-KERecentTrades {
    <#
.SYNOPSIS
Retrieves recent trades for a specified trading pair on Kraken exchange.

.DESCRIPTION
The Get-KERecentTrades function retrieves recent trades for a specified trading pair on Kraken exchange. You can specify the trading pair using the Pair parameter, and the function will return the most recent trades for that pair. You can also use the SinceDate parameter to retrieve trades that occurred after a specified date and time.

.PARAMETER Pair
Specifies the trading pair for which to retrieve recent trades. The default value is "XBTUSD".

.PARAMETER SinceDate
Specifies a date and time after which to retrieve recent trades. The function will retrieve trades that occurred on or after this date and time. If this parameter is not specified, the function will retrieve 1000 recent trades.

.EXAMPLE
PS C:\> Get-KERecentTrades -Pair "XXBTZUSD" -SinceDate "04/06/2023 17:40:00"
Retrieves recent trades for the "XXBTZUSD" trading pair that occurred on or after April 1st, 2023 at 12:00 PM.

.NOTES
The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
For more information, see the Kraken API documentation: https://docs.kraken.com/rest/#tag/Market-Data/operation/getRecentTrades
Author: wnapierala [@] hotmail.com, chatGPT
Date: 04.2023
#>
    [CmdletBinding()]
    param ( 
        [Parameter()]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Pair = "XBTUSD",
 
        [datetime]$SinceDate = ((get-date).AddMinutes(-10))
    )
        
    $RecentTradesMethod = "/0/public/Trades"
    $endpoint = "https://api.kraken.com"
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $RecentTradesUrl = $endpoint + $RecentTradesMethod
    
    [string]$epoch = ([System.DateTimeOffset]::new($SinceDate.ToUniversalTime())).ToUnixTimeSeconds()

    $RecentTradesParams = [ordered]@{ 
        "pair"  = $Pair 
        "since" = $epoch
    }
    
    $RecentTradesHeaders = @{ 
        "User-Agent" = $UserAgent
    }
    
    $RecentTradesResponse = Invoke-RestMethod -Uri $RecentTradesUrl -Method Get -Headers $RecentTradesHeaders -Body $RecentTradesParams
    return $RecentTradesResponse
}    
            
     