function Get-KERecentSpreads {
    <#
    .SYNOPSIS
    Retrieves recent spreads for a specified trading pair from the Kraken API.
    
    .DESCRIPTION
    The Get-KERecentSpreads function uses the Kraken API to retrieve recent spreads for a specified trading pair.
    
    .PARAMETER Pair
    The trading pair for which to retrieve recent spreads. Default value is XBTUSD.
    
    .EXAMPLE
    PS C:\> Get-KERecentSpreads -Pair "ETHUSD"
    
    This example retrieves the recent spreads for the ETHUSD trading pair.

    .NOTES
    Author: wnapierala [@] hotmail.com, chatGPT
    Date: 04.2023
    The KrakenExchange PowerShell module is not affiliated with or endorsed by Kraken exchange.
    For more information, see the Kraken API documentation: 
    https://docs.kraken.com/rest/#tag/Market-Data/operation/getRecentSpreads
    #>
    [CmdletBinding()]
    param ( 
        [Parameter()]
        [ValidatePattern("^[A-Za-z0-9]{1,10}(\.[A-Za-z0-9]{1,10})?$")]
        [string]$Pair = "XBTUSD"
    )
        
    $RecentSpreadsMethod = "/0/public/Spread"
    $endpoint = "https://api.kraken.com"
    $UserAgent = "Powershell Module KrakenExchange/1.0"
    $RecentSpreadsUrl = $endpoint + $RecentSpreadsMethod
    
    $RecentSpreadsParams = [ordered]@{ 
        "pair" = $Pair 
    }
    
    $RecentSpreadsHeaders = @{ 
        "User-Agent" = $UserAgent
    }
    
    $RecentSpreadsResponse = Invoke-RestMethod -Uri $RecentSpreadsUrl -Method Get -Headers $RecentSpreadsHeaders -Body $RecentSpreadsParams
    
    return $RecentSpreadsResponse
}    
