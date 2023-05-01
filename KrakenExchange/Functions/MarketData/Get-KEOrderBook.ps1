function Get-KEOrderBook {
    <#
    .SYNOPSIS
    Retrieves the order book for a given trading pair from the Kraken exchange.

    .DESCRIPTION
    This function retrieves the order book for a given trading pair from the Kraken exchange using the Kraken API. The function returns a hashtable containing the bids and asks for the specified trading pair.

    .PARAMETER Pair
    The trading pair for which to retrieve the order book. Default is "XBTUSD".

    .PARAMETER Count
    The maximum number of orders to retrieve for each side of the order book. Default is 100.

    .EXAMPLE
    PS C:\> Get-KEOrderBook -Pair "XBTEUR" -Count 50
    Returns the top 50 bids and asks for the XBT/EUR trading pair.

    .NOTES
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023

    .LINK
    For more information, see the Kraken API documentation:
    https://docs.kraken.com/rest/#tag/Market-Data/operation/getOrderBook
    #>
    
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Pair = "XBTUSD",
    
        [Parameter()]
        [int]$Count = 100
            
    )
        
    $OrderBookMethod = "/0/public/Depth"
    $endpoint = "https://api.kraken.com"
    $OrderBookurl = $endpoint + $OrderBookMethod
    $UserAgent = "Powershell Module KrakenExchange/1.0"
   
    $OrderBookParams = [ordered]@{ 
        "pair"  = $Pair 
        "count" = $Count
    }
    $OrderBookHeaders = @{ 
        "User-Agent" = $useragent
    }
    
    $OrderBookResponse = Invoke-RestMethod -Uri $OrderBookurl -Method Get -Body $OrderBookParams -Headers $OrderBookHeaders
    
    return $OrderBookResponse
}
